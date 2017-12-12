FROM somax/rethinkdb-cli

WORKDIR /rethinkdb/backups

COPY assets/docker-entrypoint.sh /
# COPY assets/backup.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD [ "/run.sh" ]