# 
# install.sh
# Sun Nov 22 20:46:43 -0200 2009
#

apt-get install -y cronolog
gem install tweetstream redis prowl fcoury-gmail yaml tlsmail

cd /usr/src
wget -q http://redis.googlecode.com/files/redis-1.02.tar.gz
tar xzvf redis-1.02.tar.gz
cd redis-1.02/
make -j
cp redis.conf /etc
ln -s /usr/src/redis-1.02/redis-server /usr/bin/redis-server
ln -s /usr/src/redis-1.02/redis-cli /usr/bin/redis-cli

echo "
daemonize no
logfile stdout" >> /etc/redis.conf
echo "nohup /usr/bin/redis-server /etc/redis.conf | /usr/bin/cronolog /var/log/redis/redis.%Y-%m-%d.log 2>&1 &" > /etc/init.d/redis.sh

chmod +x /etc/init.d/redis.sh
bash -c "nohup /usr/bin/redis-server /etc/redis.conf | /usr/bin/cronolog /var/log/redis/redis.%Y-%m-%d.log 2>&1 &"
sed -i "s/loglevel debug/loglevel notice/g" /etc/redis.conf

mkdir log

echo "#! /bin/bash
cd `pwd`
ruby producer.rb start
ruby consumer.rb start" > /etc/init.d/intweet.sh

echo "#! /bin/bash
ruby producer.rb stop
ruby consumer.rb stop" > stop

chmod +x /etc/init.d/intweet.sh
chmod +x stop

nohup /etc/init.d/redis.sh
nohup /etc/init.d/intweet.sh

