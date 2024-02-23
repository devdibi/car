from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import config
from flask_cors import CORS

# SQLAlchemy 객체 생성
db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    # CORS 적용
    CORS(app, origins=['*'])

    # config 설정 적용
    app.config.from_object(config)

    # model들 불러오기
    from .models import car_model, crack_model, user_model, section_model

    # 모든 모델 클래스를 SQLAlchemy에 등록
    with app.app_context():
        db.init_app(app)
        db.create_all()

    # Blueprint 등록
    # bp 객체 로드
    from app.views.user_views import user_view
    from app.views.car_views import car_view, check_view
    from app.views.image_views import recognition_util

    # Blueprint 객체 bp 등록
    app.register_blueprint(user_view.bp)
    app.register_blueprint(car_view.bp)
    app.register_blueprint(check_view.bp)

    return app
