#!/usr/bin/env bash

usage() {
  echo "Usage: $0 { login | logout } -a <address> -u <username> -p <password>"
  exit 1
}

method="$1"
shift

login() {
  curl "http://202.113.18.106:801/eportal/?c=ACSetting&a=Login&loginMethod=1&protocol=http%3A&hostname=202.113.18.106&port=&iTermType=1&wlanuserip=$address&wlanacip=null&wlanacname=zx_&redirect=null&session=null&vlanid=0&mac=00-00-00-00-00-00&ip=$address&enAdvert=0&jsVersion=2.4.3&DDDDD=$username&upass=$password&R1=0&R2=0&R3=0&R6=0&para=00&0MKKey=123456&buttonClicked=&redirect_url=&err_flag=&username=&password=&user=&cmd=&Login=" \
    -H 'Connection: keep-alive' \
    -H 'Upgrade-Insecure-Requests: 1' \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
    -H "Referer: http://202.113.18.106/a70.htm?wlanuserip=$address&wlanacip=null&wlanacname=zx_&vlanid=0&ip=$address&ssid=null&areaID=null&mac=00-00-00-00-00-00&switch_url=null&ap_mac=null&client_mac=null&wlan=null" \
    -H 'Accept-Language: zh-CN,zh;q=0.9' \
    --compressed \
    --insecure
}

logout() {
  curl 'http://202.113.18.106:801/eportal/?c=ACSetting&a=Logout&loginMethod=1&runRadius=1&DDDDD=&protocol=http%3A&hostname=202.113.18.106&port=&iTermType=1&wlanuserip=null&wlanacip=null&wlanacname=null&redirect=null&session=null&vlanid=undefined&mac=00-00-00-00-00-00&ip=&queryACIP=0&jsVersion=2.4.3'
}

if [[ "$method" == "login" ]]; then
  while getopts "a:u:p:" opt; do
    case $opt in
    a) address="$OPTARG" ;;
    u) username="$OPTARG" ;;
    p) password="$OPTARG" ;;
    \?) usage ;;
    esac
  done
  if [[ -z "$address" || -z "$username" || -z "$password" ]]; then
    echo "Missing arguments" >&2
    usage
  fi
  echo "Logging in network"
  printf "Server address: %s\n" "$address"
  printf "Username: %s\n" "$username"
  printf "Password: %s\n" "$password"
  login
  echo -ne '\b'
elif [[ "$method" == "logout" ]]; then
  echo "Logging out network"
  logout
  echo -ne '\b'
else
  echo "Invalid action" >&2
  usage
fi
