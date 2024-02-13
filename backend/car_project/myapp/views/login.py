from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS

app = Flask(__name__)
CORS(app, origins=['http://localhost:54013'])
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://min:min123!@devdibi.duckdns.org/min'  # SQLite를 사용하는 예시입니다.
db = SQLAlchemy(app)

class UserInfo(db.Model):

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    pw = db.Column(db.String(120), nullable=False)
    user_name = db.Column(db.String(80), nullable=False)

@app.route("/login",methods=['POST'])
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
    user = UserInfo.query.filter_by(email=email, pw=password).first()

    if user is not None:
        res['isLogined'] = True
        res['user'] = {
                'id' : user.id,
                'email' : user.email,
                'name' : user.user_name
            }

    return jsonify(res)

if __name__ == "__main__":
    app.run(debug=True)



