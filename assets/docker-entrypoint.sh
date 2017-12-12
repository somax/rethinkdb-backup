#!/bin/sh

# 在 rancher 中部署，优先考虑使用 secrets 存储密码
PASSWD="/passwd"
if [ -e /run/secrets/passwd ]; then
   PASSWD="/run/secrets/passwd"
elif [  -n "$RETHINKDB_PASS" ]; then
    echo $RETHINKDB_PASS > /passwd
fi

# 生成 备份 脚本
cat <<EOF > /backup.sh
#!/bin/sh
echo "Start backup..."

BACKUP_CMD="rethinkdb-dump -c $RETHINKDB_HOST --password-file $PASSWD -f /rethinkdb/backups/rdb_dump_\$(date +\%Y-\%m-\%dT\%H:\%M:\%S).tar.gz"

echo "=> Backup started..."

if \${BACKUP_CMD}; then
    echo "=> √ Backup succeeded"
else
    echo "=> X Backup failed"
fi

EOF

chmod +x /backup.sh


# 生成 计划任务启动 脚本
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

# 入口定义
set -e
exec "$@"