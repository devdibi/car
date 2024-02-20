from flask import Blueprint
from google.cloud import storage
from google.cloud import aiplatform
from google.cloud.aiplatform.gapic.schema import predict
import base64
from app.models.crack_model import Crack

from app import db
from dotenv import load_dotenv

load_dotenv()
import os

bp = Blueprint('imageDetection', __name__, url_prefix='/car')
@bp.route('/imageDetection', methods=['GET'])
def imageDetection():

    # Google Cloud Storage 클라이언트 생성
    storage_client = storage.Client(project=os.getenv("PROJECT_ID"))

    # 버킷 객체 생성
    bucket = storage_client.bucket(os.getenv("BUCKET_NAME"))


    # 폴더 안에 있는 파일들 가져오기
    blobs = bucket.list_blobs(prefix=f"{os.getenv('FOLDER1')}/")

    predictions_all = []
    for blob in blobs:
        if blob.name.endswith(('.jpg', '.jpeg', '.png')):
            blob_bytes = blob.download_as_string()
            # 이미지 파일 인코딩
            encoded_content = base64.b64encode(blob_bytes).decode("utf-8")

            # 예측 요청 생성
            instance = predict.instance.ImageClassificationPredictionInstance(
                content=encoded_content,
            ).to_value()

            instances = [instance]

            # 모델 파라미터 설정
            parameters = predict.params.ImageClassificationPredictionParams(
                confidence_threshold=0.2,
                max_predictions=5,
            ).to_value()

            # 클라이언트 초기화 및 예측 수행
            client_options = {"api_endpoint": os.getenv("ENDPOINT_API")}
            client = aiplatform.gapic.PredictionServiceClient(client_options=client_options)
            endpoint = client.endpoint_path(
                project=os.getenv("PROJECT_ID"), location=os.getenv("LOCATION"), endpoint=os.getenv("ENDPOINT_ID_1")
            )

            response = client.predict(endpoint=endpoint, instances=instances, parameters=parameters)

            # 예측 결과 수집
            predictions = response.predictions
            predictions_json = [dict(prediction) for prediction in predictions]

            # 예측 결과에서 필요한 정보 추출
            bboxes = predictions_json[0]['bboxes']
            confidences = predictions_json[0]['confidences']
            display_names = predictions_json[0]['displayNames']
            ids = predictions_json[0]['ids']


            # 예측 결과를 Crack 모델에 저장
            for idx, bbox in enumerate(bboxes):
                # x_min, x_max, y_min, y_max 값 추출
                x_min = bbox[0]
                x_max = bbox[1]
                y_min = bbox[2]
                y_max = bbox[3]

                # 신뢰도 값 추출
                confidence = confidences[idx]

                # display name, id 값 추출 (optional)
                display_name = display_names[idx]
                prediction_id = ids[idx]


                # Crack 모델에 저장
                crack = Crack(x_min=x_min, x_max=x_max, y_min=y_min, y_max=y_max, confidence=confidence)
                db.session.add(crack)
                db.session.commit()

    return "hello"