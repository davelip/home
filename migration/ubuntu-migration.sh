#!/bin/bash
#
# Lista dei pacchetti apt installati manualmente (non le dipendenze)
apt-mark showmanual > ./pacchetti-manuali.txt

# Snap e Flatpak
snap list > ./snap-list.txt
flatpak list > ./flatpak-list.txt 2>/dev/null

# Repo di terze parti (per sapere cosa riaggiungere)
grep -rh ^deb /etc/apt/sources.list.d/ > ./repo-terzi.txt 2>/dev/null
grep -rh URIs /etc/apt/sources.list.d/*.sources >> ./repo-terzi.txt 2>/dev/null
