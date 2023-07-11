#!/bin/bash

echo "Installing node exporter"
service node-exporter stop
cp node-exporter /usr/local/bin
chmod +x /usr/local/bin/node-exporter
cp node-exporter.service /etc/systemd/system/
systemctl enable --now node-exporter

if [ "${@: -1}" != "--cpu-only" ]; then
  echo "Installing NVIDIA GPU exporter"
  service nvidia-gpu-exporter stop
  cp nvidia-gpu-exporter /usr/local/bin
  chmod +x /usr/local/bin/nvidia-gpu-exporter
  cp nvidia-gpu-exporter.service /etc/systemd/system/
  systemctl enable --now nvidia-gpu-exporter
fi
