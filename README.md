# Synthesis

[![Build status](https://github.com/synthesis-network/synthesis-go/actions/workflows/ci.yml/badge.svg)](https://github.com/synthesis-network/synthesis-go/actions/workflows/ci.yml)

## Introduction

Synthesis is an early-stage implementation of a fully end-to-end encrypted IPv6
network. It is lightweight, self-arranging, supported on multiple platforms and
allows pretty much any IPv6-capable application to communicate securely with
other Synthesis nodes. Synthesis does not require you to have IPv6 Internet
connectivity - it also works over IPv4.

## Supported Platforms

Synthesis works on a number of platforms, including Linux, macOS, Ubiquiti
EdgeRouter, VyOS, Windows, FreeBSD, OpenBSD and OpenWrt.

Please see our [Installation](https://synthesis-network.github.io/installation.html)
page for more information. You may also find other platform-specific wrappers, scripts
or tools in the `contrib` folder.

## Building

If you want to build from source, as opposed to installing one of the pre-built
packages:

1. Install [Go](https://golang.org) (requires Go 1.17 or later)
2. Clone this repository
2. Run `./build`

Note that you can cross-compile for other platforms and architectures by
specifying the `GOOS` and `GOARCH` environment variables, e.g. `GOOS=windows
./build` or `GOOS=linux GOARCH=mipsle ./build`.

## Running

### Generate configuration

To generate static configuration, either generate a HJSON file (human-friendly,
complete with comments):

```
./synthesis -genconf > /path/to/synthesis.conf
```

... or generate a plain JSON file (which is easy to manipulate
programmatically):

```
./synthesis -genconf -json > /path/to/synthesis.conf
```

You will need to edit the `synthesis.conf` file to add or remove peers, modify
other configuration such as listen addresses or multicast addresses, etc.

### Run Synthesis

To run with the generated static configuration:

```
./synthesis -useconffile /path/to/synthesis.conf
```

To run in auto-configuration mode (which will use sane defaults and random keys
at each startup, instead of using a static configuration file):

```
./synthesis -autoconf
```

You will likely need to run Synthesis as a privileged user or under `sudo`,
unless you have permission to create TUN/TAP adapters. On Linux this can be done
by giving the Synthesis binary the `CAP_NET_ADMIN` capability.

## Documentation

Documentation is available [on our website](https://synthesis-network.github.io).

- [Installing Synthesis](https://synthesis-network.github.io/installation.html)
- [Configuring Synthesis](https://synthesis-network.github.io/configuration.html)
- [Frequently asked questions](https://synthesis-network.github.io/faq.html)
- [Version changelog](CHANGELOG.md)

## Community

Feel free to join us on our [Matrix
channel](https://matrix.to/#/#synthesis:matrix.org) at `#synthesis:matrix.org`
or in the `#synthesis` IRC channel on [libera.chat](https://libera.chat).

## License

This code is released under the terms of the LGPLv3, but with an added exception
that was shamelessly taken from [godeb](https://github.com/niemeyer/godeb).
Under certain circumstances, this exception permits distribution of binaries
that are (statically or dynamically) linked with this code, without requiring
the distribution of Minimal Corresponding Source or Minimal Application Code.
For more details, see: [LICENSE](LICENSE).
