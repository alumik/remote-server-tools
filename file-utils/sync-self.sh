#!/bin/bash

USER=${1:-server-admin}

while read -r host ip; do
  echo Syncing to "$host"
  rsync -av --info=progress2 --delete /home/"$USER"/server-mgmt "$USER"@"$ip":~/
done <servers.txt
