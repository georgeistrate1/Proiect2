# proiect2

Acest proiect are in componenta doua masini virtuale create prin Vagrant in care sunt active cate un docker postgresql cu o baza de date.  

Ambele VM se folosesc de filesystem-ul zfs pentru a genera backup-uri la datasetul bazei de date de pe VM1 iar cu ajutorul pyznap acest backup este trimis automat catre VM2. 

Se poate seta numarul de backup-uri redinut de fiecare VM prin scripturile din /bin/backup.sh de pe fiecare VM.

Resurse:
https://www.iceflatline.com/2020/02/a-simple-script-for-creating-and-deleting-rolling-zfs-snapshots-in-freebsd/
https://docs.docker.com/install/linux/docker-ce/ubuntu/
https://github.com/yboetz/pyznap
https://serverfault.com/questions/340837/how-to-delete-all-but-last-n-zfs-snapshots
https://stackoverflow.com/questions/30075461/how-do-i-add-my-own-public-key-to-vagrant-vm
