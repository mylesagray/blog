---
title: "Music Production on Linux"
author: Myles Gray
date: 2025-08-27T19:52:03+01:00
lastmod: 2025-08-27T19:52:03+01:00
type: posts
description: "Getting a fully funtional DAW environment on Linux, and enabling your Windows plugins too."
url: /music/music-production-linux
cover:
  relative: true
  image: images/bitwig-archetype-linux.png
  alt: "BitWig with NeuralDSP Archetype Plini running on Linux"
categories:
  - Music
  - Miscellaneous
tags:
  - music
  - linux
  - wine
draft: true
---

## Introduction

I've been on a long-term exodus of the Microsoft ecosystem, having used macOS for approaching a decade and a half now. Even my gaming PC (which is a full VR flight-sim rig with _many_ custom controllers) is all Linux based (Arch, btw) and it all works rather well. I'm picking back up an old hobby of mine from when I was a teenager and am getting back into music production and playing guitar - that leads to the question... _"If I'm going to buy a DAW and plugins, what do I buy?"_.

My Macs are getting long in the tooth and no-longer receive updates - _nor_, it turns out, can you even install Linux on them! Thanks T2 chip. So, if i'm going to set up my music workstation next to all my recording gear, it's not going to be Windows, nor is it going to be a Mac, so Linux it is, and all of the fun that entails /s.

## Picking a Distro

This was actually pretty easy, there are a few Linux distros pre-setup out there as full creative workstation OSes, but the one that caught my eye (no small thanks to my Arch experience on my gaming PC) was a distribution of Ubuntu called [Ubuntu Studio](https://ubuntustudio.org/), specifically after some troubleshooting with various Windows plugins in `Wine` with `yabridge` that you need to be running `24.04 LTS` _not_ `25.04`.

So let's go on a journey of setting up a second hand Dell Optiplex 3090 Micro as my new "under-the-keyboard" **DAWsbox**.

## Install, Update, Patch

```sh
sudo dpkg --add-architecture i386
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt reboot
lsb_release -c

# Install realtime kernel from menu

sudo mkdir -pm755 /etc/apt/keyrings
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
cat /etc/os-release 
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources

sudo apt update
apt-cache madison winehq-staging
sudo apt install --install-recommends winehq-staging=9.21~noble-1 wine-staging=9.21~noble-1 wine-staging-i386=9.21~noble-1 wine-staging-amd64=9.21~noble-1 wine-staging-dev=9.21~noble-1
wine explorer

sudo apt-get install gpgv wget
wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_11.2.0_all.deb
sudo dpkg -i kxstudio-repos_11.2.0_all.deb

sudo apt update
sudo apt install wineasio-i386 
sudo apt install wineasio

sudo apt install winetricks

winetricks d3dx9 dotnet35 dotnet452 dxvk gdiplus vcrun2019 corefonts tahoma
sudo apt-mark hold wine-staging winehq-staging wine-staging-i386 wine-staging-amd64 wine-staging-dev
wine explorer

unzip LicenseSupportInstallerWin64.zip 
rm -rf LicenseSupportInstallerWin64.zip 
tar -xvf reaper744_linux_x86_64.tar.xz 
rm -rf reaper744_linux_x86_64.tar.xz 

cd ~/Downloads/
tar -zxf yabridge-5.1.1.tar.gz 
rm -rf yabridge-5.1.1.tar.gz 
mv yabridge/ ~/.local/share/
echo "PATH=\"$HOME/.local/share/yabridge:$PATH\"" >> ~/.bashrc

mkdir -p "$HOME/.wine/drive_c/Program Files/Common Files/CLAP"
mkdir -p "$HOME/.wine/drive_c/Program Files/Common Files/VST3"
mkdir -p "$HOME/.wine/drive_c/Program Files/Steinberg/VstPlugins"
mkdir -p "$HOME/.wine/drive_c/Program Files/VstPlugins"
yabridgectl add "$HOME/.wine/drive_c/Program Files/Common Files/CLAP"
yabridgectl add "$HOME/.wine/drive_c/Program Files/Common Files/VST3"
yabridgectl add "$HOME/.wine/drive_c/Program Files/Steinberg/VstPlugins"
yabridgectl add "$HOME/.wine/drive_c/Program Files/VstPlugins"
yabridgectl status

cd Downloads
sudo apt install ./bitwig-studio-5.3.13.deb

cd reaper_linux_x86_64
./install-reaper.sh
cd ..

wine LicenseSupportInstallerWin64_v5.10.1_8eb337be/License\ Support\ Win64.exe

wineasio-register
wine Cortex\ Control\ v1.3.1.exe

wine Archetype\ Cory\ Wong\ X\ v1.0.1.exe
wine Archetype\ Plini\ X\ v1.0.2.exe
wine ~/.wine/drive_c/Program\ Files/Neural\ DSP/Archetype\ Cory\ Wong\ X/Archetype\ Cory\ Wong\ X.exe
wine ~/.wine/drive_c/Program\ Files/Neural\ DSP/Archetype\ Plini\ X/Archetype\ Plini\ X.exe

# Install rtcqs and run optimiations
cd ~/Documents/src
git clone https://codeberg.org/rtcqs/rtcqs.git
cd rtcqs
sudo apt install pipenv
pipenv install rtcqs
pipenv shell
rtcqs

# Turn off SMT (Multithreading)
echo off | sudo tee /sys/devices/system/cpu/smt/control

# Turn off Spectre/Meltdown vuln mitigations (allows speculative execution - good, it's fast)
sudo vim /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash mitigations=off"

# Address Power Management from DAWs
wget https://raw.githubusercontent.com/Ardour/ardour/refs/heads/master/tools/udev/99-cpu-dma-latency.rules && sudo mv 99-cpu-dma-latency.rules /etc/udev/rules.d/.
sudo udevadm control --reload-rules
sudo udevadm trigger
udevadm info -a -n /dev/cpu_dma_latency

# Set CPU governor to performance
sudo systemctl mask ondemand.service
sudo cpupower frequency-set -g performance

ENABLE="true"
GOVERNOR="performance"
MAX_SPEED="0"
MIN_SPEED="0" 

# JACK config
sudo apt install cadence

```


## Links

### Tools

 - [Ubuntu Studio](https://ubuntustudio.org/)
 - [rtcqs](https://codeberg.org/rtcqs/rtcqs)
 - [BitWig Studio](https://www.bitwig.com/download/)
 - [Reaper](https://www.reaper.fm/download.php)
 - [REALIVE](https://www.realive.fm/pages/realive-7-manual)

### References

 - [Pro Audio on Linux using Ubuntu and Bitwig](https://www.youtube.com/watch?v=C45rLPAtRD8)
 - [Music-making in Linux with Bitwig and Yabridge](https://www.litui.net/music-in-linux/)
 - [How to get NeuralDSP working on Linux](https://old.reddit.com/r/NeuralDSP/comments/x1rzpr/how_to_get_neuraldsp_working_on_linux_tutorial/)
 - [How to Control the Quad Cortex With MIDI](https://www.youtube.com/watch?v=3X9HIZ3jZ0o)