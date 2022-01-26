#!/bin/sh
     
# Author: iceflatline <iceflatline@gmail.com>

# These variables are named first because they are nested in other variables. 
snap_prefix=snap
retention=4

# Full paths to these utilities are needed when running the script from cron. 
date=/bin/date
grep=/bin/grep
sed=/bin/sed
sort=/usr/bin/sort
xargs=/usr/bin/xargs
zfs=/sbin/zfs
pyznap=/usr/local/bin/pyznap

src_0="pg/pg_dataset"
today="$snap_prefix-`date +%Y%m%d%H%M`"
snap_today="$src_0@$today"
snap_old=`$zfs list -t snapshot -o name | $grep "$src_0@$snap_prefix*" | $sort -r | $sed 1,${retention}d | $xargs -n 1`       
log=/var/log/pyznap.log

# Create a blank line between the previous log entry and this one.
echo >> $log

# Print the name of the script.
echo "backup.sh" >> $log

# Print the current date/time.
$date >> $log

echo >> $log

# Look for today's snapshot and, if not found, create it.
if $zfs list -H -o name -t snapshot | $grep "$snap_today" > /dev/null
then
        echo "Today's snapshot '$snap_today' already exists." >> $log
        # Uncomment if you want the script to exit when it does not create today's snapshot:
        #exit 1
else
        echo "Taking today's snapshot: $snap_today" >> $log
        $zfs snapshot -r $snap_today >> $log 2>&1
        echo "Sending snapshot $snap_today to remote VM" >> $log
        $pyznap send -s pg/pg_dataset -d ssh:22:root@machine2:pg/backup -i /root/.ssh/id_rsa --dest-auto-create
fi

echo >> $log

# Remove snapshot(s) older than the value assigned to $retention.
echo "Attempting to destroy old snapshots..." >> $log

if [ -n "$snap_old" ]
then
        echo "Destroying the following old snapshots:" >> $log
        echo "$snap_old" >> $log
        $zfs list -t snapshot -o name | $grep "$src_0@$snap_prefix*" | $sort -r | $sed 1,${retention}d | $xargs -n 1 $zfs destroy -r >> $log 2>&1
else
    echo "Could not find any snapshots to destroy."     >> $log
fi

# Mark the end of the script with a delimiter.
echo "**********" >> $log
# END OF SCRIPT