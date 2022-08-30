#!/bin/bash

systemctl disable --now node-exporter
systemctl disable --now nvidia-gpu-exporter

rm /usr/local/bin/node-exporter
rm /usr/local/bin/nvidia-gpu-exporter
rm /etc/systemd/system/node-exporter.service
rm /etc/systemd/system/nvidia-gpu-exporter.service
