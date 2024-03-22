#!/bin/sh
signal_distfiles=$(make -V DISTFILES | awk /cache/'{print $1}' | sed 's/:yarn//')
rsync -auv /usr/ports/distfiles/${signal_distfiles} root@azure:/mnt/resource/signal-desktop
