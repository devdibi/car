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
@bp.route('/DB',methods=['PATCH'])
def save_DB():
    car_id = request.json.get('car_id')
    section = request.json.get('section')
    image_url = request.json.get('image_url')
    check_value = request.json.get('check_value')

    # 해당하는 레코드 찾기
    car_to_update = db.session.query(Section).filter_by(car_id=car_id, section=section).first()


    if car_to_update:
      # 이미지 URL 업데이트
        car_to_update.image_path = image_url
        car_to_update.checked = check_value

        db.session.commit()

        return "이미지 URL이 업데이트되었습니다."
    else:
        return "해당하는 레코드를 찾을 수 없습니다."

# 차랑 정보 저장
@bp.route('/save', methods =['PATCH'])
def save():
    car_id = request.json.get('car_id')
    section = request.json.get('section')
    check_value = request.json.get('check_value')

    # 해당하는 레코드 찾기
    car_to_update = db.session.query(Section).filter_by(car_id=car_id, section=section).first()

    if car_to_update:
        # 이미지 URL 업데이트
        car_to_update.checked = check_value

        db.session.commit()
        return "상태가 변경되었습니다.."
    else:
        return "해당하는 레코드를 찾을 수 없습니다."


# 경로를 ai 모델에게 보내고 응답 DB저장
def save_db():
    # 데이터베이스에서 이미지 URL을 가져오기 (image_path가 null이 아닌 경우만)
    sections = Section.query.filter(Section.image_path != None).all()

    # 가져온 섹션 객체들에서 이미지 URL만 추출
    image_urls = [section.image_path for section in sections]

    # AI 모델 엔드포인트 초기화
    prediction_client = aiplatform.gapic.PredictionServiceClient(
        client_options={"api_endpoint": f"{endpoint_region}-aiplatform.googleapis.com"}
    )
    endpoint = f"projects/{project_id}/locations/{endpoint_region}/endpoints/{endpoint_id}"

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
