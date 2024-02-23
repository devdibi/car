from google.cloud import storage, aiplatform
from google.cloud.aiplatform.gapic.schema import predict

import base64
import os
import io

from io import BytesIO
from PIL import Image
from app import db
from app.models.crack_model import Crack


PROJECT_ID = os.getenv('PROJECT_ID')
ENDPOINT_ID_1 = os.getenv('ENDPOINT_ID_1')
ENDPOINT_ID_2 = os.getenv('ENDPOINT_ID_2')
LOCATION = os.getenv('LOCATION')
ENDPOINT_API = os.getenv('ENDPOINT_API')
BUCKET_NAME = os.getenv('BUCKET_NAME')
CUT = os.getenv('CUT')
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = os.getenv('FILENAME')
DETECTION = os.getenv('DETECTION')

# 파일 업로드시 이미지 크기 조정 후 업로드
def image_cut(file, car):
    # base64 디코드 및 이미지 열기
    img = Image.open(file.stream)

    # 이미지 자르기
    width, height = img.size
    left = (width - 640) / 2
    top = (height - 480) / 2
    right = (width + 640) / 2
    bottom = (height + 480) / 2
    cropped_img = img.crop((left, top, right, bottom))

    # Google Cloud Storage 클라이언트 설정
    client = storage.Client()

    filename = f"{car.section}.png"  # 저장할 파일 이름

    bucket = client.bucket(BUCKET_NAME)

    # 업로드할 이미지 Blob 생성 (폴더 경로를 포함한 이름 지정)
    blob = bucket.blob(f"CAR/{car.car_id}/{car.section}/RAW/{filename}")

    # 이미지 데이터를 메모리에 저장하여 바로 업로드
    img_byte_array = BytesIO()
    cropped_img.save(img_byte_array, format='PNG')
    img_byte_array.seek(0)  # 파일의 처음으로 이동해야 합니다.
    blob.upload_from_file(img_byte_array, content_type='image/png')

    return blob.public_url

# 이미지 Detection 전에 자르기
def detected_cut(x_min, x_max, y_min, y_max, car, crack_id):
    # Google Cloud 설정
    client = storage.Client()

    bucket = client.bucket(BUCKET_NAME)

    blob = bucket.blob(f"CAR/{car.car_id}/{car.section}/RAW/{car.section}.png")

    # 이미지 파일 읽어오고 자르기
    image_bytes = blob.download_as_string()

    image = Image.open(io.BytesIO(image_bytes))

    width, height = image.size
    x1 = x_min * width
    x2 = x_max * width
    y1 = y_min * height
    y2 = y_max * height

    cropped_image = image.crop((x1, y1, x2, y2))
    blob = bucket.blob(f"CAR/{car.car_id}/{car.section}/DETECTION/{crack_id}.png")

    # 이미지 데이터 업로드
    img_byte_array = BytesIO()
    cropped_image.save(img_byte_array, format='PNG')
    img_byte_array.seek(0)  # 파일의 처음으로 이동해야 합니다.
    blob.upload_from_file(img_byte_array, content_type='image/png')

    return f"CAR/{car.car_id}/{car.section}/DETECTION/{crack_id}.png"

