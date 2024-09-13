#!/bin/bash
cd /root/digital-ocean-github-actions-ci
git pull origin master
bun install
sudo systemctl restart digital-ocean-github-actions-ci