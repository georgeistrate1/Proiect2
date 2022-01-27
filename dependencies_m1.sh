#!/bin/bash

# Update repository
apt-get -qq update 

# Install zfs
apt-get install zfsutils-linux -y

# Create pg pool
# https://www.tecmint.com/create-virtual-harddisk-volume-in-linux/
mkdir /vdisk
dd if=/dev/zero of=/vdisk/vdisk.img bs=1M count=5120
mkfs -t ext4 /vdisk/vdisk.img
zpool create pg /vdisk/vdisk.img
zfs create pg/pg_dataset
zfs create pg/pg_wal

# set up machines connections via keys
sudo su
echo -e "192.168.56.110 machine1\n192.168.56.111 machine2" >> /etc/hosts
echo -e "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo -e "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config
echo -e "PasswordAuthentication yes" >> /etc/ssh/sshd_config
systemctl restart sshd


sudo mkdir /root/.ssh && sudo touch /root/.ssh/authorized_keys
cat /vagrant/keys/id_rsa >> /root/.ssh/id_rsa
cat /vagrant/keys/id_rsa.pub >> /root/.ssh/authorized_keys

chmod 600 /root/.ssh/authorized_keys /root/.ssh/id_rsa

# Install Postgresql
apt-get -qq install -y postgresql > /dev/null

# Import sample database
wget https://ftp.postgresql.org/pub/projects/pgFoundry/dbsamples/world/world-1.0/world-1.0.tar.gz
tar -xvf world-1.0.tar.gz 
mv dbsamples-0.1/world/world.sql /home/vagrant 
rm -rf world-1.0.tar.gz dbsamples-0.1
sudo chown vagrant:vagrant world.sql
chmod 644 world.sql

sudo -u postgres psql -c "create user pguser with encrypted password 'parola';"
sudo -u postgres psql -c "create database pgdb;"
export PGPASSWORD='parola' && psql -h localhost -p 5432 -U pguser pgdb < world.sql

# Install python-pip3 & pyznap 
apt-get install python3-pip -y
pip3 install pyznap

# https://github.com/yboetz/pyznap
# set up pyznap
pyznap setup
echo -e "[pg/pg_dataset]\nfrequent = 4\nsnap = yes\nclean = yes\ndest = pg/backup\ncompress = gzip" > /etc/pyznap/pyznap.conf

sudo su
cp /vagrant/backup_m1.sh /bin/backup.sh
chmod +x /bin/backup.sh
echo "0 23 * * * bin/backup.sh" >> /var/spool/cron/crontabs/root
systemctl restart cron

# install docker
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
sudo DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes apt-transport-https ca-certificates gnupg-agent software-properties-common
sudo -i
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker vagrant
sudo service docker restart

# run postgresql as docker container
docker run --name db_container -e POSTGRES_USER=pguser -e POSTGRES_PASSWORD=parola -p 192.168.56.110:5432:5432 -v /pg/pg_dataset:/var/lib/postgresql/data -d postgres





