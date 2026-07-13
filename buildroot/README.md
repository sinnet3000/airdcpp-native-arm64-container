# Build the native ARM64 binary

This directory contains the Buildroot configuration and builder image used to
produce the native aarch64 AirDC++ portable archive in `dist/`.

The build uses a host directory named `.buildroot-work/`.

## 1. Build the builder image

Run these commands from the repository root:

```sh
docker build -f buildroot/Dockerfile.builder \
  -t airdcpp-buildroot-builder:with-deps .

mkdir -p .buildroot-work
docker run -d --name airdcpp-buildroot-builder \
  -v "$(pwd)/.buildroot-work:/work" \
  airdcpp-buildroot-builder:with-deps tail -f /dev/null
```

Open a shell in the builder:

```sh
docker exec -it airdcpp-buildroot-builder bash
```

## 2. Prepare Buildroot

Inside the builder, download the AirDC++ source and Buildroot:

```sh
cd /work
git clone --branch 2.14.0 --depth 1 \
  https://github.com/airdcpp-web/airdcpp-webclient.git airdcpp-src

wget https://buildroot.org/downloads/buildroot-2024.11.1.tar.gz
tar zxf buildroot-2024.11.1.tar.gz
mkdir -p buildroot-root
mv buildroot-2024.11.1 buildroot-root/aarch64

sh /work/airdcpp-src/buildroot/setup-buildroot-config.sh \
  /work/buildroot-root/aarch64/
```

From the host, copy the committed ARM64 configuration into the builder:

```sh
docker cp buildroot/aarch64.config \
  airdcpp-buildroot-builder:/work/buildroot-root/aarch64/.config
```

Back inside the builder, build the toolchain and libraries:

```sh
cd /work/buildroot-root/aarch64
export FORCE_UNSAFE_CONFIGURE=1
make -j4
```

The configuration selects the aarch64 target, musl, and the static libraries
needed by the AirDC++ portable build. `buildroot/aarch64.config` is the final
configuration used for the released archive.

## 3. Build the portable archive

Still inside the builder:

```sh
cd /work/airdcpp-src/buildroot
export BRANCH=master
export BUILD_THREADS=4
./build-portable.sh /work/buildroot-root /work/output aarch64
```

`BRANCH=master` is required because the build script performs a `git pull`
before checking the requested release version. The script produces the
versioned archive under:

```text
/work/output/packages/stable/
```

Copy the resulting archive to the repository's `dist/` directory from the
host:

```sh
docker cp airdcpp-buildroot-builder:/work/output/packages/stable/\
airdcpp_2.14.0_webui-2.14.0_aarch64_portable.tar.gz dist/
```

The archive contains a statically linked ARM64 `airdcppd`, the Web UI, and
`dcppboot.xml`. The root `Dockerfile` consumes this archive directly.
