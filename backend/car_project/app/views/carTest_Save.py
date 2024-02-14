from flask import request, jsonify, Blueprint
from app import db
from app.models.CarInfo import CarInfo
from app.models.CarckInfo import CarckInfo

bp = Blueprint('carTest_Save', __name__)

@bp.route('/save', methods=['POST'])
def save_car_info():
    data = request.json
    if 'car_number' not in data or 'accident_info' not in data:
        return jsonify({'error': '차량 번호 및 사고 정보가 필요합니다.'}), 400

    car_number = data['car_number']
    accident_info = data['accident_info']

    # 차량 정보 확인
    car = CarInfo.query.filter_by(car_number=car_number).first()
    if not car:
        car = CarInfo(car_number=car_number)
        db.session.add(car)

    # 사고 정보 저장
    carck_infos = []
    for info in accident_info:
        carck_info = CarckInfo(
            car=car,
            section=info['section'],
            carck=info['carck'],
            image_path=info['image_path']
        )
        carck_infos.append(carck_info)

    # 데이터베이스에 반영
    db.session.add_all(carck_infos)
    db.session.commit()

    # 응답 생성
    response_accident_info = [{
        'image_path': carck.image_path,
        'area': carck.section,
        'crash': carck.carck
    } for carck in carck_infos]
    response = {
        'car_number': car_number,
        'accident_info': response_accident_info
    }
    return jsonify(response)

