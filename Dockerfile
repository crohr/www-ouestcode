FROM nginx:alpine
RUN apk add --update make m4
COPY . /usr/share/nginx/html/
RUN cd /usr/share/nginx/html/ && make clean all
