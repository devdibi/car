from flask import request, jsonify, Blueprint
from app import db

from app.models.UserInfo import UserInfo

bp = Blueprint('register', __name__)

@bp.route('/register', methods=['POST'])
def signup():
    data = request.json
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    # 사용자가 모든 필드를 입력했는지 확인
    if not username or not email or not password:
        return jsonify({'message': '모든 필드를 입력하세요.'}), 400

    # 사용자 생성
    new_user = UserInfo(username=username, email=email, password=password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': '회원가입이 완료되었습니다.'}), 201

