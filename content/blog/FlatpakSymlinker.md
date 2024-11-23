---
title: "Immutable distros & Improving the flatpak experience"
date: "2023-06-04"
weight: 1
type: docs
summary: "Tool to set short-name symlinks for flatpak's."
---

# The rise of immutable desktop Linux distros

If you are immersed in news regarding the Linux Desktop landscape, it's likely you have come into contact with 'Immutable distros'.

Examples of these in recent times:
- Fedora Silverblue
- OpenSUSE MicroOS 
- VanillaOS
- SteamOS (The OS that is run on the Steam Deck!)

In recent news, Canonical are due to create a desktop immutable distro aswell:
https://ubuntu.com/blog/ubuntu-core-an-immutable-linux-desktop

Personally, I think it's a very interesting and different approach to the Linux Desktop. Some claim it may be the future, but I suppose we'll see.

Most interesting to me is Fedora Silverblue. This makes for a clean base OS image, which is guaranteed to be more or less identical to any other system, and encourages app installs in containers. This provides many advantages, but a few obvious ones to note:

1. When troubleshooting is required, distro maintainers know exactly what to expect under the hood, so it reduces the likeliness of external packages affecting the system in unintended ways.
2. Upgrading your Linux distro is a smooth and painless experience, as you end up with an image that has been tested by thousands of people, so you know it will work.
3. Security. 90% of what a user wants to install, can be done without root permissions on their system. Containerised applications are the standard here, meaning that harmful software has little chance of infecting a user's system. There are packages such as drivers that will need to be layered on-top, but these are the minority.
4. Encourages keeping development tools in a dedicated sandbox, where they can't pile up on your base OS. You can just nuke a container once you are done with it. This is encouraged by tools such as 'toolbox' and 'distrobox'.

As a sidenote, not strictly tied to immutable distros, but distrobox is incredible! It provides an 'export' feature, where any apps installed inside a container gets a desktop icon, and you can call them from the terminal as if they are native. You can also pick any distro you like, so you aren't tied to what's in your standard repos.

# Flatpak is a reoccuring theme in immutable distros
Most immutable distros, with the exception of Ubuntu Core (because Canonical want to push Snaps instead), all have heavy reliance on the flatpak packaging format.

This is due to flatpak being all-around the most popular, and arguably best cross-distro packaging format.

For this reason, it makes sense to ensure flatpak is as useful as possible. With that in mind, I created this tool.

# Why do you need an additional tool?
If you have used flatpaks before, you might know that running applications from a terminal is kind of annoying...

You have a couple options for opening flatpak apps, none of them feel natural:
1. You can run: flatpak run something.something.something
2. You can add ~/.local/share/flatpak/exports/bin to PATH and then run apps as 'something.something.something'.

This isn't the most natural, a common example is how you would run firefox. Generally you would simply call 'firefox', but instead, for Flatpak, at a minimum you must run 'org.mozilla.firefox', which is harder to remember.

# How does it work?

You can see the source code here:
https://github.com/techtino/flatpak-symlinker

But to summarise, it checks for new flatpaks to be installed, checks the internal command that is run from flatpak, and creates a symlink named that.

Effectively, flatpak run org.mozilla.firefox becomes simply 'firefox'. This makes app installs fairly seamless, and from a user's perspective, it's exactly the same as it was before.
