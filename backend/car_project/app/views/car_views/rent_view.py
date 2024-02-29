
# 차량 관련 기본 기능 view
from flask import Blueprint, request
from app.response.response import Response
from datetime import datetime, timedelta

from app.models.car_model import Car
from app.models.section_model import Section
from app.models.user_model import User
from app.models.crack_model import Crack
from app.models.rent_model import Rent
from app.views.image_views.recognition_util import image_detection, image_classification
from app import db

from app.views.image_views.recognition_util import image_cut

bp = Blueprint('rent_list', __name__, url_prefix='/rent')

@bp.route('/admin/list/<int:user_id>', methods=['GET'])
def get_rent_list(user_id):
    # 보유차량 목록
    car_list = Car.query.filter_by(user_id=user_id, rentable=1)

    if car_list is None:
        return Response(200, "대여 중인 차량 목록이 없습니다.", []).json(), 200

    data = [{
        'id': car.id,
        'car_number': car.car_number,
        'created_at': car.create_at,
        'car_type': car.car_type,
        'checked': car.checked,
        'rentable': car.rentable
    } for car in car_list]

    return Response(200, "성공적으로 대여 목록을 조회했습니다.", data).json(), 200

@bp.route('/admin/rent', methods=['POST'])
def rent():
    body = request.json

    if body['owner_id'] is None or body['car_id'] is None or body['customer_email'] is None or body['rented_at'] is None or body['returned_at'] is None:
        return Response(500, "잘못된 요청입니다.", body).json(), 500

    car = Car.query.filter_by(id=body['car_id']).first()

    if car.rentable == 1:
        return Response(400, '이미 대여된 차량입니다..', []).json, 400

    user = User.query.filter_by(email=body['customer_email']).first()

    if user is None:
        return Response(400, '존재하지 않는 유저입니다.', []).json, 400


    db.session.add(Rent(
        car_id=body['car_id'],
        owner_id=body['owner_id'],
        customer_id=user.id,
        rented_at=datetime.fromisoformat(body['rented_at']),
        returned_at=datetime.fromisoformat(body['returned_at'])
    ))

    car_update = db.session.query(Car).filter_by(id=body['car_id']).first()

    car_update.rentable = 1
    db.session.commit()

    return Response(200, "렌트가 성공적으로 완료되었습니다.", []).json(), 200

@bp.route('/user/list/<int:user_id>', methods=['GET'])
def get_user_rent_list(user_id):
    # 기간이 남은 대여 목록 조회
    rent_list = Rent.query.filter_by(customer_id=user_id)

    car_list = []
    rented_list = []
    returned_list = []
    # 현재 이 차량들의 상태가 렌트 된 상태인지 확인
    for rent in rent_list:
        car = Car.query.filter_by(id=rent.car_id).first()
        car_list.append(car)
        rented_list.append(rent.rented_at)
        returned_list.append(rent.returned_at)

    data = [{
        'id': car.id,
        'car_number': car.car_number,
        'created_at': car.create_at,
        'car_type': car.car_type,
        'checked': car.checked,
        'rentable': car.rentable,
        'rented_at': rented_list[index],
        'returned_at': returned_list[index],
    } for index, car in enumerate(car_list)]

    return Response(200, "렌트 목록을 성공적으로 조회했습니다.", data).json(), 200





    # if rent_list is None:
    #     return Response(200, "대여 중인 차량 목록이 없습니다.", []).json(), 200
    #
    # car_list = []
    #
    # for rent in rent_list:
    #     car = Car.query.filter_by(id=rent.id, rentable=1).first()
    #
    #     car_list.append(car)
    #
    # data = [{
    #     'id': car.id,
    #     'car_number': car.car_number,
    #     'created_at': car.create_at,
    #     'car_type': car.car_type,
    #     'checked': car.checked,
    #     'rentable': car.rentable
    # } for car in car_list]

    return Response(200, "성공적으로 대여 목록을 조회했습니다.", data).json(), 200

@bp.route('/user/detail/<int:user_id>')
def get_main(user_id):
    rent = Rent.query.filter_by(customer_id=user_id).first()

    if rent is None:
        return Response(204, "현재 대여중인 차량이 없습니다.", []).json(), 200

    car = Car.query.filter_by(id=rent.car_id).first()

    data = {
        'id': car.id,
        'car_number': car.car_number,
        'created_at': car.create_at,
        'car_type': car.car_type,
        'checked': car.checked,
        'rentable': car.rentable,
        'rented_at': rent.rented_at,
        'returned_at': rent.returned_at
    }

    return Response(200, "차량의 정보를 성공적으로 조회했습니다.", data).json(), 200