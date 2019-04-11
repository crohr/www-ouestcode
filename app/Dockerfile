FROM nginx:alpine
RUN apk add --update make m4
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY . /usr/share/nginx/html/
RUN cd /usr/share/nginx/html/ && make clean all
