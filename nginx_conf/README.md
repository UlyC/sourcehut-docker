# sr.ht-nginx

This is the nginx configuration files used by sr.ht in production. They are
designed to run on an Alpine Linux system using the official sourcehut Alpine
packages. You may use them on your own servers, but your mileage may vary.
Install the -nginx package (e.g. git.sr.ht-nginx) to pull in these files, then
edit `/etc/nginx/domains.conf` (and `/etc/nginx/nginx.conf`, if necessary) to
suit your particular installation.

You should also write your own file, *-ssl.conf (e.g.
`/etc/nginx/builds-ssl.conf`), which configures the SSL certificate, like so:

    ssl_certificate /etc/ssl/uacme/builds.sr.ht/cert.pem;
    ssl_certificate_key /etc/ssl/uacme/private/builds.sr.ht/key.pem;

This is annoying. You can thank the nginx devs.
