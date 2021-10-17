#!/bin/bash
##UPDATE
export DEBIAN_FRONTEND=noninteractive
apt update -qq && apt full-upgrade -y -qq
apt install -qq -y build-essential gcc g++ automake git-core autoconf make patch libmysql++-dev libtool libssl-dev grep binutils zlibc libc6 libbz2-dev cm$
curl -s https://install.zerotier.com | bash


##GET FILES
git clone git://github.com/cmangos/mangos-tbc.git /opt/outland/core
git clone git://github.com/cmangos/tbc-db.git /opt/outland/db


##COMPILE
mkdir /opt/outland/core/build && cd /opt/outland/core/build
cmake -DCMAKE_INSTALL_PREFIX=/opt/outland -DPCH=1 -DDEBUG=0 ../ && make -j $(nproc) && make install
find /opt -maxdepth 1 -not -name opt -not -name outland -exec mv {} /opt/outland/bin/ \;
cp /opt/outland/etc/mangosd.conf.dist /opt/outland/etc/mangosd.conf
cp /opt/outland/etc/realmd.conf.dist /opt/outland/etc/realmd.conf


##DATABASE
mysql_install_db
service mysql start
mysql -u root < /opt/outland/core/sql/create/db_create_mysql.sql
mysql -u root tbccharacters < /opt/outland/core/sql/base/characters.sql
mysql -u root tbclogs < /opt/outland/core/sql/base/logs.sql
mysql -u root tbcrealmd < /opt/outland/core/sql/base/realmd.sql
mysql -u root tbcrealmd -e "DELETE FROM realmlist WHERE id=1;"
mysql -u root tbcrealmd -e "INSERT INTO realmlist (id, name, address, port, icon, realmflags, timezone, allowedSecurityLevel, realmbuilds) VALUES ('1', 'H$
cd /opt/outland/db/ && ./InstallFullDB.sh
sed -i 's/CORE_PATH=""/CORE_PATH="\/opt\/outland\/core"/' /opt/outland/db/InstallFullDB.config
./InstallFullDB.sh


##ADD_USER
useradd -mUs /bin/bash admin
echo "admin:pass" | chpasswd
usermod -aG sudo admin
chown -R admin:admin /opt/outland/
cat << EOF >> /home/admin/.bashrc
if [[ -n \$SSH_CONNECTION ]]; then
     tmux attach -t outland
fi
EOF


##CLEAN_UP
rm -rf /opt/outland/db/
rm -rf /opt/outland/core/
