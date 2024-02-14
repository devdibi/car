#db 객체 불러오기
from app import db

# 손상 정도 및 좌표를 관리 하는 모델
class Crack(db.Model):
    __tablename__ = 'crack'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    section_id = db.Column(db.Integer, db.ForeignKey('section.id'))
    degree = db.Column(db.Integer)
    # 구역의 좌표 정보 => 순서로 진행
    lt = db.Column(db.Integer)  # 왼쪽 상단
    lb = db.Column(db.Integer)  # 왼쪽 하단
    rb = db.Column(db.Integer)  # 오른쪽 하단
    rt = db.Column(db.Integer)  # 오른쪽 상단

