FROM alpine:3.15.5

RUN echo 'https://mirror.sr.ht/alpine/v3.15/sr.ht' >> /etc/apk/repositories
RUN wget -q -O /etc/apk/keys/alpine@sr.ht.rsa.pub https://mirror.sr.ht/alpine/alpine@sr.ht.rsa.pub

RUN apk update
RUN apk add py3-gunicorn py3-psycopg2

# install meta
RUN apk add meta.sr.ht
