#!/bin/bash

# Automates <https://wiki.alpinelinux.org/wiki/XFCE_Setup>

function update_repos() {
	for r in $(grep community /etc/apk/repositories); do echo $(echo $r | sed -e 's|#||g') | tee -a /etc/apk/repositories; done && \
	apk update
}

function pkgs() {
	
	echo "Use xf86-video-modesetting for Qemu/KVM guests.
Tip: Probably for KVM/Qemu guests you want to use qxl Video and Display Spice. For this purpose install xf86-video-qxl on guest and run a Spice client on the host

Use xf86-video-vmware and xf86-video-vboxvideo for Virtualbox/VMware guests.
Tip: If you want to run XFCE in an Oracle VM Virtual Box, you need to install the VirtualBox guest additions as well. They contain parts of the driver, without them, XFCE won't start.

Use xf86-video-fbdev for Hyper-V guests.
Tip: If you use Hyper-V, you should install the Hyper-V guest services as well."

	if [ ! ${DRIVER} ]; then
		read -p "Which video driver? (i.e. intel, vmware) " DRIVER
	fi

	setup-xorg-base xfce4 xfce4-terminal lightdm-gtk-greeter xfce-polkit xfce4-screensaver consolekit2 dbus-x11 sudo && \

	if [ "$(apk search xf86-video-$DRIVER | wc -l)" = "0" ]; then
		echo "Invalid driver specified" ;
		exit 1
	else
		apk --update add xf86-video-$DRIVER
	fi

	apk add xf86-input-synaptics ; \
	apk add xf86-input-mouse xf86-input-keyboard kbd
}

function config_user(){
	if [ ! ${USER} ]; then
		read -p "Username: " USER
	fi
	
	if [ ! ${PASSWORD} ]; then
		read -sp "Password: " PASSWORD
	fi

	adduser --quiet --disabled-password --shell /bin/ash --home /home/$USER --gecos "User" $USER && \
	echo "$USER:$PASSWORD" | chpasswd && \
	echo "$USER   ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
}

function svcs() {
	rc-service dbus start && \
	rc-update add dbus && \
	rc-service lightdm start && \
	rc-update add lightdm && \
	apk add faenza-icon-theme gvfs-fuse gvfs-smb
}

update_repos && \
pkgs && \
config_user && \
svcs
