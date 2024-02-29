FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt .

RUN export MYSQLCLIENT_CFLAGS="-I/usr/include/mysql"
RUN export MYSQLCLIENT_LDFLAGS="-L/usr/lib/x86_64-linux-gnu -lmysqlclient"


RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y gcc
RUN apt-get install -y pkg-config
RUN apt-get install -y python3-dev
RUN apt-get install -y libmariadb-dev

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "run.py"]
