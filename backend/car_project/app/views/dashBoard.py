from flask import jsonify, Blueprint

from app.models.CarInfo import CarInfo

bp = Blueprint('dashBoard', __name__)

# 대시보드 엔드포인트
@bp.route('/dashboard/<int:car_id>', methods=['GET'])
def get_dashboard(car_id):
    car_info = CarInfo.query.filter_by(id=car_id).first()
    if car_info:
        crack_info = []
        for crack in car_info.crack_info:
            crack_info.append({
                'image_path': crack.image_path,
                'section': crack.section,
                'crack': crack.crack
            })
        response = {
            'car_number': car_info.car_number,
            'accident_info': crack_info
        }
        return jsonify(response)
    else:
        return jsonify({'error': 'Car not found'})
