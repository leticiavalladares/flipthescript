#!/bin/bash

# INSTALL GIT AND MYSQL
sudo apt-get update
sudo apt-get install git mysql-client -y
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
 sudo mkdir -p /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker.io -y
git clone --branch dev https://github.com/leticiavalladares/movie_management_project.git ~/movie_management_project
cd ~/movie_management_project/app
sudo docker build -t movie-mgmt .

sleep 1m
mysql -h ${db_endpoint} -u root -p${db_password} < ~/movie_management_project/database/create_movie_database.sql

sudo sed -i "s/ENDPOINT_PLACEHOLDER/${db_endpoint}/g" ~/movie_management_project/app/main.py
sudo sed -i "s/PASSWORD_PLACEHOLDER/${db_password}/g" ~/movie_management_project/app/main.py

# RUN MY CONTAINER - FLASK APP RUNNNING
sudo docker run -d -p 80:80 --name=movie-mgmt -v ~/movie_management_project/app:/app movie-mgmt
