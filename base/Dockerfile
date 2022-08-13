FROM alpine:3.15.6

RUN sed -i '1 i https://mirror.sr.ht/alpine/v3.15/sr.ht'  /etc/apk/repositories
RUN wget -q -O /etc/apk/keys/alpine@sr.ht.rsa.pub https://mirror.sr.ht/alpine/alpine@sr.ht.rsa.pub
RUN apk update
RUN apk add meta.sr.ht


