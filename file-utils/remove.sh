#!/bin/bash

REMOTE=$1
PASSWORD_PREFIX=$2

while read -r host ip; do
  echo Removing from "$host"
  echo "$PASSWORD_PREFIX""$host" | ssh -tt server-admin@"$ip" "sudo rm -rf $REMOTE"
done <servers.txt
