# Tailscale-arm32v5
A ready-to-build Dockerfile of Tailscale-arm32v5.

This github repo is just me doing things, researching for fun. I'm no expert, I'm just following chatbot step-by-step to help solve my curiosity. I'm doing this for personal use, and if you happen to stumble upon this repo, you are welcome to use this but please don't ask me how to do this-or-that about this, because I'm just as confused as you (I don't know what I'm doing). 

I had a MikroTik Router, spefically E50UG model or so called the "hEX Refresh" (2024 Version). I saw it can do Containers in it, and it's ARM-based CPU with a USB slot and enough RAM to run Tailscale. The official Docker image of Tailscale from Dockerhub specifies that it can support arm32 (or just "arm"), arm64, and amd64, but it didnt specify which arm32 version. The only official supported arm32 version of Tailscale is arm32v7, which is a problem for me because the E50UG is running on arm32v5.

Tailscale happened to have their source code open source, so I could compile a Tailscale image with arm32v5 using Docker desktop.

So there's the Dockerfile, you compile it yourself if you happen to need the latest version of Tailscale.

It's currently running on 1.98.3 version by the time I'm writing this.

I can't provide a version of Tailscale I'm running because it's too big for github repo (it's around 60mb-ish), just do it yourself haha.

And yeah, sorry for (if any) bad english.
