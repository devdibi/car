# db 객체 로드
from app import db
from datetime import datetime

# 차량의 정보를 관리 하는 모델

class Car(db.Model):
    __tablename__ = 'car'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    create_at = db.Column(db.DateTime, default=datetime.utcnow)
    car_number = db.Column(db.String(45) ,nullable=False)
    car_type = db.Column(db.String(45), default='ETC', nullable=False)
    checked = db.Column(db.Integer, default=0)
    sections = db.relationship('Section', backref='car', lazy=True)
