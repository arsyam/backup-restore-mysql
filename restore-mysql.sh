#/bin/bash
DB_BACKUP_PATH='/root/backup-mysql'
MYSQL_REMOTE_USER='root'
MYSQL_REMOTE_PASSWORD='yourPassword'
DATABASE_REMOTE_DB='YourDB'

zcat ${DB_BACKUP_PATH}/${DATABASE_REMOTE_DB}.sql.gz | mysql -u ${MYSQL_REMOTE_USER} -p${MYSQL_REMOTE_PASSWORD} ${DATABASE_REMOTE_DB}
