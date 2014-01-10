#!/usr/bin/env bash

mysqldump -B fbb kalisher moti| bzip2 > /tmp/db.sql.bz2
echo "DB backup attached" | mail -s "DB Backup" -a /tmp/db.sql.bz2 kalisher@gmail.com

