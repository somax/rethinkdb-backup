# RethinkDB Backup

This image runs `rethinkdb-dump` to backup data using cronjob.

## usage

```bash

docker run -d -v $(pwd):/rethinkdb/backups -e RETHINKDB_HOST=<rethinkdb-host>[:<port>] [-e CRON_TIME="0 0 * * *"] somax/rethinkdb-backup
```

### Environment

- RETHINKDB_HOST  can be `rethinkdb` or `rethinkdb:28015`
- CRON_TIME       `0 0 * * 0` by default, which is every sunday at 00:00.
- RETHINKDB_PASS    admin's password, in Rancher use Secrets (as name `passwd`) instead of environment. 

### About crontab
> For details see man crontabs, Example of job definition:
```
.---------------- minute (0 - 59)
|  .------------- hour (0 - 23)
|  |  .---------- day of month (1 - 31)
|  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
|  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
|  |  |  |  |
*  *  *  *  *
```