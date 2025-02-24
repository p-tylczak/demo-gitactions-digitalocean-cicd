#!/bin/bash

#cd /root/digital-ocean-github-actions-ci
#git pull origin master
#/root/.bun/bin/bun install
#sudo systemctl restart digital-ocean-github-actions-ci

cd /root/envs/dev/apps/demo-gitactions-digitalocean-cicd
./scripts/docker-compose down
git pull origin master
./scripts/docker-compose up -d