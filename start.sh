/usr/bin/gunicorn metasrht.app:app -b 0.0.0.0:5001
/usr/bin/gunicorn gitsrht.app:app -b 0.0.0.0:5002
/usr/bin/gunicorn hgsrht.app:app -b 0.0.0.0:5003
/usr/bin/gunicorn buildssrh.app:app -b 0.0.0.0:5004
/usr/bin/gunicorn listssrht.app:app -b 0.0.0.0:5005
/usr/bin/gunicorn mansrht.app:app -b 0.0.0.0:5006
/usr/bin/gunicorn pastesrht.app:app -b 0.0.0.0:5007
/usr/bin/gunicorn todosrht.app:app -b 0.0.0.0:5008
