#!/bin/bash

# Automates <https://wiki.alpinelinux.org/wiki/Connecting_to_a_wireless_access_point>

function pkgs() {
	apk --update add \
	wireless-tools \
	wpa_supplicant
}

function configIface() {
	if [ "$(ip link | awk '{print $2}' | grep wlan0 | wc -l)" = "1" ]; then \
		echo "OK"
	else
		echo "wlan0 not found"
		exit 1
	fi

	ip link set wlan0 up
}

function connectNetwork() {
	if [ ! ${SSID} ]; then
		read -p "WiFi Network SSID: " SSID
	fi
	if [ ! ${WIFI_PASS} ]; then
		read -p "WiFI Pass: " WIFI_PASS
	fi

	wpa_passphrase "$SSID" "$WIFI_PASS" > /etc/wpa_supplicant/wpa_supplicant.conf
	wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf && \
	udhcpc -i wlan0 && \
	ip addr show wlan0

	if [ ! ${CONNECT_ON_BOOT} ]; then
		read -p "Connect to ${SSID} on boot? [y/n] " CONNECT_ON_BOOT
	fi

	if [ "$CONNECT_ON_BOOT" = "y" ]; 
		rc-update add wpa_supplicant boot ; \	
		rc-update add wpa_cli boot
	fi
}

pkgs && \
configIface && \
connectNetwork
