import os
from google.cloud import storage

def upload_image(file, filename):
    # 환경 변수에서 인증 파일 경로를 가져오고 액세스 설정
    credentials_path = os.environ.get('GOOGLE_APPLICATION_CREDENTIALS')
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = credentials_path

    # 버킷 이름 가져오기
    bucket_name = 'BUCKET_NAME'
    # Google 클라우드 스토리지 클라이언트 생성
    client = storage.Client()

    # 버킷 및 블롭 생성
    bucket = client.bucket(bucket_name)
    blob = bucket.blob(filename)

    # 블롭에 파일 업로드
    blob.upload_from_file(file)

    # 업로드된 이미지의 공개 URL 반환
    public_url = blob.public_url
    return public_url
