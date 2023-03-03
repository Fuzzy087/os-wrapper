#! /bin/sh
echo "Removing old images database"
rm -vf /root/openstack/data/images.db

echo "Initializing new database"
sqlite3 /root/openstack/data/images.db "CREATE TABLE image_list(ID TEXT NOT NULL UNIQUE, Name TEXT NOT NULL, Status TEXT NOT NULL);"
echo "Populating newly created database"

if sqlite3 /root/openstack/data/images.db ".tables" | grep -q 'image_list'
    then
        echo "Table is there"
        while IFS='|' read id name status
            do sqlite3 /root/openstack/data/images.db "INSERT INTO image_list(ID, Name, Status) VALUES('${id}', '${name}', '${status}');"
        done < /root/openstack/data/text-image-list.txt
    else
        echo "Table is missing!"
    fi

echo "Done!"
