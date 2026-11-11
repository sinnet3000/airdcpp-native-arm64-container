FROM alpine:3.24

# Native aarch64 runtime image. Alpine is available for aarch64, so the
# container runs without qemu-user emulation.
#
# The upstream image's own docker-entrypoint (root -> DOCKER_UID/DOCKER_GID setup ->
# docker-entrypoint.d hooks -> su-exec -> exec) is generic Alpine infra unrelated to
# the armhf/qemu issue, so it's carried over unchanged from container/docker-entrypoint.
RUN apk add --no-cache tini su-exec ca-certificates

COPY dist/airdcpp_2.14.0_webui-2.14.0_aarch64_portable.tar.gz /tmp/airdcpp.tar.gz
RUN mkdir -p /airdcpp && \
    tar xzf /tmp/airdcpp.tar.gz -C /airdcpp --strip-components=1 && \
    rm /tmp/airdcpp.tar.gz

COPY container/default_config /default_config
COPY container/docker-entrypoint /usr/local/bin/docker-entrypoint
COPY container/10-setup-volume.sh /etc/docker-entrypoint.d/99-extra-scripts/10-setup-volume.sh
COPY container/airdcpp /usr/local/bin/airdcpp

RUN chmod 0755 \
      /usr/local/bin/docker-entrypoint \
      /etc/docker-entrypoint.d/99-extra-scripts/10-setup-volume.sh \
      /usr/local/bin/airdcpp

EXPOSE 5600
VOLUME /config /downloads /shared

ENTRYPOINT ["tini", "/usr/local/bin/docker-entrypoint"]
CMD ["airdcpp"]
