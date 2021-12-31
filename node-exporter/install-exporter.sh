#!/bin/bash

scp -r lidongwen@"$1":~/zhongzhenyu/server-management/node-exporter .
cd node-exporter || exit

mv node-exporter /usr/local/bin
mv nvidia-gpu-exporter /usr/local/bin
mv node-exporter.service /etc/systemd/system/
mv nvidia-gpu-exporter.service /etc/systemd/system/

systemctl enable --now node-exporter
systemctl enable --now nvidia-gpu-exporter
