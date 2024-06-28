#!/bin/bash

BASEDIR=$(dirname "$0")
LOCAL=$1
REMOTE=$2
PASSWORD_PREFIX=$3
USER=${4:-server-admin}

while read -r host ip; do
  echo Pushing to server "$host"
  scp -r "$LOCAL" "$USER"@"$ip":~/payload
  echo "$PASSWORD_PREFIX""$host" | ssh -tt "$USER"@"$ip" "sudo mv ~/payload $REMOTE"
done <"$BASEDIR"/servers.txt
