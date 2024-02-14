# db 객체 로드
from app import db

class CarInfo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user_info.id'))
    create_at = db.Column(db.DateTime)
    car_number = db.Column(db.String(45))
    carck_info = db.relationship('CarckInfo', backref='car', lazy=True)