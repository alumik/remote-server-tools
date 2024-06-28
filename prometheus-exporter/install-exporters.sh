#!/bin/bash

USER=${1:-server-admin}

echo "Installing node exporter"
service node-exporter stop
cp node-exporter /usr/local/bin
chmod +x /usr/local/bin/node-exporter
cp node-exporter.service /etc/systemd/system/
sed -i "s/server-admin/$USER/g" /etc/systemd/system/node-exporter.service
systemctl enable --now node-exporter

echo "Installing NVIDIA GPU exporter"
service nvidia-gpu-exporter stop
cp nvidia-gpu-exporter /usr/local/bin
chmod +x /usr/local/bin/nvidia-gpu-exporter
cp nvidia-gpu-exporter.service /etc/systemd/system/
sed -i "s/server-admin/$USER/g" /etc/systemd/system/nvidia-gpu-exporter.service
systemctl enable --now nvidia-gpu-exporter
