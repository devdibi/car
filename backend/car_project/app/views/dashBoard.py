from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://min:min123!@devdibi.duckdns.org/min'
db = SQLAlchemy(app)

class UserInfo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(45))
    pw = db.Column(db.String(255))
    user_name = db.Column(db.String(45))

class CarInfo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user_info.id'))
    create_at = db.Column(db.DateTime)
    car_number = db.Column(db.String(45))
    accidents = db.relationship('CarckInfo', backref='car', lazy=True)

class CarckInfo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    car_id = db.Column(db.Integer, db.ForeignKey('car_info.id'))
    section = db.Column(db.Integer)
    carck = db.Column(db.Integer)
    image_path = db.Column(db.String(255))

# 대시보드 엔드포인트
@app.route('/dashboard/<int:car_id>', methods=['GET'])
def get_dashboard(car_id):
    car_info = CarInfo.query.filter_by(id=car_id).first()
    if car_info:
        accident_info = []
        for accident in car_info.accidents:
            accident_info.append({
                'image_path': accident.image_path,
                'section': accident.section,
                'carck': accident.carck
            })
        response = {
            'car_number': car_info.car_number,
            'accident_info': accident_info
        }
        return jsonify(response)
    else:
        return jsonify({'error': 'Car not found'})
if __name__ == '__main__':
    app.run(debug=True)
