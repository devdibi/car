# db 객체 불러오기
from app import db

# 유저의 정보를 관리 하는 모델

class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    name = db.Column(db.String(80), nullable=False)
    cars = db.relationship('Car', backref='user', lazy=True)
