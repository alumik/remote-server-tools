#!/bin/bash

for account in $(getent passwd $(ls /home) | grep -o '^[^:]*')
do
  expires_string="$(sudo passwd -S "$account" | awk '{print $5}')"
  changed_date="$(sudo passwd -S "$account" | awk '{print $3}')"
  echo -e "ACCOUNT: $account\tEXPIRES: $expires_string\tCHANGED: $changed_date"
done
