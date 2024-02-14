from flask import Flask
from flask_sqlalchemy import SQLAlchemy

# SQLAlchemy 객체 생성
db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    # Blueprint 등록
    # bp 객체 로드
    from views import login, register, carList, dashBoard, carTest_Save

    # Blueprint 객체 bp 등록
    app.register_blueprint(login.bp)
    app.register_blueprint(register.bp)
    app.register_blueprint(carList.bp)
    app.register_blueprint(dashBoard.bp)
    app.register_blueprint(carTest_Save.bp)

    return app