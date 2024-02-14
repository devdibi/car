# db 객체 불러오기
from app import db

class UserInfo(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    name = db.Column(db.String(80), nullable=False)
    cars = db.relationship('CarInfo', backref='user', lazy=True)
