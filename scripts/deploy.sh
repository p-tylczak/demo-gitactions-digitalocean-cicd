#!/bin/bash
cd /root/digital-ocean-github-actions-ci
git pull origin master
sudo systemctl restart digital-ocean-github-actions-ci