#!/bin/bash

REMOTE=$1
PASSWORD_PREFIX=$2
USER=${3:-server-admin}

while read -r host ip; do
  echo Removing from "$host"
  echo "$PASSWORD_PREFIX""$host" | ssh -tt "$USER"@"$ip" "sudo rm -rf $REMOTE"
done <servers.txt
