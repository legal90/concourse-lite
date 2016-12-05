#!/bin/bash

set -ex

apt-get install -y linux-headers-$(uname -r) build-essential make perl dkms

mount -o loop /home/vagrant/prl-tools-lin.iso /media/cdrom

/media/cdrom/install --install-unattended-with-deps
umount /media/cdrom
rm -f /home/vagrant/prl-tools-lin.iso

apt-get remove -y linux-headers-$(uname -r)
