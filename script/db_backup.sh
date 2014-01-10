#!/usr/bin/env bash

# When adding a new DB, be sure to run the following in mysql
# (replace moti with your new db schema)
# grant SELECT, LOCK TABLES, SHOW VIEW, EVENT, TRIGGER ON `moti`.* to 'backup'@'localhost';
# grant usage on moti.* to 'backup'@'localhost';

mysqldump -B fbb kalisher moti| bzip2 > /tmp/db.sql.bz2
echo "DB backup attached" | mail -s "DB Backup" -a /tmp/db.sql.bz2 kalisher@gmail.com

