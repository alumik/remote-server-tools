#!/bin/bash

LOCAL=$1
REMOTE=$2
PASSWORD="y]A-Sr.%2&"
SERVERS="10.10.1.208 10.10.1.209 10.10.1.210 10.10.2.211 10.10.2.212 10.10.1.213 10.10.1.214 10.10.2.215 10.10.1.216 10.10.2.217 10.10.1.218 10.10.1.219 10.10.2.220"

for server in $SERVERS; do
  echo Pushing to server "$server"
  scp -r "$LOCAL" server-maintainer@"$server":~/payload
  echo "$PASSWORD" | ssh -tt server-maintainer@"$server" "sudo mv ~/payload $REMOTE"
done
