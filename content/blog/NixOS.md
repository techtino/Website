---
title: "Reproducible (and automated) custom OS builds via NixOS flakes"
date: "2023-08-07"
weight: 1
type: docs
summary: "Reproduciable OS builds for my personal machines"
---
# Into The Unknown

NixOS is a Linux distro unlike any I've ever seen before, configuration works in an entirely new and different way as opposed to other Linux distributions.

This is because all of it's configuration is declarative, and can all be entirely managed from 1 configuration file (/etc/nixos/configuration.nix).

This means that as opposed to configuring networking, creating systemd services, setting global configuration, etc. can all be managed within one file if you wish to (or it can be individually split into different configuration files for modularity).

# Expanding on the existing configuration

After installing NixOS, you will have a default /etc/nixos/configuration.nix file, which you are free to expand as you wish, we can then rebuild the os based on it.

See the below guide on how to do so:

https://nixos.org/manual/nixos/stable/#sec-changing-config

The above also shows example configuration parameters that can be set here.

# Managing your home directory

NixOS can also allow for managing your home directory via a utility called 'home-manager', you can find docs on how to set this up here:

https://nix-community.github.io/home-manager/

I personally recommend trying out installing it as a NixOS module, as it allows you to manage everything from the same config files you are setting your other options in.

# Nix Flakes (Per-Host configuration via git)

Nix Flakes are an experimental feature which allows for storing per-host configuration for NixOS in a git repository (it can also do other stuff!), this essentially means that if your git repo is public, you can build a host based on your own (or other people's) configuration with a single command.

See a very good example of a flake you can try out here:

https://github.com/colemickens/nixos-flake-example#nixos-rebuild

# Secret storing via sops-nix

A lot of the time, you will have sensitive data that you'll want to be using in your configs. You can encrypt it and have it only accessible to machines (And users) that you wish to. See the below on how to get started:

https://github.com/Mic92/sops-nix

# Bringing it all together

With all of these pieces, I put together a git repository myself which does the following:

* Sets up common system configuration for a new host.
* Configures the home directory of my user, as well as manage desktop environment configuration (KDE currently), providing different settings per desktop environment or device type.
* Sets up custom settings for devices that deviate from the norm (nvidia gpu management)
* Configuration per a device type (laptop/desktop/vm), for example you would want to have power management setup for laptops, but not so much for desktops or vms.
* Auto sets up (and authenticates) to tailscale on a new machine via a reusable secret key.

This setup has a few benefits in terms of reducing bloat too, as you can simply decide on a whim to change out kde plasma for gnome and within minutes have an entirely clean desktop setup with gtk themes, qt themes, desktop environment specific programs with no gunk left behind. Often times removing a desktop environment, removing its display manager, removing all it's apps, cleaning up it's theming, cursor, font config etc can be quite a chore, and it's likely you'd leave something behind.

You can see my own configration here: https://github.com/techtino/nixos-flakes

By using my repo, you get an EXACT copy of my base configuration. It isn't fool-proof though, so the repo creator will have to remember to not manually set configuration independently of the git repo.

# Conclusion

There is definitely a learning hurdle to overcome with NixOS, and for most users there isn't realistically a reason to go down this rabbit-hole. Why bother automating your builds if you are never going to rebuild a new machine?

However, the reproducibility of builds achievable via NixOS could become very interesting in the future for enterprises of which require stable and consistent builds across their entire estate. There is a possibility it will reduce support overhead as there aren't strange differences in software that could be causing issues, as well as also simplify the upgrade process for machines. And if a new configuration is misbehaving, just boot into the old one! (They appear independently on grub).

Not to mention the various other benefits Nix itself has over traditional package managers (I haven't touched on Nix itself in this post at all!) One example is the ability to create a build environment tailor-made to building a specific application, without clogging up your system with build dependencies. Here's a handy guide on that: http://ghedam.at/15978/an-introduction-to-nix-shell
