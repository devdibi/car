# 차량 관련 기본 기능 view
from flask import Blueprint, request
from app.response.response import Response

from app.models.car_model import Car
from app.models.section_model import Section
from app.models.user_model import User

from app import db

bp = Blueprint('car_list', __name__, url_prefix='/car')

# 차량 목록 조회 route
@bp.route('/list/<int:user_id>', methods=['GET'])
def get_car_list(user_id):
    user = User.query.filter_by(id=user_id).first()

    # 유저 존재 여부 파악
    if User.query.filter_by(id=user_id).first() is None:
        return Response(400, "존재하지 않는 유저입니다.", []).json(), 400

    # 차량이 존재하지 않음.
    if len(user.cars) == 0:
        return Response(200, "차량이 없습니다.", []).json(), 200

    # 차량 번호, 등록 일자, 차종 dict 생성
    car_list = [{'id': car.id, 'car_number': car.car_number, 'created_at': car.create_at, 'car_type': car.car_type, 'checked': car.checked} for car in user.cars]
    print(car_list)
    return Response(200, "차량 목록을 성공적으로 조회했습니다.", car_list).json(), 200

# 차량 등록 route
@bp.route('/register', methods=['POST'])
def register_car():
    body = request.json

    # 요청에 해당 변수가 존재 하는지 확인(유효성 검증)
    if body['user_id'] is None or body['car_number'] is None or body['car_type'] is None:
        return Response(400, "잘못된 요청입니다.", []).json(), 400

    car = Car(user_id=body['user_id'], car_number=body['car_number'], car_type=body['car_type'], )

    # db에 저장
    db.session.add(car)
    db.session.commit()

    for i in range(4):
        section = Section(car_id=car.id, section=i)
        db.session.add(section)
        db.session.commit()
        print(section.id)

    data = {'car_id': car.id, 'user_id': body['user_id'], 'car_number': body['car_number'], "car_type": body['car_type']}

    return Response(200, "차량 등록이 성공적으로 완료되었습니다.", data).json(), 200

# 차량 상세 정보 route
@bp.route('/detail/<int:car_id>', methods=['GET'])
def get_car_detail(car_id):
    # 해당 차량 id를 가진 차량 정보 조회
    car = Car.query.filter_by(id=car_id).first()

    if car is None:
        return Response(200, "차량 정보가 없습니다.", None).json(), 200

    # 차량의 모든 정보를 한번에 조회
    car_detail = {
        'id': car.id,
        'car_number': car.car_number,
        'created_at': car.create_at,
        'car_type': car.car_type,
        'checked': car.checked,
        'sections': [
            {
            'id': section.id,
            'checked' : section.checked,
            'section': section.section,
            'image_path': section.image_path,
            'cracks': [
                {
                    'id': crack.id,
                    'degree': crack.degree,
                    'lt': crack.lt,
                    'lb': crack.lb,
                    'rb': crack.rb,
                    'rt': crack.rt,
                }
                for crack in section.cracks]
            }
            for section in car.sections]
    }

    # 검사 페이지로 이동 시킬 예정
    if not car.checked:
        return Response(200, "차량 검사가 완료 되지 않았습니다.", car_detail).json(), 200

    return Response(200, "차량의 상세 정보를 성공적으로 조회했습니다.", car_detail).json(), 200



@bp.route('/complete', methods=['PATCH'])
def complete():
    car_id = request.json.get('car_id')

    # 해당하는 레코드 찾기
    car = db.session.query(Car).filter_by(id=car_id).first()

    if car:
        # 이미지 URL 업데이트
        car.checked = 1

        db.session.commit()
        return "이미지 URL이 업데이트되었습니다."
    else:
        return "해당하는 레코드를 찾을 수 없습니다."
