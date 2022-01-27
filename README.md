# proiect2

This project contains 2 VMs provisioned with Vagrant, each of them containing a postgresql sample DB running in docker containers.

Both VMs use the zfs filesystem and on the VM1 it generates backups for the database dataset which is sent automatically to VM2 using pyznap.

The number of backups held by each VM can be set using the /bin/backup.sh scripts in both VMs.


Resources:

https://www.iceflatline.com/2020/02/a-simple-script-for-creating-and-deleting-rolling-zfs-snapshots-in-freebsd/
https://docs.docker.com/install/linux/docker-ce/ubuntu/
https://github.com/yboetz/pyznap
https://serverfault.com/questions/340837/how-to-delete-all-but-last-n-zfs-snapshots
https://stackoverflow.com/questions/30075461/how-do-i-add-my-own-public-key-to-vagrant-vm
