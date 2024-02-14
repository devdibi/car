from flask import Flask, request, jsonify, Blueprint
from flask_sqlalchemy import SQLAlchemy

bp = Blueprint('register', __name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://min:min123!@devdibi.duckdns.org/min'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)

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
    new_user = User(username=username, email=email, password=password)
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': '회원가입이 완료되었습니다.'}), 201

with app.app_context():
    db.create_all()
