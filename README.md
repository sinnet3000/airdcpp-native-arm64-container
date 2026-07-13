# AirDC++ native ARM64 container

This repository builds and runs AirDC++ Web Client 2.14.0 as a native
`linux/arm64` container. The daemon is an aarch64 build, so the running
container does not need `qemu-arm`.

The project is aimed at Apple Silicon Macs running Docker Desktop or OrbStack.
Some existing ARM container setups run a 32-bit `armhf` daemon through qemu;
this one uses a 64-bit ARM build instead, which keeps the application lighter
and avoids emulation at runtime.

The image is ARM64-only:

```text
ghcr.io/sinnet3000/airdcpp-native-arm64-container:2.14.0-arm64
```

## Performance

Full-library rehash performance, measured on an M1 MacBook Pro:

| | Native aarch64 | qemu-emulated armhf |
|---|---:|---:|
| Throughput | 435.78 MiB/s | 123.35 MiB/s |
| Memory (idle) | 18.4 MB | 47.0 MB |

## Run it

You need Docker with Compose support and two host directories: one for
downloads and one for shared files.

```sh
cp .env.example .env
```

Edit `.env`:

```dotenv
DOWNLOADS_DIR=/path/to/downloads
SHARE_DIR=/path/to/shared-files
```

Then start the service:

```sh
docker compose up -d
docker compose ps
```

Wait for the service status to become `healthy`, then open
<http://127.0.0.1:5600>. The initial login is `user` / `pass`. Change that
password before exposing the web interface beyond the local machine.

The Compose file publishes the active-mode ports used by this setup:

- TCP and UDP `21248`
- TLS/TCP `21249`

AirDC++ must use the same ports inside the container. If you need different
ports, replace these mappings in the ignored `compose.override.yaml` file.
Automatic UPnP is not assumed to work from inside a container or VM.

## Data and configuration

The `config/` directory stores AirDC++ settings, identity, favorite hubs, and
the file indexes. It stays on the host when the container is recreated. Do not
run `docker compose down --volumes`; the configuration directory is part of
the deployment's persistent state.

Downloads are writable at `/downloads`. Shared files are available at
`/shared` as read-only data.

The web interface stays bound to `127.0.0.1:5600` in the default Compose
configuration. Use an authenticated reverse proxy or a private network such
as Tailscale for remote administration.

## Build details

The runtime image uses Alpine Linux and unpacks the statically linked
AirDC++ portable archive from `dist/`. The archive was cross-compiled for
aarch64 with Buildroot. The reproducible build recipe and builder definition
are in [buildroot/](buildroot/).

The container also includes fixes for signal handling, read-only shares, and
the web health check. See `container/` for those files.

## License

The original files in this repository are GPL-3.0-or-later. Bundled AirDC++,
Buildroot, Alpine, `tini`, `su-exec`, and other third-party software keep their
own licenses. See [LICENSE](LICENSE) and [NOTICE.md](NOTICE.md).
