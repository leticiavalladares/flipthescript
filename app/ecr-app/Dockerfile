FROM python:3.8-slim-buster

ENV HOME /app
WORKDIR /app
ENV PATH="/app/.local/bin:${PATH}"

ENV FLASK_ENV=production

ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

ENV AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
ENV AWS_DEFAULT_REGION $AWS_DEFAULT_REGION

COPY requirements.txt requirements.txt
RUN apt-get update && \
    apt-get install -y \
    bash \
    build-essential \
    cmake \  
    curl \
    git \
    libmariadb-dev-compat \
    libmariadb-dev && \ 
    pip3 install -r requirements.txt

COPY . .
WORKDIR /app

CMD ["python3", "-m" , "flask", "run", "--host=0.0.0.0"]