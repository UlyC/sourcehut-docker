# sourcehut  [x]  docker
**Make sourcehut run easily in docker**

---

![sourcehut.png](sourcehut.png)

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
![Docker](https://img.shields.io/badge/%F0%9F%90%8B%20-docker-blue)

## Quick Start
> This project is not recommend for use in production.

```bash
bash ./init.sh

docker-compose up --build -d
```
If you don't set domain, it will be set to `localtest.me`(Resolve to 127.0.0.1).

You can visit the site at `http://meta.localtest.me`.

## Init Admin Account

```bash
$ docker exec -it {{your_container_id}} /bin/sh

$ /usr/bin/metasrht-manageuser [-fmPps] [-e <EMAIL>] [-t <USER_TYPE>] <USERNAME>


Options:
    -e <EMAIL>      set user email
    -f              perform action even if using different authentication method
    -m              modify existing user
    -P              clear password
    -p              set password (default if creating a new user)
    -s              read initial password from stdin (only effective with -p)
    -t <USER_TYPE>  set user type to USER_TYPE; USER_TYPE must be one of these
                    values: unconfirmed, active_non_paying, active_free,
                    active_paying, active_delinquent, admin, unknown, suspended
````
## Support Modules

- `meta.sr.ht` ✅
- `git.sr.ht` ✅
- `hg.sr.ht` ✅
- `man.sr.ht` ✅
- `builds.sr.ht` ✅
    - Not included `builds.sr.ht worker`
- `lists.sr.ht` ✅
- `meta.sr.ht` ✅
- `todo.sr.ht`  ✅
- `paste.sr.ht` ✅
- `dispatch.sr.ht` ❌
    - See  [Planned deprecation of dispatch.sr.ht](https://sourcehut.org/blog/2022-08-01-dispatch-deprecation-plans/)

##  Configuration

If you  want to run `lists.sr.ht` or `api` service, you need to set SMTP in [mail] section of `./config.ini` .
Then uncomment the code corresponding in `start.sh`.

```bash
docker-compose up --build -d --force
````

### Advance Configuration
See [official document](https://man.sr.ht/configuration.md)


## Requirements

```bash
docker-compose version > 1.29
```

## Links 
-  [sourcehut official site](https://sourcehut.org/)
-  [sourcehut 中文介绍]( https://ulyc.github.io/2022/08/10/sourcehut-the-hackers-forge/)
