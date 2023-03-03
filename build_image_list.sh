source ~/.openstackrc
source /root/.openstackrc.norm.bak
/usr/local/bin/openstack image list | awk -F '|' '{printf ("%5s|%s|%s\n"), $2,$3,$4}' | awk NF | sed 's/^[ \t]*//' | sed 's/ *| /|/g' | sed '1,3d' | sed '$ d' > /root/openstack/data/text-image-list.txt
echo "Done at $(date)" >> /root/openstack/logs/build_image_list.log
