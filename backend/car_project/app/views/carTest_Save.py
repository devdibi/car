from flask import request, jsonify, Blueprint

from app import db
from app.models.CarInfo import CarInfo
from app.models.CrackInfo import CrackInfo
from app.upload import upload_image

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

    @bp.route('/register', methods=['POST'])
    def register_car():
        image_file = request.files.get('image')

        # 이미지를 버킷에 업로드하고 URL을 받아옴
        image_url = upload_image(image_file, image_file.filename)

        # CrackInfo 객체 생성 및 데이터베이스에 저장
        crack_info = CrackInfo(car_id=None, section=None, crack=None, image_path=image_url)
        db.session.add(crack_info)
        db.session.commit()

        return jsonify({'message': 'Car registered successfully'}), 200

    # 사고 정보 저장
    crack_infos = []
    for info in accident_info:
        crack_info = CrackInfo(
            car=car,
            section=info['section'],
            crack=info['crack'],
            image_path=info['image_path']
        )
        crack_infos.append(crack_info)

    # 데이터베이스에 반영
    db.session.add_all(crack_infos)
    db.session.commit()

    # 응답 생성
    response_accident_info = [{
        'image_path': crack.image_path,
        'area': crack.section,
        'crash': crack.crack
    } for crack in crack_infos]
    response = {
        'car_number': car_number,
        'accident_info': response_accident_info
    }
    return jsonify(response)

