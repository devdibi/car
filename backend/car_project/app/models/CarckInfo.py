#db 객체 불러오기
from app import db

class CarckInfo(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    car_id = db.Column(db.Integer, db.ForeignKey('car_info.id'))
    section = db.Column(db.Integer)
    carck = db.Column(db.Integer)
    image_path = db.Column(db.String(255))
