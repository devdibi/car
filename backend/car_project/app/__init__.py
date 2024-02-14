from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import config

# SQLAlchemy 객체 생성
db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    # config 설정 적용
    app.config.from_object(config)

    # model들 불러오기
    from .models import CarInfo, CarckInfo, UserInfo

    # 모든 모델 클래스를 SQLAlchemy에 등록
    with app.app_context():
        db.init_app(app)
        db.create_all()

    # Blueprint 등록
    # bp 객체 로드
    from .views import login, register, carList, dashBoard, carTest_Save

    # Blueprint 객체 bp 등록
    app.register_blueprint(login.bp)
    app.register_blueprint(register.bp)
    app.register_blueprint(carList.bp)
    app.register_blueprint(dashBoard.bp)
    app.register_blueprint(carTest_Save.bp)

    return app
