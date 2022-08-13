- SourceCode: https://sr.ht/~sircmpwn/sourcehut/sources

- About Builds: https://man.sr.ht/builds.sr.ht/installation.md

- sourcehut pages https://srht.site/quickstart

参考：
- https://git.sr.ht/~kolk/srht-docker/tree/master/item/docker-compose.yml
- https://git.sr.ht/~robertgzr/sourcehut-containers/tree



- https://emersion.fr/blog/2021/setting-up-sr.ht-for-local-development/



### [meta.sr.ht](https://git.sr.ht/~sircmpwn/meta.sr.ht):
##### Daemons
-   `meta.sr.ht` — The web service.
-   `meta.sr.ht-api` — The API service.
-   `meta.sr.ht-webhooks` — Webhook delivery service.

##### [#](https://man.sr.ht/meta.sr.ht/installation.md#cronjobs)Cronjobs
- metasrht-daily: Purges old audit log entries and runs billing.


### [git.sr.ht]([https://git.sr.ht/~sircmpwn/git.sr.ht](https://git.sr.ht/~sircmpwn/git.sr.ht))
##### Daemons
-   `git.sr.ht` — The web service.
-   `git.sr.ht-api` — The API service.
-   `git.sr.ht-webhooks` — Webhook delivery service.

##### [#](https://man.sr.ht/git.sr.ht/installation.md#cronjobs)Cronjobs
-   `gitsrht-periodic` — Performs various maintenance tasks.

### hg.sr.ht
##### Daemons
-   `hg.sr.ht` — The web service.

##### [#](https://man.sr.ht/hg.sr.ht/installation.md#cronjobs)Cronjobs
-   `hgsrht-periodic`: Performs various maintenance tasks.
-   `hgsrht-clonebundles` (optional): Generates [clone bundles](https://www.mercurial-scm.org/wiki/ClonebundlesExtension).

## [ lists.sr.ht]([https://git.sr.ht/~sircmpwn/lists.sr.ht](https://git.sr.ht/~sircmpwn/lists.sr.ht))
##### Daemons
-   `lists.sr.ht` — The web service.
-   `lists.sr.ht-lmtp` — Incoming mail service.
-   `lists.sr.ht-process` — Mail processing service. 
-   `lists.sr.ht-webhooks` — Webhook delivery service.
##### Configuration
See [Configuration](https://man.sr.ht/lists.sr.ht/configuration.md).

### man.sr.ht
##### Daemons
-   `man.sr.ht` — The web service.
##### Configuration

See [Configuration](https://man.sr.ht/man.sr.ht/configuration.md).

#### paste.sr.ht
##### Daemons
-   `paste.sr.ht` — The web service.

### [todo.sr.ht](https://git.sr.ht/~sircmpwn/todo.sr.ht](https://git.sr.ht/~sircmpwn/todo.sr.ht)
##### Daemons

-   `todo.sr.ht` — The web service.
-   `todo.sr.ht-lmtp` — Incoming mail service.
-   `todo.sr.ht-webhooks` — Webhook delivery service.

##### [#](https://man.sr.ht/todo.sr.ht/installation.md#configuration)Configuration

See [Configuration](https://man.sr.ht/todo.sr.ht/configuration.md).


###  dispatch.sr.ht
 [Planned deprecation of dispatch.sr.ht](https://sourcehut.org/blog/2022-08-01-dispatch-deprecation-plans/)