import json
import csv
import os

# JSON 파일이 있는 폴더 경로
folder_path = 'C:\\Users\\siwon\\OneDrive\\Desktop\\dataset\\TL_damage'
# CSV 파일 경로
csv_file_path = 'bbox_result.csv'

# CSV 파일 헤더
fieldnames = ['file_name', 'damage']

# CSV 파일 쓰기 모드로 열기
with open(csv_file_path, 'w', newline='') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()

    # 폴더 내의 모든 파일에 대해 반복
    for filename in os.listdir(folder_path):
        if filename.endswith('.json'):
            json_file_path = os.path.join(folder_path, filename)

            # JSON 파일 읽기
            with open(json_file_path, 'r') as f:
                data = json.load(f)

            # 이미지의 너비와 높이 가져오기
            image_width = data['images']['width']
            image_height = data['images']['height']

            # bbox 좌표 정규화(normalize)
            bbox = data['annotations'][0]['bbox']
            bbox_x_min = round(bbox[0] / image_width, 4)
            bbox_y_min = round(bbox[1] / image_height, 4)
            bbox_x_max = round((bbox[0] + bbox[2]) / image_width, 4)
            bbox_y_max = round((bbox[1] + bbox[3]) / image_height, 4)

            # 필요한 데이터 추출
            file_name = f"{data['images']['file_name']}"
            damage = data['annotations'][0]['damage']

            # CSV 파일에 쓰기
            writer.writerow({'file_name': file_name,
                            'damage': damage,
                            'bbox_x_min': bbox_x_min,
                            'bbox_y_min': bbox_y_min,
                            'bbox_x_max': bbox_x_max,
                            'bbox_y_max': bbox_y_max})

