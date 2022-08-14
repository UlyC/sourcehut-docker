#!/bin/bash
set -e

service_list="$*"
echo "service list: $service_list"

metasrht-initdb
#metasrht-manageuser  -p  -e admin@test.com  -t admin admin
/usr/bin/gunicorn metasrht.app:app -c /etc/sr.ht/meta.sr.ht.gunicorn.conf.py -b 0.0.0.0:5000 -D
#/usr/bin/metasrht-api -b 0.0.0.0:5100 &
/usr/bin/celery -A metasrht.webhooks worker --loglevel=info &
echo "0	2	*	*	*  /usr/bin/metasrht-daily" >>/etc/crontab

if [[ "$service_list" == *"git"* ]]; then
  gitsrht-initdb
  /usr/bin/gunicorn gitsrht.app:app -b 0.0.0.0:5001 -c /etc/sr.ht/git.sr.ht.gunicorn.conf.py -D
  #  /usr/bin/gitsrht-api -b 0.0.0.0:5101
  /usr/bin/celery -A gitsrht.webhooks worker --loglevel=info &
  echo "*/20 * * * *  /usr/bin/gitsrht-periodic" >>/etc/crontab
fi

if [[ "$service_list" == *"hg"* ]]; then
  hgsrht-initdb
  /usr/bin/gunicorn hgsrht.app:app -b 0.0.0.0:5010 -c /etc/sr.ht/git.sr.ht.gunicorn.conf.py -D
#  /usr/bin/hgsrht-api -b 0.0.0.0:5110 &
  /usr/bin/celery -A hgsrht.webhooks worker --loglevel=info &
  echo "*/20 * * * *  /usr/bin/hgsrht-periodic" >>/etc/crontab
fi

if [[ "$service_list" == *"builds"* ]]; then
  buildsrht-initdb
  /usr/bin/gunicorn buildsrht.app:app -b 0.0.0.0:5002 -c /etc/sr.ht/builds.sr.ht.gunicorn.conf.py -D

fi

#if [[ "$service_list" == *"lists"* ]]; then
#  listssrht-initdb
#  /usr/bin/gunicorn listsrht.app:app -b 0.0.0.0:5006 -c /etc/sr.ht/lists.sr.ht.gunicorn.conf.py -D
#  /usr/bin/listssrht-api -b 0.0.0.0:5106 &
#  /usr/bin/listssrht-lmtp &
#  /usr/bin/celery -A listssrht.webhooks worker --loglevel=info &
#
#fi

if [[ "$service_list" == *"man"* ]]; then
  mansrht-initdb
  /usr/bin/gunicorn mansrht.app:app -b 0.0.0.0:5004 -c /etc/sr.ht/man.sr.ht.gunicorn.conf.py -D
fi

if [[ "$service_list" == *"todo"* ]]; then
  todosrht-initdb
  /usr/bin/gunicorn todosrht.app:app -b 0.0.0.0:5003 -c /etc/sr.ht/todo.sr.ht.gunicorn.conf.py -D
#  /usr/bin/todosrht-api -b 0.0.0.0:5103
  #  /usr/bin/todosrht-lmtp &
  /usr/bin/celery -A todosrht.webhooks worker --loglevel=info &
fi

if [[ "$service_list" == *"paste"* ]]; then
  pastesrht-initdb
  /usr/bin/gunicorn pastesrht.app:app -b 0.0.0.0:5011 -c /etc/sr.ht/paste.sr.ht.gunicorn.conf.py -D
fi

tail -f /dev/null
