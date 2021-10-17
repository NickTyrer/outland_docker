#!/bin/bash
#SETUP IPTABLES
iptables -P INPUT DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 8085 -j ACCEPT
iptables -A INPUT -p tcp --dport 3724 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -j ACCEPT


#START SERVICES
if ! pgrep -x "mysqld" > /dev/null; then
service mysql start
fi
service ssh start
./usr/sbin/zerotier-one -d
sleep 10


#JOIN ZEROTIER NETWORK
zerotier-cli join $ZT_NET
while [ -z $(ip a | grep zt | grep inet | awk '{print $2}' | cut -d / -f 1) ] ; do sleep 10; done; ZT_IP=$(ip a | grep zt | grep inet | awk '{print $2}' |$
mysql -u root tbcrealmd -e "UPDATE realmlist SET address = '$ZT_IP' WHERE id = 1;"


#SETUP TMUX
runuser -l admin -c "tmux new -d -s outland"
runuser -l admin -c "tmux send-keys 'cd /opt/outland/bin && ./mangosd' C-m"
runuser -l admin -c "cd /opt/outland/bin && ./realmd"
