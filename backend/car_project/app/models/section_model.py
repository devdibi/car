#db 객체 불러오기
from app import db

# 차량의 이미지 및 구역의 정보를 관리 하는 모델

class Section(db.Model):
    __tablename__ = 'section'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    car_id = db.Column(db.Integer, db.ForeignKey('car.id'), nullable=False)
    section = db.Column(db.Integer ,nullable=False)
    cracks = db.relationship('Crack', backref='section', lazy=True)
    checked = db.Column(db.Integer, default=0, nullable=False)
    image_path = db.Column(db.String(255))

