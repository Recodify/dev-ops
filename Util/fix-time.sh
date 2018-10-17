#!/bin/bash

timedatectl set-ntp true
systemctl restart systemd-timesyncd.service


