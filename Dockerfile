FROM python:3
ENV PYTHONUNBUFFERED=1
RUN apt-get update
RUN apt-get install -y expect
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/
