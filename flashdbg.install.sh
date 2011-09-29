#!/bin/bash -v
# Script  created by
# Romeo-Adrian Cioaba romeo.cioaba@spotonearth.com
# Super minor updates by jason.melton[at]gmail[dot]com
# Released under GPL
# Modified by Valentine Sarychev dizel3d@gmail.com for Ubuntu 11.04

sudo -v; res=$?; if [ $res -ne 0 ]; then exit $res; fi

# Stopping any Firefox that might be running
sudo killall --regexp firefox

# Removing any other flash plugin previously installed:
sudo apt-get remove -y --purge flashplugin-installer flashplugin-nonfree gnash gnash-common mozilla-plugin-gnash swfdec-mozilla libflashsupport
sudo rm -f /usr/lib/mozilla/plugins/*flash*
sudo rm -f ~/.mozilla/plugins/*flash*
sudo rm -f /usr/lib/firefox/plugins/*flash*
sudo rm -f /usr/lib/firefox-addons/plugins/*flash*

# Installing nspluginwrapper
sudo apt-get install nspluginwrapper  

# Installing Flash Player 10
cd /tmp/
wget http://download.macromedia.com/pub/flashplayer/updaters/10/flashplayer_10_plugin_debug.tar.gz
mkdir flashplayer_10_plugin_debug
tar zxf flashplayer_10_plugin_debug.tar.gz -C flashplayer_10_plugin_debug
sudo cp flashplayer_10_plugin_debug/libflashplayer.so /usr/lib/mozilla/plugins/
sudo chmod +rx /usr/lib/mozilla/plugins/libflashplayer.so
sudo nspluginwrapper -v -i /usr/lib/mozilla/plugins/libflashplayer.so
rm -rf flashplayer_10_plugin_debug*
# Done :-)
