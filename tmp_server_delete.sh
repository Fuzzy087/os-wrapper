#! /bin/bash

printf "Updating server list to ensure correctness before deletion...\n" >> /root/openstack/logs/tmp_server_delete.log

/usr/local/bin/openstack server list | awk -F '|' '{printf ("%5s|%s|%s\n"), $2,$3,$4}' | awk NF | sed 's/^[ \t]*//' | sed 's/ *| /|/g' | sed '1,3d' | sed '$ d' > /root/openstack/data/current-server-list.txt

if [[ $(awk -F '|' '/OSTACK-CLI-TMPSERVER/ {print $1,$2}' /root/openstack/data/current-server-list.txt) ]]
    then echo "Tmp servers found, deleting..." >> /root/openstack/logs/tmp_server_delete.log
    awk -F '|' '/OSTACK-CLI-TMPSERVER/ {print $1, $2}' /root/openstack/data/current-server-list.txt | while read id name
        do printf "Deleting ${name}...\n" >> /root/openstack/logs/tmp_server_delete.log
        openstack server delete ${id}
    done
    printf "Deletions completed, sleeping 60 seconds to allow time for server list to update...\n"
    printf "Updating server list again to reflect changes...\n" >> /root/openstack/logs/tmp_server_delete.log
else
    echo "No tmp servers found, exiting" >> /root/openstack/logs/tmp_server_delete.log
fi
