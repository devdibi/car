import json
import os

# JSON 파일이 있는 폴더 경로
folder_path = 'D:\\damage'

# damage 값에 대한 매핑
damage_mapping = {'Breakage': 0, 'Crushed': 1, 'Separated': 2, 'Scratched': 3}

# 폴더 내의 모든 파일에 대해 반복
for filename in os.listdir(folder_path):
    if filename.endswith('.json'):
        json_file_path = os.path.join(folder_path, filename)
        txt_file_path = os.path.splitext(json_file_path)[0] + '.txt'

        # JSON 파일 읽기
        with open(json_file_path, 'r') as json_file:
            data = json.load(json_file)

        # damage 가져오기
        damage = data['annotations'][0]['damage']

        # damage에 대응하는 매핑된 값 가져오기
        damage_code = damage_mapping.get(damage, -1)

        # 이미지의 너비와 높이 가져오기
        image_width = data['images']['width']
        image_height = data['images']['height']

        # bbox 좌표 정규화(normalize)
        bbox = data['annotations'][0]['bbox']
        bbox_x_min = round(bbox[0] / image_width, 4)
        bbox_y_min = round(bbox[1] / image_height, 4)
        bbox_x_max = round((bbox[0] + bbox[2]) / image_width, 4)
        bbox_y_max = round((bbox[1] + bbox[3]) / image_height, 4)

        # 텍스트 파일에 쓰기
        with open(txt_file_path, 'w') as txt_file:
            txt_file.write(f"damage {bbox_x_min} {bbox_y_min} {bbox_x_max} {bbox_y_max}\n")

print("텍스트 파일에 데이터를 성공적으로 기록했습니다.")