import os
import json
import pandas as pd

# 폴더 내의 모든 JSON 파일에 대해 반복
folder_path = "C:\\Users\\siwon\\Downloads\\dataset\\dataset"
for filename in os.listdir(folder_path):
    if filename.endswith('.json'):
        # JSON 파일 읽기
        with open(os.path.join(folder_path, filename), 'r') as f:
            data = json.load(f)

        # 필요한 정보 추출
        annotations = data.get('annotations', [])
        damage_list = [annotation.get('damage') for annotation in annotations if annotation.get('damage')]


# 이미지 파일과 JSON 파일 삭제 후 CSV 생성
csv_data = []
for filename in os.listdir(folder_path):
    if filename.endswith('.json'):
        # JSON 파일 읽기
        with open(os.path.join(folder_path, filename), 'r') as f:
            data = json.load(f)

        # 필요한 정보 추출
        file_name = data['images']['file_name']
        annotations = data.get('annotations', [])

        # 각 annotation에 대한 정보 추출
        for annotation in annotations:
            damage = annotation.get('damage', '')
            part = annotation.get('part', '')

            # CSV 데이터 리스트에 추가
            csv_data.append([file_name, damage])

# CSV 파일 생성
df = pd.DataFrame(csv_data, columns=['File Name', 'Damage'])
df.to_csv('output.csv', index=False)