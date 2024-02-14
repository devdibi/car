from flask import request, jsonify, Blueprint

from app import db
from app.models.CarInfo import CarInfo
from app.models.CrackInfo import CrackInfo
from app.upload import upload_image

bp = Blueprint('carTest_Save', __name__, url_prefix='/check')

# route = /create
# car_info를 먼저 생성
# 완성이 되지 않으면 => 대시보드가 아닌 체크 페이지로 다시 넘어갈 수 있도록

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
    car = CarInfo.query.filter_by(car_number=car_number).first()
    if not car:
        car = CarInfo(car_number=car_number)
        db.session.add(car)

    # -----------------------------

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

@bp.route('/register', methods=['POST'])
    def register_car():
        image_file = request.files.get('image') # multipart-file로 파일 로드

        # 이미지를 버킷에 업로드하고 URL을 받아옴
        # 테스트 할때는 파일명으로 사용 => 완성하면서 운영할때는 별도로 파일명, 경로 구성
        image_url = upload_image(image_file, image_file.filename)

        # model에 전송
        # 응답
        # crack_info에 저장

        # CrackInfo 객체 생성 및 데이터베이스에 저장
        # car_id는 임시값 => car_id는 요청에 포함될 예정
        # Null 보다는 특정 값이라도 있는게 좋다.
        crack_info = CrackInfo(car_id= 1,section=-1, crack=-1, image_path=image_url)
        db.session.add(crack_info)
        db.session.commit()


        return jsonify({'message': 'Car registered successfully'}), 200