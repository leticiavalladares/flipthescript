## Flip the Script in AWS ECR

I copied the app and named it ecr-app so I could create an `docker-compose.yaml` and modify the 

*DockerFile*
```sh
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
```

Then I set the environmental variables and create the image locally (this is not used by ECR):

```sh
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_DEFAULT_REGION=""
docker-compose up --build
```

*Check the environmental vars printenv

After checking that it works locally, copy the cmd from the console on AWS ECR:

`aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com`

```sh
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 653363876120.dkr.ecr.eu-central-1.amazonaws.com
```

Then, build the image and use the args:

```sh
docker build -t ecr-flipthescript-app \
--build-arg AWS_ACCESS_KEY_ID="" \
--build-arg AWS_SECRET_ACCESS_KEY="" \
--build-arg AWS_DEFAULT_REGION="" \
.
```

and tag the image flipthescript-app.

`docker tag e9ae3c220b23 aws_account_id.dkr.ecr.us-west-2.amazonaws.com/my-repository:tag`

```sh
docker tag ecr-flipthescript-app:latest 653363876120.dkr.ecr.eu-central-1.amazonaws.com/flipthescript:latest
```

And push it.

`docker push aws_account_id.dkr.ecr.us-west-2.amazonaws.com/my-repository:tag`

```sh
docker push 653363876120.dkr.ecr.eu-central-1.amazonaws.com/flipthescript:latest
```