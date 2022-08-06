

/usr/bin/gunicorn metasrht.app:app -b 0.0.0.0:5000
/usr/bin/gunicorn gitsrht.app:app -b 0.0.0.0:5001