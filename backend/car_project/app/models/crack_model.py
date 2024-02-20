#db 객체 불러오기
from app import db

# 손상 정도 및 좌표를 관리 하는 모델
class Crack(db.Model):
    __tablename__ = 'crack'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    section_id = db.Column(db.Integer, db.ForeignKey('section.id'), nullable=False)
    degree = db.Column(db.Integer, nullable=False)
    # 구역의 좌표 정보 => 순서로 진행
    x_min = db.Column(db.Double)
    x_max = db.Column(db.Double)
    y_min = db.Column(db.Double)
    y_max = db.Column(db.Double)  
    confidence = db.Column(db.Double)
    imagePath = db.Column(db.String(45))


