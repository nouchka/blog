---
title: VPN and proxy on Ubuntu with NetworkManager
author: Jah
type: post
date: 2014-07-12T11:08:39+00:00
url: /2014/07/12/vpn-and-proxy-on-ubuntu-with-networkmanager/
categories:
  - Tech

---
If you are using a VPN sometimes and you want to change the proxy settings when you launch your VPN:

Create a file in directory /etc/NetworkManager/dispatcher.d/

/etc/NetworkManager/dispatcher.d/20proxyvpn

<pre>#!/bin/bash

IF=$1
STATUS=$2
 
if [ "$IF" == "tun0" ]
then
    case "$2" in
        vpn-up)
        logger -s "$0 Script up triggered"
        gsettings set org.gnome.system.proxy autoconfig-url "http://yourdomain.lan/proxy.pac"
        gsettings set org.gnome.system.proxy mode "auto"
        ;;
        vpn-down)
        logger -s "$0 Script down triggered"
        gsettings set org.gnome.system.proxy mode "none"
        ;;
        pre-up)
        ;;
        post-down)
        ;;
        *)
        ;;
    esac
fi
</pre>

This bash script will be trigger when a connexion is up or down.
  
In our case, we only check on tun0 vpn interface.
  
On up event, we change gnome settings to set the proxy pac file and on down event we reset the proxy to none.

I think this script should be adapt if you are using multiple VPN.

It works if you are using the network manager and gnome.