FROM alpine:latest

RUN echo 'https://mirror.sr.ht/alpine/edge/sr.ht' >> /etc/apk/repositories
RUN wget -q -O /etc/apk/keys/alpine@sr.ht.rsa.pub https://mirror.sr.ht/alpine/alpine@sr.ht.rsa.pub

RUN apk update
RUN apk add py3-gunicorn py3-psycopg2

# install meta
RUN apk add meta.sr.ht
