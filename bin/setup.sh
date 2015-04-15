#!/bin/sh
################################################################################
# CONFIG
################################################################################

# Packages which are pre-installed
INSTALLED_PACKAGES="ca_root_nss virtualbox-ose-additions bash sudo ezjail"
RAW_REPOSITORY="raw.githubusercontent.com/ivan-iver/freebsd-vagrant-erlang"
VAGRANT_PRIVATE_KEY="https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub"

# Configuration files
MAKE_CONF="https://$RAW_REPOSITORY/master/etc/make.conf"
PKG_CONF="https://$RAW_REPOSITORY/master/usr/local/etc/pkg/repos/FreeBSD.conf"
RC_CONF="https://$RAW_REPOSITORY/master/etc/rc.conf"
RESOLV_CONF="https://$RAW_REPOSITORY/master/etc/resolv.conf"
LOADER_CONF="https://$RAW_REPOSITORY/master/boot/loader.conf"
EZJAIL_CONF="https://$RAW_REPOSITORY/master/usr/local/etc/ezjail.conf"
PF_CONF="https://$RAW_REPOSITORY/master/etc/pf.conf"
KERLRC="https://$RAW_REPOSITORY/master/home/kerlrc"

# Message of the day
MOTD="https://$RAW_REPOSITORY/master/etc/motd"


################################################################################
# PACKAGE INSTALLATION
################################################################################

# Setup pkgng
# cp /usr/local/etc/pkg.conf.sample /usr/local/etc/pkg.conf
fetch -o /usr/local/etc/pkg.conf $PKG_CONF
pkg update
pkg upgrade -y
pkg update

# Install required packages
for p in $INSTALLED_PACKAGES; do
   pkg install -y "$p"
done

pkg_add -r git

################################################################################
# Erlang Installation
################################################################################
# Default
pkg install -y lang/erlang

# -------------------------
# Build from source (using kerl: https://github.com/yrashk/kerl)
# -------------------------
# curl -O https://raw.github.com/spawngrid/kerl/master/kerl; chmod a+x kerl
# fetch -o /home/vagrant/.kerlrc $KERLRC

## This builds the Erlang distribution, and does all the steps required to manually install Erlang for you.
# ./kerl build R15B01 r15b01
# ./kerl install r15b01 ~/erlang/r15b01
# . ~/erlang/r15b01/activate

# -------------------------
# Using Ports
# -------------------------
# portsnap fetch
# portsnap extract

# cd /usr/ports/
# make quicksearch name="erlang"
# or
# cd /usr/ports/lang/erlang/
# make install clean

################################################################################
# Configuration
################################################################################

# Create the vagrant user
# pw useradd -n vagrant -s /usr/local/bin/bash -m -G wheel -h 0 <<EOP
# vagrant
# EOP

# Enable sudo for this user
# echo "%vagrant ALL=(ALL) NOPASSWD: ALL" >> /usr/local/etc/sudoers

# Authorize vagrant to login without a key
mkdir /home/vagrant/.ssh
touch /home/vagrant/.ssh/authorized_keys
chown vagrant:vagrant /home/vagrant/.ssh

# Get the public key and save it in the `authorized_keys`
fetch -o /home/vagrant/.ssh/authorized_keys $VAGRANT_PRIVATE_KEY
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys

[ ! -f /etc/make.conf ] || rm /etc/make.conf
fetch -o /etc/make.conf $MAKE_CONF

[ ! -f /etc/rc.conf ] || rm /etc/rc.conf
fetch -o /etc/rc.conf $RC_CONF

[ ! -f /etc/resolv.conf ] || rm /etc/resolv.conf
fetch -o /etc/resolv.conf $RESOLV_CONF

[ ! -f /boot/loader.conf ] || rm /boot/loader.conf
fetch -o /boot/loader.conf $LOADER_CONF

[ ! -f /etc/motd ] || rm /etc/motd
fetch -o /etc/motd $MOTD

[ ! -f /usr/local/etc/ezjail.conf ] || rm /usr/local/etc/ezjail.conf
fetch -o /usr/local/etc/ezjail.conf $EZJAIL_CONF

[ ! -f /usr/local/etc/pf.conf ] || rm /usr/local/etc/pf.conf
fetch -o /usr/local/etc/pf.conf $PF_CONF


################################################################################
# CLEANUP
################################################################################

# Clean up installed packages
pkg clean -a -y

# Remove the history
cat /dev/null > /root/.history

# Try to make it even smaller
#while true; do
#    read -p "Would you like me to zero out all data to reduce box size? [y/N] " yn
#    case $yn in
#        [Yy]* ) dd if=/dev/zero of=/tmp/ZEROES bs=1M; break;;
dd if=/dev/zero of=/tmp/ZEROES bs=1M;
#        [Nn]* ) break;;
#        * ) echo "Please answer yes or no.";;
#    esac
#done

# Empty out tmp directory
rm -rf /tmp/*

# DONE!
echo "We are all done. Poweroff the box and package it up with Vagrant."
