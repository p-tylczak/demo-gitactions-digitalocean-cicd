#!/bin/bash

#cd /root/digital-ocean-github-actions-ci
#git pull origin master
#/root/.bun/bin/bun install
#sudo systemctl restart digital-ocean-github-actions-ci

cd /root/dev/demo-gitactions-digitalocean-cicd
docker-compose down
git pull origin master
docker-compose up -d