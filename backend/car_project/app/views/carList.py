from flask import jsonify, Blueprint

from app.models.CarInfo import CarInfo

bp = Blueprint('carList', __name__)

# 추후에 차종 값을 추가할 수도 있음
@bp.route('/list/<int:user_id>', methods=['GET'])
def get_car_list(user_id):
    cars = CarInfo.query.filter_by(user_id=user_id).all()  # 해당 유저 ID를 가진 차량 정보 조회
    car_list = [(car.car_number, car.create_at) for car in cars]  # 차량 번호와 등록일자로 이루어진 리스트 생성
    response = {
        'len': len(car_list),
        'car_list': car_list
    }
    return jsonify(response)

