#!/bin/bash
ssh -o StrictHostKeyChecking=no ubuntu@${{ secrets.KNOWN_HOSTS }}
echo Start deploy
cd ~/laravelDemo/
git pull origin master
cp .env.example .env
sudo docker compose up --build -d
echo Deploy end
