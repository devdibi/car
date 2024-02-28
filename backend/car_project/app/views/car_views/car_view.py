# 차량 관련 기본 기능 view
from flask import Blueprint, request
from app.response.response import Response

from app.models.car_model import Car
from app.models.section_model import Section
from app.models.user_model import User
from app.models.crack_model import Crack
from app.views.image_views.recognition_util import image_detection, image_classification
from app import db

from app.views.image_views.recognition_util import image_cut

bp = Blueprint('car_list', __name__, url_prefix='/car')

# 차량 목록 조회 route
@bp.route('/list/<int:user_id>', methods=['GET'])
def get_car_list(user_id):
    # 유저 정보 조회
    user_data = User.query.filter_by(id=user_id).first()

    # 유저 존재 여부 파악
    if user_data is None:
        return Response(400, "존재하지 않는 유저입니다.", []).json(), 400

    # 차량이 존재하지 않음.
    if len(user_data.cars) == 0:
        return Response(200, "차량이 없습니다.", []).json(), 200

    # 차량 번호, 등록 일자, 차종 dict 생성
    car_list = [{'id': car.id, 'car_number': car.car_number, 'created_at': car.create_at, 'car_type': car.car_type, 'checked': car.checked, 'rentable': car.rentable} for car in user_data.cars]

    print(f"차량 목록 조회 : {car_list}")  # debug

    return Response(200, "차량 목록을 성공적으로 조회했습니다.", car_list).json(), 200

# 차량 등록 route
@bp.route('/register', methods=['POST'])
def regist_car():
    body = request.json  # request body

    # 요청에 해당 변수가 존재 하는지 확인(유효성 검증)
    if body['user_id'] is None or body['car_number'] is None or body['car_type'] is None:
        return Response(400, "잘못된 요청입니다.", []).json(), 400

    # car 객체 생성
    car_data = Car(user_id=body['user_id'], car_number=body['car_number'], car_type=body['car_type'])

    # db에 저장
    db.session.add(car_data)
    db.session.commit()

    # car 객체에 종속된 section 객체 4개 생성
    for i in range(4):
        section_data = Section(car_id=car_data.id, section=i)
        db.session.add(section_data)
        db.session.commit()

    # 응답 데이터 생성
    data = {'car_id': car_data.id, 'user_id': body['user_id'], 'car_number': body['car_number'], "car_type": body['car_type']}

    print(f"차량 등록 : {data}")  # debug

    return Response(200, "차량 등록이 성공적으로 완료되었습니다.", data).json(), 200

# 차량 상세 정보 route
@bp.route('/detail/<int:car_id>', methods=['GET'])
def get_car_detail(car_id):
    # 해당 차량 id를 가진 차량 정보 조회
    car_data = Car.query.filter_by(id=car_id).first()

    if car_data is None:
        return Response(200, "차량 정보가 없습니다.", None).json(), 200

    # 차량의 모든 정보를 한번에 조회
    data = {
        'id': car_data.id,
        'car_number': car_data.car_number,
        'created_at': car_data.create_at,
        'car_type': car_data.car_type,
        'checked': car_data.checked,
        'sections': [
            {
            'id': section_data.id,
            'checked' : section_data.checked,
            'section': section_data.section,
            'image_path': section_data.image_path,
            'cracks': [
                {
                    'id': crack_data.id,
                    'degree': crack_data.degree,
                    'x_min': crack_data.x_min,
                    'x_max': crack_data.x_max,
                    'y_min': crack_data.y_min,
                    'y_max': crack_data.y_max,
                }
                for crack_data in section_data.cracks]
            }
            for section_data in car_data.sections]
    }

    # 검사 페이지로 이동 시킬 예정
    if not data['checked']:
        return Response(200, "차량 검사가 완료 되지 않았습니다.", data).json(), 200

    print(f"차량 상세 정보 : {data}")

    return Response(200, "차량의 상세 정보를 성공적으로 조회했습니다.", data).json(), 200


