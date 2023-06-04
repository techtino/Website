---
title: "Future plans for Server/Desktop Infrastructure"
weight: 1
type: docs
summary: Using Virtualization for my Desktop/Servers
---

I dream of a future with only 1 machine required for everything I do.

For this reason, I will be attempting to move my general server (NAS, website and various docker containers) as well as PFsense and my desktop all onto the same machine by utilising Proxmox.

## Resource Allocation

Some may think to themselves, "How do you have the resources, will each machine run efficiently?".

Firstly, by utilising my 24 thread Ryzen 9 3900x and 32GB RAM, I should have plenty of cores and RAM to spare for running all my services and still have enough for desktop use. E.g. my main server virtual machine only requires roughly 2 cores and 2GB of RAM, whilst PFSense requires even less, depending on the scale of my network in the future, I could scale up or down the resources dedicated to it, but following the PFsense documentation shows that having even as little as an 8GB storage drive and 1GB of RAM is required. I will start off with 2 cores and 2GB of RAM to give extra headroom.

At this rate, I still have 20 threads remaining to do whatever I please with! Once again, 2 cores will be used as the base and be dedicated to the host (Proxmox) and another 2GB of RAM. The benefit of virtual machines is I can easily increase or decrease the resource allocation as needed.

This means I still have 18 threads left for a desktop VM for daily use!

## Device Passthrough

Some of the virtual machines require devices to be passed through in order to have an optimal experience. 

For instance, the Desktop VM will have my Nvidia Graphics Card passed through to ensure 3D graphics performance is top notch, as well as be able to game and do intensive tasks if I need to. As well as this, the NVME controller will be passed through to utilise my NVME storage drive at native speeds, meaning I don't have to rely on slow virtualised storage mediums. Finally, both USB Controllers on my motherboard will be passed through to ensure easy access to USB hardware as if it were a regular machine.

The PFSense VM will have access to a PCI-E Network Interface Card with 4 ports to enable for it to be configured with real hardware and not cause issues specific to virtualisation.

Finally, the general server VM will not have any PCIE based devices passed through, however a 2TB HDD will be passed through using a virtualized driver for simple NAS purposes (storing movies, TV shows, and general data). In the future I will purchase more drives and setup RAID on Proxmox to utilise all the drives in a way that gives me enough storage, yet keeps the data intact if a drive were to fail (Most likely RAID 1 or RAID 5).

## How's performance going to be?
My desktop VM will utilise CPU pinning to block off the cores it is utilising from the Proxmox host and the other VMs. This means that, in theory, performance should be nearly indistinguable from a standard non-virtualised machine as the cores will not be hogged up by processes on other VMs.

## Why would you want to do this??

Just recently, I had a motherboard failure on the machine I was using for the general servers where the USB ports and Ethernet ports would fail after the machine is running for several hours. If I were to expand my infrastructure into various other machines also, I would have to purchase more hardware, and if it were to fail outside of a warranty period I would have to spend a lot more money.

Comparing this with one server that uses virtual disk images makes it a no-brainer. If this machine were to break in some way, It's the only machine I would have to repair, saving time and money. I could also utilise snapshots to restore virtual machines to a prior state in the case where they fail in some way, and could easily back up servers by doing a weekly or monthly backup of the virtual disk images.

## Conclusion
If all goes according to plan, I should have an 18 core Desktop with 26GB RAM and a powerful Graphics Card, whilst still having functioning servers with adequate performance all running on the same box.
