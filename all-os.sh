while read image os; do openstack server create --image $image --flavor m1.small --key-name controller-key --user-data /root/openstack/config/fresh.config $os ; done < /root/openstack/data/fresh-images.txt
echo "Sleeping 20 seconds to allow server list to populate"
sleep 20
echo "Generating fresh OS list now"
openstack server list | grep -P '(cloudlinux\d|centos\d|almalinux\d|ubuntu\d+)' | awk '{print $4, $8}' | while read os ip; do printf "${os} $(echo ${ip} | grep -oP '\d+\.\d+\.\d+\.\d+')\n"; done > /root/openstack/data/most-recent-fresh-os-builds.txt
echo "Done!"
