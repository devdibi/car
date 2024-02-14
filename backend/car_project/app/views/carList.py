from flask import Flask, jsonify, Blueprint
from flask_sqlalchemy import SQLAlchemy

bp = Blueprint('register', __name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://min:min123!@devdibi.duckdns.org/min'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)
class CarInfo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer)
    create_at = db.Column(db.DateTime)
    car_number = db.Column(db.String(45))

@app.route('/list/<int:user_id>', methods=['GET'])
def get_car_list(user_id):
    cars = CarInfo.query.filter_by(user_id=user_id).all()  # 해당 유저 ID를 가진 차량 정보 조회
    car_list = [(car.car_number, car.create_at) for car in cars]  # 차량 번호와 등록일자로 이루어진 리스트 생성
    response = {
        'len': len(car_list),
        'car_list': car_list
    }
    return jsonify(response)

if __name__ == '__main__':
    app.run(debug=True)
