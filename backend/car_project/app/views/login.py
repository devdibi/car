from flask import Flask, request, jsonify, Blueprint
from flask_cors import CORS

from app.models.UserInfo import UserInfo

bp = Blueprint('login', __name__)


@bp.route("/login",methods=['POST'])
def get_user():
    data = request.json

    res = {
        'isLogined': False,
        'user': {}
    }

    # 요청에 해당 변수가 존재 하는지 확인(유효성 검증)
    if data.get('email') is None or data.get('password') is None:
        return jsonify(res)

    # 변수 할당
    email = data['email']
    password = data['password']

    # db 조회
    user = UserInfo.query.filter_by(email=email, password=password).first()

    if user is not None:
        res['isLogined'] = True
        res['user'] = {
                'id' : user.id,
                'email' : user.email,
                'name' : user.name
            }

    return jsonify(res)