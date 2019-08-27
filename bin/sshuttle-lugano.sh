#!/bin/bash
reti="213.92.8.128/28 217.29.167.128/25 217.29.160.1/25 194.185.77.192/26 213.92.100.112/28 172.16.1.0/24 172.16.3.1/24 172.18.15.99/32 172.16.66.0/24"
echo "Executing: sshuttle -r admuser@boba.backplane $reti"
echo "-------------------------------------------------------------------------------------------------"
# sshuttle -r admuser@boba.backplane 213.92.8.128/28 217.29.167.138/32 217.29.160.68/32 194.185.77.192/26 213.92.100.112/28 172.16.1.0/24 172.16.3.86/32 172.16.3.218/32 172.16.3.219/32 172.18.15.99/32
sshuttle -r d.lippi@172.18.10.34 $reti
