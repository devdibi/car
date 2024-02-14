# db 객체 로드
from app import db
from datetime import datetime

# 차량의 정보를 관리 하는 모델

class Car(db.Model):
    __tablename__ = 'car'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    create_at = db.Column(db.DateTime, default=datetime.utcnow)
    car_number = db.Column(db.String(45))
    car_type = db.Column(db.String(45))
    complete = db.Column(db.Boolean, default=False)
    sections = db.relationship('Section', backref='car', lazy=True)