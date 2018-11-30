FROM node:8.12-alpine

ARG TZ=Asia/Tokyo

RUN apk --update add \
    tzdata \
	&& cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
	&& apk del tzdata
