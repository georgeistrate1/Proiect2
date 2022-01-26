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
#ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y 2>/dev/null
echo -e "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo -e "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config
echo -e "PasswordAuthentication yes" >> /etc/ssh/sshd_config
systemctl restart sshd

mkdir /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC58Cb1JrjSnR3iOSLqmDqA0Zpyqea0G3ULoof+tF/E3xLkZIExxOJUZJMRM9Y6k/FdcKePrlg1NuxOOhcddsY6zs0irCxkaC0do9/MzSUDgx5q9st+L14wlIjywDl6MRLISJ/yN6RYUgbGmYny2gdc/PptoziWoqaLG/I4sEp0YoA55VYkzryp1K+/6X/+LC11pxbfBezx0qzpaPCsygxHLuO79MJz2pWwrxgR6u+hlY5hWd1R5SPFryVfR2G6LhZ9bXDMTvANHbqdBf4V6erpLj5GhpR5OZYyyoVMQw4JIiNFOKwTr53cmvMx08Mj1tB4mkY/DQuR1n1hrvoZoagbDWW1DC5UTWbZC0ZfUWDn+KsoK3i1jgRTZOPxHTTWn6Vv+2YPyHySDDTDmKGSsBLJ6C/JSGH3CsqrwONfanLp4h8EGZA95ICcYOpxl0/ZdSVmnMP4yOM17o9gWwi8F7wp1U0it6I1FRII6nne6OXx73TbN5BzJ4dFtmJo4zOQyGc= yonder\gistrate@gIstrate-LAP" > /root/.ssh/authorized_keys 
echo -e "-----BEGIN OPENSSH PRIVATE KEY-----\n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\n-----END OPENSSH PRIVATE KEY-----" >> /root/.ssh/id_rsa
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





