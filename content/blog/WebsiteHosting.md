---
title: "Website Hosting with Cloudflare Pages"
weight: 1
type: docs
summary: Migrating my website from a locally hosted hugo instance, to cloudflare.
---

# The old way
Recently I figured it's probably a good idea to move my website off my local server at home. This was for a few reasons:
- I frequently play around with my server configuration, so could easily take down my website for days at a time.
- I don't want to rely on my physical machine, as it's prone to failure, whether it's hardware related or software related where I end up filling up my disk and having to extend the LVM... (as happened the other day).
- Editing pages on my website used to consist of me ssh'ing to my server, and editing my markdown files with vim, which is not the most elegant way of doing it.
- I used to host hugo-server inside a docker container, which means if I needed to update the hugo version, I would have downtime.

All that being said, the new solution is much more elegant.

# How to set up the new way

Cloudflare has so many features, yet I had no idea that this was one of them.
https://pages.cloudflare.com/

Cloudflare Pages is kind of magical, it does practically everything for you.

In my case, all I had to was:
1. Upload my hugo src files to a new github repo (Adding the papermod theme as a submodule).
2. Create a page on cloudflare pages, selecting hugo from the drop-down, connect my github account, and point to that repo.
3. Additionally, due to some weird bug when using the papermod theme, I had to set the environment variable (HUGO_VERSION) to whatever hugo version I wanted to use. Cloudflare has an option to do this already, so I just set the variable as it was on my old server.
4. Then, cloudflare will check the repo, and build the site!
5. Cloudflare will also give you an option to use a custom domain, if you choose to, and since I manage DNS via cloudflare anyway, I told it 'www.techtino.co.uk' and 'techtino.co.uk'. It then created the dns records for me.
6. After waiting for DNS shenanigans, the website is now accessible!

From that point on, cloudflare will fire off a new hugo build every time I commit to my git repo, meaning all I have to do is update md files in my git repo, and push them! (As I'm doing right now...)

# Other considerations (Why not github pages?)

I had originally decided on using github pages to host this, however I decided against because it looks like you have to manually create the github workflow to have it auto-magically build, whilst cloudflare has a native option.

Furthermore, cloudflare natively integrates with DNS, as expected.
I'm also using cloudflare for my email routing, DNS, SSL etc so it just makes sense to keep that trend going.

Docs for github pages setup are below:
https://gohugo.io/hosting-and-deployment/hosting-on-github/

# End result
The website you are on right now is hosted by cloudflare, and is much more reliable and easy to manage! In-fact this blog post was written in the native github editor.
