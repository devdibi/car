from flask import Blueprint
from app.response.response import Response

from app.models.section_model import Section
from app.models.crack_model import Crack
from app.models.car_model import Car

bp = Blueprint('crack_list', __name__, url_prefix='/crack')

degree_map = {
    0: '스크래치',
    1: '찌그러짐',
    2: '파손',
    3: '이격'
}

@bp.route('/detail/<int:car_id>', methods=['GET'])
def crack_detail(car_id):
    car = Car.query.filter_by(id=car_id).first()

    response = {
        'car_type': car.car_type,
        'crack_list': [],
    }

    # section 정보 조회
    section_list = Section.query.filter_by(car_id=car_id)

    # crack 정보 조회
    for section in section_list:
        info = {
            'section_id': section.id,
            'section': section.section,
            'checked': section.checked,
            'image_path': section.image_path,
            'crack': {
                '0': 0,
                '1': 0,
                '2': 0,
                '3': 0
            }
        }

        # crack db 조회
        section_crack_list = Crack.query.filter_by(section_id=section.id)

        # 손상 종류에 따른 추가
        for section_crack in section_crack_list:
            info['crack'][str(section_crack.degree)] += 1

        response['crack_list'].append(info)

    return Response(200, "차량의 손상 정보를 성공적으로 불러왔습니다.", response).json(), 200

@bp.route('/box/<int:car_id>', methods=['GET'])
def box(car_id):
    sections = Section.query.filter_by(car_id=car_id);

    boxes = []
    for section in sections:

        cracks = Crack.query.filter_by(section_id=section.id)

        for crack in cracks:
            box = {
                'section': section.section,
                'x_min': crack.x_min,
                'x_max': crack.x_max,
                'y_min': crack.y_min,
                'y_max': crack.y_max,
            }

            boxes.append(box)

    return Response(200, "파손 부위를 성공적으로 조회했습니다.", boxes).json(), 200
