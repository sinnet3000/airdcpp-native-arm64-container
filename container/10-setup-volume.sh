#!/bin/sh
set -eu

# Configuration must be writable by the runtime user. Do not recursively touch
# Downloads or shared libraries: they may be large bind mounts or read-only.
chown -R "$DOCKER_USER:$DOCKER_GROUP" /config
chown "$DOCKER_USER:$DOCKER_GROUP" /downloads

# The base image creates this link from its non-root launcher. Create it while
# the entrypoint still has permission to modify /airdcpp.
if ! [ -e /airdcpp/config ]; then
  ln -s /config /airdcpp/config
fi
