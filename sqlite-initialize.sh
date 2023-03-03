#! /bin/sh
sqlite3 /root/openstack/data/images.db "CREATE TABLE image_list(ID TEXT NOT NULL UNIQUE, Name TEXT NOT NULL UNIQUE, Status TEXT NOT NULL);"
