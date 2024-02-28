'''


'''

from flask import Flask, request, jsonify, Blueprint  # flask package
from app.models.user_model import User #  user_model
from app.response.response import Response  # 사용자 정의 응답
from app import db


bp = Blueprint('login', __name__, url_prefix='/user')

# 로그인 route
@bp.route("/login",methods=['POST'])
def get_user():
    body = request.json  # request body

    # 요청에 해당 변수가 존재 하는지 확인(유효성 검증)
    if body['email'] is None or body['password'] is None:
        return Response(400, "잘못된 요청입니다.", None).json(), 400

    # db 조회
    user = User.query.filter_by(email=body['email'], password=body['password']).first()

    if user is None:
        return Response(401, "아이디 및 비밀번호가 일치하지 않습니다.", None).json(), 401
    else:
        data = {'id': user.id, 'email': user.email, 'name': user.name, 'role': user.role}
        return Response(200, "로그인이 성공적으로 완료되었습니다.", data).json(), 200

# 회원 가입 route
@bp.route('/register', methods=['POST'])
def signup():
    body = request.json

    # 요청에 해당 변수가 존재 하는지 확인(유효성 검증)
    if body['email'] is None or body['password'] is None or body['name'] is None:
        return Response(400, "잘못된 요청입니다.", None).json(), 400

    # 존재하는 유저인지 확인
    if User.query.filter_by(email=body['email']).first() is not None:
        return Response(400, "이미 존재하는 유저입니다.", None).json(), 400

    # db에 저장
    db.session.add(User(email=body['email'], password=body['password'], name=body['name'], role=body['role']))
    db.session.commit()

    return Response(200, "회원가입이 성공적으로 완료되었습니다.", None).json(), 200

# 유저 관련 기능 추가해보자
