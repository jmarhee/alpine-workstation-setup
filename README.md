# Alpine Linux Workstation Setup

These scripts configure the basics for my [Alpine Linux](https://alpinelinux.org) workstation.

## Configure Wireless Network

The `wireless_net.sh` script configures a Wifi client. 

### Usage

This requires `SSID`, `WIFI_PASS`, and `CONNECT_ON_BOOT`, if not provided like so:

```bash
SSID="mynetwork" WIFI_PASS="p@$$w0rd" CONNECT_ON_BOOT="y" ./wireless_net.sh 
```

otherwise, you'll be prompted as the script runs.

## Configure XFCE Desktop

This script configures an administrative user, installs the desktop environment, and configures services for startup.

### Usage

This requires `USER`, `PASS`, and `DRIVER` (for your chipset, i.e. `intel`, or `vmware`):

```bash
USER="me" PASS="s3cr3t" DRIVER="modesetting" ./desktop.sh
```

If not provided, you will be prompted as the script runs.

** Note for Virtualized Guests **

Per the [Alpine Linux documentation](https://wiki.alpinelinux.org/wiki/XFCE_Setup#Video_packages):

<blockquote>
Use xf86-video-modesetting for Qemu/KVM guests.
Tip: Probably for KVM/Qemu guests you want to use qxl Video and Display Spice. For this purpose install xf86-video-qxl on guest and run a Spice client on the host

Use xf86-video-vmware and xf86-video-vboxvideo for Virtualbox/VMware guests.
Tip: If you want to run XFCE in an Oracle VM Virtual Box, you need to install the VirtualBox guest additions as well. They contain parts of the driver, without them, XFCE won't start.

Use xf86-video-fbdev for Hyper-V guests.
Tip: If you use Hyper-V, you should install the Hyper-V guest services as well.

Use xf86-video-geode for Alix1D. 
</blockquote>

