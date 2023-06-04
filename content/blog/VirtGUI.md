---
title: "Virtual Machine Management"
weight: 1
type: docs
summary: Managing multiple virtual machines with the Web UI
---

## Reasoning for creating the Web UI
During my third year of university, I had to create a project that would tackle a real-world issue.

Personally, I believe that virtualization is the future of Networking and System Administration and that it should be made as functional and easy to use as possible.

## What was required

This involved producing an easy on the eyes Web UI that can be accessed remotely to manage virtual machines. The machines could be created from scratch, or with sane defaults. The user could then edit it to their liking at any point and then view the machines via VNC technologies. It also was designed to manage multiple hypervisor technologies with the same UI, simplifying the process of managing each and reducing the need to use individual applications to manage each.

## How was it implemented?

In order to achieve this, I utilised various technologies. One of which was the Django web framework to draw the HTML and CSS elements on the web page and populate them with information gathered from the Libvirt API, as well as POSTing the user inputted values in order to interact with the virtual machines. 

NoVNC was used to effectively provide a means to view the contents of each running virtual machine from within a browser. With additional time I would have implemented guacamole to enable RDP as well as SSH access to virtual machines over a web browser. Various other technologies were used along the way to ensure security of the website.