def image_detection(car_section):
    # Google Cloud Storage 클라이언트 생성
    storage_client = storage.Client()

    # 버킷 객체 생성
    bucket = storage_client.bucket(BUCKET_NAME)

    # 폴더 안에 있는 파일들 가져오기
    blobs = bucket.list_blobs(prefix=f"CAR/{car_section.car_id}/{car_section.section}/RAW/")

    predictions_all = []
    for blob in blobs:
        if blob.name.endswith(('.jpg', '.jpeg', '.png')):
            blob_bytes = blob.download_as_bytes()  # 바이트로 가져옴

            # 이미지 파일 인코딩
            encoded_content = base64.b64encode(blob_bytes).decode("utf-8")

            # 예측 요청 생성
            instance = predict.instance.ImageClassificationPredictionInstance(
                content=encoded_content,
            ).to_value()
            instances = [instance]

            # 모델 파라미터 설정
            parameters = predict.params.ImageClassificationPredictionParams(
                confidence_threshold=0.5,
                max_predictions=10
            ).to_value()

            # 클라이언트 초기화 및 예측 수행
            client_options = {"api_endpoint": ENDPOINT_API}  # ENDPOINT_API 대신 api_endpoint 사용
            client = aiplatform.gapic.PredictionServiceClient(client_options=client_options)
            endpoint = client.endpoint_path(
                project=PROJECT_ID, location=LOCATION, endpoint=ENDPOINT_ID_1
            )
            response = client.predict(
                endpoint=endpoint, instances=instances, parameters=parameters
            )

            # 예측 결과 수집
            predictions = response.predictions
            predictions_json = [dict(prediction) for prediction in predictions]
            predictions_all.append(predictions_json)


    # 예측 결과에서 필요한 정보 추출
    bboxes = []
    confidences = []
    ids = []
    for prediction_dict in predictions_all:
        bbox = prediction_dict[0]['bboxes']  # 리스트의 첫 번째 요소 사용
        confidence = prediction_dict[0]['confidences']
        id_ = prediction_dict[0]['ids']
        bboxes.append(bbox)
        confidences.append(confidence)
        ids.append(id_)

    # 예측 결과를 Crack 모델에 저장
    for idx, bbox in enumerate(bboxes):
        if len(bbox) == 0:
            break

        # x_min, x_max, y_min, y_max 값 추출
        x_min = bbox[0][0]
        x_max = bbox[0][1]
        y_min = bbox[0][2]
        y_max = bbox[0][3]

        # Crack 모델에 저장
        crack = Crack(section_id=car_section.id, degree=0, x_min=x_min, x_max=x_max, y_min=y_min, y_max=y_max, confidence=0)
        db.session.add(crack)

        db.session.commit()

        # detected_cut() 함수 호출
        file_path = detected_cut(x_min, x_max, y_min, y_max, car_section, crack.id)

        crack.image_path = file_path

        db.session.commit()




# 클래스 레이블과 숫자 매핑 딕셔너리
class_mapping = {
    'Scratched': 0,
    'Crushed': 1,
    'Breakage': 2,
    'Separated': 3,
    'Normal': 4
}

def image_classification(car_section):
    # Google Cloud Storage 클라이언트 생성
    storage_client = storage.Client()

    # 버킷 객체 생성
    bucket = storage_client.bucket(BUCKET_NAME)

    # 폴더 안에 있는 파일들 가져오기
    blobs = bucket.list_blobs(prefix=f"CAR/{car_section.car_id}/{car_section.section}/DETECTION/")

    for blob in blobs:
        if blob.name.endswith(('.jpg', '.jpeg', '.png')):
            file_name = os.path.basename(blob.name).split(".")[0]

            blob_bytes = blob.download_as_bytes()  # 바이트로 가져옴

            # 이미지 파일 인코딩
            encoded_content = base64.b64encode(blob_bytes).decode("utf-8")

            # 예측 요청 생성
            instance = predict.instance.ImageClassificationPredictionInstance(
                content=encoded_content,
            ).to_value()
            instances = [instance]

            # 모델 파라미터 설정
            parameters = predict.params.ImageClassificationPredictionParams(
                confidence_threshold=0.5,
                max_predictions=5,
            ).to_value()

            # 클라이언트 초기화 및 예측 수행
            client_options = {"api_endpoint": ENDPOINT_API}
            client = aiplatform.gapic.PredictionServiceClient(client_options=client_options)
            endpoint = client.endpoint_path(
                project=PROJECT_ID, location=LOCATION, endpoint=ENDPOINT_ID_2
            )
            response = client.predict(
                endpoint=endpoint, instances=instances, parameters=parameters
            )

            # 예측 결과 수집
            predictions = response.predictions

            temp = [dict(prediction) for prediction in predictions]

            # temp의 여부 판별
            if len(temp) == 0 or len(temp[0]['confidences']) == 0 or len(temp[0]['displayNames']) == 0:
                Crack.query.filter_by(id=int(file_name)).delete()
                db.session.commit()
                continue

            crack = Crack.query.filter_by(id=int(file_name)).first()

            num = class_mapping.get(temp[0]['displayNames'][0])

            if num is None:
                Crack.query.filter_by(id=int(file_name)).delete()
                db.session.commit()
                continue

            crack.degree = num
            crack.confidence = temp[0]['confidences'][0]

            db.session.commit()

    db.session.close()


