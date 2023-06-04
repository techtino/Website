---
title: "Learning how to write a gnome extension"
weight: 1
type: docs
summary: "One click hotspot connection in Gnome."
---

So, I had a week off from work, and I felt like learning how to create a gnome-shell extension, so here we are.

I've recently gotten myself a chromebook, and one of the main features I really like was the seamless connectivity to my phone's hotspot, as well as having features such as notifications, messaging, file transfer from/to my phone.

The second part was solvable via a handy tool called 'GSConnect', which is the gnome variant of 'KDE Connect', however I haven't found a solution/equivalent feature to 'Instant Hotspot' on Linux as of yet. I was meaning to learn a new skill, so seemed as good an opportunity as any to get stuck in!

The process of learning "GJS" and how to write a gnome extension weren't the smoothest, I'd have to admit. There aren't many examples/Docs of how to actually get started, however there were a few handy bits kicking around. I mostly modelled my project on https://gjs.guide/extensions/development/creating.html#gnome-extensions-tool as well as taking inspiration from various other gnome extensions, as well as examples from Gnome themselves at https://gitlab.gnome.org/GNOME/gnome-shell/-/tree/main/js/ui/status. I also hunted around other extensions to see how they are approaching similar functionality.

The experience has been fun so far regardless, and it's been a while since I was stuck-in with JavaScript.

Anyway, without further a do, here's roughly how it works:

Since we have no way to trigger our phone's hotspot to enable itself if it's disabled, this makes use of tasker on the phone's end.

Within tasker on android, I have a profile setup which enables mobile hotspot if the phone's bluetooth connects to my laptop.

This extension basically does a few minor things:
1. If not already connected to hotspot, connect to phone's bluetooth, which triggers the hotspot to enable via tasker.
2. Start connecting to the saved wifi network corresponding to the SSID of the phone's hotspot.
3. Disconnect bluetooth (because who needs their phone connected via bluetooth...)

When wanting to disconnect, you toggle it off, it disconnects the bluetooth just in-case it's still connected, then disconnects wifi.

Users will need to set their hotspot ssid and phone bluetooth mac address in the extensions settings before using, and also ensure that bluetooth is paired, and the hotspot has already been saved/connected to at least once.

You can get it here! https://github.com/techtino/gnome-extension-instant-hotspot
