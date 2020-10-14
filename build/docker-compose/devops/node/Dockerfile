FROM node:10.22.1-alpine3.9
# set timezome
RUN apk update && apk add curl bash tree tzdata \
        && cp -r -f /usr/share/zoneinfo/Hongkong /etc/localtime \
        && echo -ne "Alpine Linux 3.4 image. (`uname -rsv`)\n" >> /root/.built \
&& npm install gulp -g \
&& mkdir /data
WORKDIR /data