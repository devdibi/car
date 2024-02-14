# db 객체 로드
from app import db
from datetime import datetime

class CarInfo(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user_info.id'))
    create_at = db.Column(db.DateTime, default=datetime.utcnow)
    car_number = db.Column(db.String(45))
    crack_info = db.relationship('CrackInfo', backref='car', lazy=True)