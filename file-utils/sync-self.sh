#!/bin/bash

while read -r host ip; do
  echo Syncing to "$host"
  rsync -av --info=progress2 --delete /home/server-admin/server-mgmt server-admin@"$ip":~/
done <servers.txt
