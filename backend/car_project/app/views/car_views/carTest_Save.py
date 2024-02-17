# cartestsave_test
from flask import request, jsonify, Blueprint

from app import db
from app.models.car_model import Car
from app.models.crack_model import Crack


import json


bp = Blueprint('carTest_Save', __name__, url_prefix='/check')

# route = /create
# 완성이 되지 않으면 => 대시보드가 아닌 체크 페이지로 다시 넘어갈 수 있도록 (아직 구현 안됌)

@bp.route('/create', methods=['POST'])
def create_car():
    # POST 요청에서 데이터 가져오기
    data = request.json
    user_id = data.get('user_id')
    car_number = data.get('car_number')
    car_type = data.get('car_type')

    # 새로운 Car 객체 생성
    new_car = Car(user_id=user_id, car_number=car_number, car_type=car_type)

    # 데이터베이스에 추가
    db.session.add(new_car)
    db.session.commit()

    return jsonify({'message': 'Car created successfully'}), 201

# route = /list
# 현재 차량의 검사 현황 리스트를 조회


@bp.route('/save', methods=['POST'])
def save_car_info():
    data = request.json
    if 'car_number' not in data or 'accident_info' not in data:
        return jsonify({'error': '차량 번호 및 사고 정보가 필요합니다.'}), 400

    car_number = data['car_number']
    accident_info = data['accident_info']

    # 차량 정보 확인
    car = Car.query.filter_by(car_number=car_number).first()
    if not car:
        car = Car(car_number=car_number)
        db.session.add(car)

    # -----------------------------

    # 사고 정보 저장
    cracks = []
    for info in accident_info:
        crack = Crack(
            car=car,
            section=info['section'],
            degree=info['degree'],
            image_path=info['image_path']
        )
        cracks.append(crack)

    # 데이터베이스에 반영
    db.session.add_all(cracks)
    db.session.commit()

    # 응답 생성
    response_accident_info = [{
        'image_path': crack.image_path,
        'section': crack.section,
        'degree': crack.degree
    } for crack in cracks]
    response = {
        'car_number': car_number,
        'accident_info': response_accident_info
    }
    return jsonify(response)

@bp.route('/register', methods=['POST'])
def register_car():

    # Crack 객체 생성 및 데이터베이스에 저장
    # car_id는 요청에 포함될 예정
    # Null 보다는 특정 값이라도 있는게 좋다.
    crack = Crack(car_id= 1,section=-1, crack=-1, image_path=image_url)
    db.session.add(crack)
    db.session.commit()


    return jsonify({'message': 'Car registered successfully'}), 200
