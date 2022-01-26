#! /bin/bash

zfs=/sbin/zfs
grep=/bin/grep
wc=/usr/bin/wc
sort=/usr/bin/sort
head=/usr/bin/head
awk=/usr/bin/awk

while [ $( zfs list -t snapshot | grep snap | wc -l ) -gt 4 ]
    do 
      zfs destroy $(zfs list -t snapshot | grep snap | awk {'print $1'} | sort -n | head -1)
    done
