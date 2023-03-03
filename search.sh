#! /bin/sh
name=''
id=''

while getopts n:l flag
#while getopts n: flag
do
    case "${flag}" in
        n) name=${OPTARG};;
        l) id="True";;
    esac
done

if [ -n "${name}"  ] && [ -n "${id}" ]
    then rm -f /root/openstack/data/custom-list.txt
    sqlite3 /root/openstack/data/images.db "Select ID, Name from image_list where name like '%${name}%'" | tr '|' ' ' | sed 's/cPanel//g' | sed 's/on//g' | sed 's/x86_64//g' | while read id cpvers os osvers
        do echo "${id} ${cpvers}-${os}${osvers}-$(date +%m-%d-%Y)" >> /root/openstack/data/custom-list.txt
    done

printf "\nCustom list generated at /root/openstack/data/custom-list.txt based on the provided output, that file's current contents:\n$(cat /root/openstack/data/custom-list.txt)\n\n"
    read -p 'Would you like to build that list now? (Y|y || N|n): ' cvar
        if [ $cvar == Y ] || [ $cvar == y ]
            then read -p 'Would you like to make these servers temporary? (They will be destroyed at end of day): ' ctmp
                if [ $ctmp == Y ] || [ $ctmp == y ]
                    then while read id name
                        do openstack server create --image $id --flavor m1.small --key-name controller-key --user-data /root/openstack/config/cloud.config "${name}-OSTACK-CLI-TMPSERVER"
                    done < /root/openstack/data/custom-list.txt
                elif [ $ctmp == N ] || [ $ctmp == n ]
            then while read id name
                do openstack server create --image $id --flavor m1.small --key-name controller-key --user-data /root/openstack/config/fresh.config "${name}"
                done < /root/openstack/data/custom-list.txt
                fi
        fi
elif [[ -n "${name}" ]]
    then sqlite3 /root/openstack/data/images.db "Select ID, Name from image_list where name like '%${name}%'" | tr '|' ' ' | sed 's/cPanel//g' | sed 's/on//g' | sed 's/x86_64//g'
else
    echo "Need args"
fi
