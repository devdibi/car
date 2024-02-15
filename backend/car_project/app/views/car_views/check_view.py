# 차량 검사 view

from flask import jsonify, Blueprint, request

from app.models.car_model import Car
from app.models.crack_model import Crack

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

# 1. 이미지를 저장하는 route

# 2. ai model로 요청하는 route

# 3. 모든 검사를 완료 하는 route

