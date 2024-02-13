import os
import json
import csv
import pandas as pd

# JSON 파일을 읽어와 Python 객체로 로드하는 함수
def load_json_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as json_file:
        return json.load(json_file)

# JSON 파일들이 있는 폴더 경로
folder_path = 'C:/Users/siwon/OneDrive/Desktop/dataset/TL_damage'

# CSV 파일로 데이터를 쓰기 위해 필요한 헤더를 지정합니다.
fields = ['file_name', 'damage']

# CSV 파일을 쓰기 모드로 엽니다.
with open('file_and_damage.csv', 'w', newline='', encoding='utf-8') as csv_file:
    writer = csv.DictWriter(csv_file, fieldnames=fields)

    # 헤더를 쓰고
    writer.writeheader()

    # 폴더 내의 모든 파일에 대해 처리합니다.
    for filename in os.listdir(folder_path):
        if filename.endswith('.json'):
            # JSON 파일의 전체 경로를 생성합니다.
            file_path = os.path.join(folder_path, filename)
            # JSON 파일을 로드합니다.
            data = load_json_file(file_path)
            # 이미지 파일 이름과 해당 이미지의 어노테이션 damage를 추출하여 CSV 파일에 씁니다.
            for annotation in data['annotations']:
                writer.writerow({'file_name': 'gs://cloud-ai-platform-47475281-7e75-4d8c-8da0-2ca9f059cd1a/TS_damage/'+data['images']['file_name'], 'damage': annotation['damage']})

# CSV 파일을 읽어옵니다.
df = pd.read_csv('file_and_damage.csv')

# 중복된 행을 제거합니다.
df.drop_duplicates(inplace=True)

# 결과를 새로운 CSV 파일로 저장합니다.
df.to_csv('file_and_damage_no_duplicates.csv', index=False)
