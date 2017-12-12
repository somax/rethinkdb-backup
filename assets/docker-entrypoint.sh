#!/bin/sh

cat <<EOF > /backup.sh
#!/bin/sh
echo "Start backup..."

BACKUP_CMD="rethinkdb-dump -c $RETHINKDB_HOST --password-file /passwd"

echo "=> Backup started..."

if \${BACKUP_CMD}; then
    echo "=> √ Backup succeeded"
else
    echo "=> X Backup failed"
fi

EOF

chmod +x /backup.sh

cat <<EOF > /run.sh
#!/bin/sh

# For details see man crontabs
# Example of job definition:
# .---------------- minute (0 - 59)
# |  .------------- hour (0 - 23)
# |  |  .---------- day of month (1 - 31)
# |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
# |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# |  |  |  |  |
# *  *  *  *  *

echo "${CRON_TIME:-0 0 * * 0} /backup.sh" > /crontab.conf
crontab  /crontab.conf
echo "=> Running rethinkdb backups as a cron for ${CRON_TIME}"
crond -f

EOF

chmod +x /run.sh


echo $RETHINKDB_PASS > /passwd

set -e
exec "$@"