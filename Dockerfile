# build stage
FROM node:22.14.0-alpine AS build

# set working directory
WORKDIR /ui

COPY ./package.json .
COPY ./package-lock.json .
RUN npm ci
COPY . /ui