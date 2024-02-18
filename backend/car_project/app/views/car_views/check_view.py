# 차량 검사 view

from flask import jsonify, Blueprint, request
from google.cloud import storage, aiplatform
import os

from app.models.section_model import Section
from app.models.crack_model import Crack
from app import db

bp = Blueprint('checkCar', __name__, url_prefix='/check')

@bp.route('/list/<int:car_id>', methods=['GET'])
def get_car_list(car_id):

    cracks = Crack.query.filter_by(car_id=car_id).all()  # 해당 차량의 검사 정보 조회
    print(cracks)
    crack_list = [(crack.section, crack.degree) for crack in cracks]

    response = {
        'crack_list': crack_list
    }

    return jsonify(response)

# 이미지 url 받고 DB 저장
@bp.route('/DB',methods=['POST'])
def save_DB():

    # Google 서비스 계정 키 파일의 경로 가져오기
    credentials_path = os.environ.get('GOOGLE_APPLICATION_CREDENTIALS')
    # 클라이언트 생성
    client = storage.Client.from_service_account_json(credentials_path)
    # 버킷 설정
    bucket_name = os.environ.get('BUCKET_NAME')
    bucket = client.bucket(bucket_name)

    # 이미지 url 가져오기 (아마 프론트엔드가 json으로 image_url를 주겠죠?)
    image_url = request.json.get('image_url')

    # SQLAlchemy를 사용하여 이미지 URL을 데이터베이스에 저장
    new_section = Section(image_path=image_url)
    db.session.add(new_section)
    db.session.commit()


# 경로를 ai 모델에게 보내고 응답 DB저장
def get_results_from_ai_model():
    # 데이터베이스에서 이미지 URL을 가져오기
    sections = Section.query.all()
    image_urls = [section.image_path for section in sections]

    # AI 모델 엔드포인트 초기화
    endpoint = 'projects/{}/locations/{}/endpoints/{}'.format(
        project_id,
        endpoint_region,
        endpoint_id
    )
    client_options = {'api_endpoint': 'endpoint_api'}
    prediction_client = aiplatform.gapic.PredictionServiceClient(client_options=client_options)

    # 가져온 이미지 URL을 AI 모델에 전달하고 결과를 받기
    results = []
    for image_url in image_urls:
        # AI 모델에 전달할 요청 생성
        request = {
            "instances": [{"image_url": image_url}]
        }
        response = prediction_client.predict(endpoint=endpoint, instances=request)

        # 결과 추출
        result = response.predictions
        results.append(result)

    return results