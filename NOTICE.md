# Third-party notices

This repository packages and redistributes third-party software. The notices
below identify the principal components; each component keeps its upstream
license and copyright terms.

## AirDC++ Web Client

The portable archive in `dist/` contains the AirDC++ daemon and Web UI from
the AirDC++ Web Client project. AirDC++ Web Client is GPL-3.0-or-later.

- Project: <https://github.com/airdcpp-web/airdcpp-webclient>
- Linux binaries: <https://airdcpp.net/docs/installation/linux-binaries.html>

The archive is a compiled upstream-derived build for the native aarch64
target. Its source/version information is documented in `buildroot/README.md`.

## Buildroot and build dependencies

`buildroot/` contains a Buildroot configuration and builder definition used to
produce the portable archive. Buildroot and the libraries it builds are
separately licensed; consult their upstream source distributions and package
metadata for the applicable notices.

- Buildroot: <https://buildroot.org/>

## Runtime base and utilities

The runtime image uses Alpine Linux and installs `tini` and `su-exec` from
Alpine packages. Those projects retain their own licenses and notices.

- Alpine Linux: <https://www.alpinelinux.org/>
- tini: <https://github.com/krallin/tini>
- su-exec: <https://github.com/ncopa/su-exec>

This file is a navigation notice, not a replacement for the license files
distributed by the upstream projects or their package managers.
