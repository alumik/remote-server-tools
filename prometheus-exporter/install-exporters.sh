#!/bin/bash

cp node-exporter /usr/local/bin
cp nvidia-gpu-exporter /usr/local/bin
chmod +x /usr/local/bin/node-exporter
chmod +x /usr/local/bin/nvidia-gpu-exporter
cp node-exporter.service /etc/systemd/system/
cp nvidia-gpu-exporter.service /etc/systemd/system/

systemctl enable --now node-exporter
systemctl enable --now nvidia-gpu-exporter
