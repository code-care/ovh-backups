#!/bin/bash

DAYNUM="$(date +'%d')"
HOURNUM="$(date +'%H')"

# Prepare filenames
ZIP_PACKAGE="/tmp/files_$PROJECT_NAME-$DAYNUM-$HOURNUM.zip"
MYSQL_PACKAGE="/tmp/mysql_$PROJECT_NAME-$DAYNUM-$HOURNUM.gz"


# Prepare dumps
mysqldump -h $DATABASE_HOSTNAME -u $DATABASE_USERNAME --password="$DATABASE_PASSWORD" $DATABASE_NAME | gzip > $MYSQL_PACKAGE
echo "Mysql DUMP READY"
zip -r $ZIP_PACKAGE $PROJECT_PATH
echo "Files DUMP READY"

# Upload files to OVH Cloud Archive
. /backups/openrc.sh
swift upload $CONTAINER_NAME $ZIP_PACKAGE
swift upload $CONTAINER_NAME $MYSQL_PACKAGE

echo "Upload finished."

# CleanUp
rm -rf $ZIP_PACKAGE
rm -rf $MYSQL_PACKAGE

echo "Disk cleaned up"
