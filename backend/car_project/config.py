import os

# GOOGLE_APPLICATION_CREDENTIALS 파일의 경로 설정
filename = os.getenv("FILENAME")
GOOGLE_APPLICATION_CREDENTIALS = os.path.join(os.path.dirname(__file__), filename)

# Google 클라우드 버킷 이름 설정
BUCKET_NAME = os.getenv("name")

# SQLAlchemy 설정 및 기타 설정

DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")

# MySQL 연결 문자열 생성
SQLALCHEMY_DATABASE_URI = f"mysql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
SQLALCHEMY_TRACK_MODIFICATIONS = False
