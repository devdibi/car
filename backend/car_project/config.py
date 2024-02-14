import os

# GOOGLE_APPLICATION_CREDENTIALS 파일의 경로 설정
GOOGLE_APPLICATION_CREDENTIALS = os.path.join(os.path.dirname(__file__), 'team04-project-11de44aa2276.json')

# Google 클라우드 버킷 이름 설정
BUCKET_NAME = 'test240214'

# SQLAlchemy 설정 및 기타 설정
SQLALCHEMY_DATABASE_URI = 'mysql://min:min123!@devdibi.duckdns.org/min'
SQLALCHEMY_TRACK_MODIFICATIONS = False
