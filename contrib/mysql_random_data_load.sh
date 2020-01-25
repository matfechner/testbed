#!/usr/bin/env bash

# This script creates a database test with several test tables and fills them with random data.
#
# For the generation of the test data https://github.com/Percona-Lab/mysql_random_data_load is used.

NUMBER_OF_ROWS=${1:-10000}

export MYSQL_HOST=api-int.osism.local
export MYSQL_PWD=qNpdZmkKuUKBK3D5nZ08KMZ5MnYrGEe2hzH6XC0i
export MYSQL_TCP_PORT=3306

VERSION_mysql_random_data_load=0.1.12

if [[ ! -e /usr/bin/mysql ]]; then
    sudo apt-get -y install mariadb-client-core-10.1
fi

mysql -u root < mysql_random_data_load.sql

if [[ ! -e mysql_random_data_load ]]; then
    wget https://github.com/Percona-Lab/mysql_random_data_load/releases/download/v${VERSION_mysql_random_data_load}/mysql_random_data_load_${VERSION_mysql_random_data_load}_Linux_x86_64.tar.gz
    tar xvzf mysql_random_data_load_${VERSION_mysql_random_data_load}_Linux_x86_64.tar.gz mysql_random_data_load
    rm mysql_random_data_load_${VERSION_mysql_random_data_load}_Linux_x86_64.tar.gz
fi

for table in t1 t2 t3 t4; do
    ./mysql_random_data_load test $table $NUMBER_OF_ROWS \
      --user=root \
      --password=$MYSQL_PWD \
      --host=$MYSQL_HOST \
      --port=$MYSQL_TCP_PORT
done