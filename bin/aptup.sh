#!/bin/sh
sudo aptitude -r update
sudo aptitude -yr upgrade
sudo apt autoremove -y