# 차량 정보 저장
@bp.route('/complete', methods=['PATCH'])
def complete():
    car_id = request.json.get('car_id')

    # 해당하는 레코드 찾기
    car_data = db.session.query(Car).filter_by(id=car_id).first()

    # 차량 정보 저장 상태 변경
    if car_data:
        car_data.checked = 1
        db.session.commit()

        data = {'id': car_data.id, 'car_number': car_data.car_number, 'created_at': car_data.create_at, 'car_type': car_data.car_type, 'checked': car_data.checked}

        print(f"차량 저장 : {data}")

        return Response(200, "차량의 정보를 저장했습니다.", data).json(), 200
    else:
        return Response(404, "차량의 정보를 찾을 수 없습니다.", {}).json(), 404

# section의 손상 정보 조회
@bp.route('/crack/<int:section_id>', methods=['GET'])
def crack(section_id):
    # 손상 정보 조회
    cracks = db.session.query(Crack).filter_by(section_id=section_id)

    if cracks is None:
        return Response(200, "차량의 정보가 존재하지 않습니다.", []).json(), 200

    # 손상 정보 리스트
    data = [
        {
            'id': crack_data.id,
            'degree': crack_data.degree,
            'x_min': crack_data.x_min,
            'x_max': crack_data.x_max,
            'y_min': crack_data.y_min,
            'y_max': crack_data.y_max,
            "confidence" : crack_data.confidence
        }
        for crack_data in cracks]

    print("손상 정보 : {data}")

    return Response(200, "차량의 손상 정보를 성공적으로 조회했습니다.", data).json(), 200

# section의 정보 조회
@bp.route('/section/<int:section_id>', methods=['GET'])
def section(section_id):
    section_data = Section.query.filter_by(id=section_id).first()

    data = {
        "section": section_data.section,
        "car_id": section_data.car_id,
        "checked": section_data.checked,
        "image_path": section_data.image_path
    }

    print(f"section의 정보 조회 {data}")

    return Response(200, "구역의 정보를 조회 했습니다.", data).json(), 200

# Image upload => Detection => upload => Classification
@bp.route('/upload', methods=['POST'])
def upload():
    if 'file' not in request.files:
        return Response(400, "잘못된 요청입니다.", None).json(), 400

    # 파일 변수 할당
    file = request.files['file']

    # 파일이 존재하지 않음
    if file.filename == '':
        return Response(404, "파일이 존재하지 않습니다.", None).json(), 404

    # 파일이 있는 경우 section의 정보 변수 할당
    section_id = request.form['section_id']  # section id
    section = request.form['section']

    car = Section.query.filter_by(id=section_id, section=section).first()  # section_id를 통해 차량 id 탐색

    car.image_path = image_cut(file, car)  # 점검 부위 정보 기준으로 이미지 크기 조정
    db.session.commit()  # db 저장

    data = {
        "image_path": car.image_path,
    }

    return Response(200, "성공적으로 이미지를 업로드 했습니다.", data).json() , 200

@bp.route('/detection', methods=['POST'])
def detection():
    request_data = request.json

    section_id = request_data['section_id']  # section id
    section = request_data['section']

    car_section = Section.query.filter_by(id=section_id, section=section).first()  # section_id를 통해 차량 id 탐색

    image_detection(car_section)  # 이미지 Detection 수행

    # 손상 정보 응답 생성
    cracks = Crack.query.filter_by(section_id=section_id)

    data = [
        {
            'id': crack_data.id,
            'degree': crack_data.degree,
            'x_min': crack_data.x_min,
            'x_max': crack_data.x_max,
            'y_min': crack_data.y_min,
            'y_max': crack_data.y_max,
            "confidence": crack_data.confidence
        }
        for crack_data in cracks]

    print(f"손상 정보 조회 : {data}")
    return Response(200, 'detection 완료', data).json(), 200

@bp.route('/classification', methods=['PATCH'])
def classification():
    request_data = request.json

    section_id = request_data['section_id']  # section id
    section = request_data['section']

    car_section = Section.query.filter_by(id=section_id, section=section).first()  # section_id를 통해 차량 id 탐색

    image_classification(car_section)

    # 손상 정보 응답 생성
    cracks = Crack.query.filter_by(section_id=section_id)

    data = [
        {
            'id': crack_data.id,
            'degree': crack_data.degree,
            'x_min': crack_data.x_min,
            'x_max': crack_data.x_max,
            'y_min': crack_data.y_min,
            'y_max': crack_data.y_max,
            "confidence": crack_data.confidence
        }
        for crack_data in cracks]

    print(f"손상 정보 조회 : {data}")
    return Response(200, 'classification 완료', data).json(), 200
