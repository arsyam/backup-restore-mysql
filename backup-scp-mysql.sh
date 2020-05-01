#!/bin/bash

DB_BACKUP_PATH='/root/backup-mysql'

MYSQL_HOST='localhost'
MYSQL_PORT='3306'
MYSQL_USER='root'
MYSQL_PASSWORD='yourPassword'
DATABASE_NAME_DB='yourDB'

KEY_LOCATION='/root/yourPrivateKey.pem'

# Remote Host

MYSQL_REMOTE_HOST='192.168.1.10'

echo "Backup started for database - ${DATABASE_NAME_DB}"

mysqldump -h ${MYSQL_HOST} \
                  -P ${MYSQL_PORT} \
                  -u ${MYSQL_USER} \
                  -p${MYSQL_PASSWORD} \
                  ${DATABASE_NAME_DB} | gzip > ${DB_BACKUP_PATH}/${DATABASE_NAME_DB}.sql.gz

if [ $? -eq 0 ]; then
  echo "Database ${DATABASE_NAME_DB} backup successfully completed"
else
  echo "Error found during backup"
  exit
fi

### Transfer file backup ###

echo "Transfer Backup ${DATABASE_NAME_DB} to Remote Server"

scp -i ${KEY_LOCATION} ${DB_BACKUP_PATH}/${DATABASE_NAME_DB}.sql.gz root@${MYSQL_REMOTE_HOST}:${DB_BACKUP_PATH}

### Restore ###

echo "Restore started for database ${DATABASE_NAME_DB} on ${MYSQL_REMOTE_HOST}"

ssh -i ${KEY_LOCATION} -t root@${MYSQL_REMOTE_HOST} '/root/restore-mysql.sh'

if [ $? -eq 0 ]; then
  echo "Database restore successfully completed"
else
  echo "Error found during backup"
fi
