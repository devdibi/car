use min;
drop table if exists user_info;
CREATE TABLE user_info (
    id INT PRIMARY KEY,
    email VARCHAR(45),
    pw VARCHAR(255),
    user_name VARCHAR(45)
);
insert into user_info (id, email, pw, user_name)
value (1, 'hong@gil.dong', '1234', '홍길동');


drop table if exists car_info;
CREATE TABLE car_info (
    id INT PRIMARY KEY,
    user_id int, 
    create_at datetime,
    cacarck_infor_number VARCHAR(45)
);
insert into car_info (id, user_id, create_at, car_number)
value (1, '1', '2024-02-13', '123가 1234');


drop table if exists carck_info;
CREATE TABLE carck_info (
    id int PRIMARY KEY,
    car_id int,
    section int,
    carck int,
    image_path VARCHAR(255)
);
insert into carck_info (id, car_id, section, carck, image_path)
value (1, '1', '0', '1', '');

-- 외래키 설정
ALTER TABLE car_info
ADD CONSTRAINT fk_user_info_id
FOREIGN KEY (user_id) REFERENCES user_info(id);

ALTER TABLE carck_info
ADD CONSTRAINT fk_car_info_id
FOREIGN KEY (car_id) REFERENCES car_info(id);
