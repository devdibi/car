from flask import request, jsonify, current_app
from google.cloud import storage

from app import db
from app.models.section_model import Section


def upload():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    # Google 서비스 계정 키 파일의 경로 가져오기
    credentials_path = current_app.config['GOOGLE_APPLICATION_CREDENTIALS']
    # 클라이언트 생성
    client = storage.Client.from_service_account_json(credentials_path)
    # 버킷 이름 가져오기
    bucket_name = current_app.config.get('BUCKET_NAME')
    # 버킷 가져오기
    bucket = client.bucket(bucket_name)
    # 이미지 업로드
    blob = bucket.blob(file.filename)
    blob.upload_from_file(file)

    # 공개 URL 생성
    public_url = blob.public_url

    # 업로드한 이미지의 URL 가져오기
    image_url = public_url

    # SQLAlchemy를 사용하여 이미지 URL을 데이터베이스에 저장
    new_section = Section(image_path=image_url)
    db.session.add(new_section)
    db.session.commit()

    return jsonify({'message': 'Image uploaded successfully', 'image_url': image_url}), 200

    # # ACL 설정이 만약 필요하면..
    # acl = blob.acl
    # acl.all_authenticated().grant_read()
    # acl.save()
