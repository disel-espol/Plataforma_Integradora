FROM python:3
ENV PYTHONUNBUFFERED=1
ENV USER=
RUN apt-get update
RUN apt-get install -y expect
RUN mkdir /root/.ssl
RUN chmod 777 /root/.ssl
COPY emulab.pem /root/.ssl/
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/
