# Monolithic Game Download Cache Docker Container

![Docker Pulls](https://img.shields.io/docker/pulls/lancachenet/monolithic?label=Monolithic) ![Docker Pulls](https://img.shields.io/docker/pulls/lancachenet/lancache-dns?label=Lancache-dns) ![Docker Pulls](https://img.shields.io/docker/pulls/lancachenet/sniproxy?label=Sniproxy) ![Docker Pulls](https://img.shields.io/docker/pulls/lancachenet/generic?label=Generic)

## Fork

This is a fork of lancachenet/monolithic with changes to better support Kubernetes and different platforms:

* The built-in supervisor is removed; this prevents the need to run as root from the start, and allows Kubernetes to
  monitor the health of the Nginx process instead of the supervisor process
* The image is built using `nginx-unprivileged` as the base image; this allows containers to be run as a non-root user
  from creation, and allows for building the image using different platforms
* The image parameterizes the UID and GID of the user; this allows for situations where a volume's files must use
  specific ids, such as 977:988 for UniFi's NAS NFS share

By default, two images are provided:
* `ghcr.io/hjwylde/lancache-monolithic:latest`; the default image
* `ghcr.io/hjwylde/lancache-monolithic-unifi:latest`; a customized image, where the user has ids 977:988

Both images are built with support for the following platforms:
* linux/386
* linux/amd64
* linux/arm/v7
* linux/arm64
* linux/ppc64le
* linux/riscv64
* linux/s390x

Please note, due to the above changes, there are some differences from the original lancachenet/monolithic:
* Due to the fact that the image runs as a non-root user, it is impossible to fix permission errors automatically. Any 
  permission errors encountered must be resolved using alternative means.
* Due to the fact that the image runs as a non-root user, the nginx process binds to ports 8080 and 8443 instead of 80 
  and 443. Additionally, the metrics port was updated from 8080 to 8081.
* Due to the fact that the built-in supervisor is removed, there is no automatic health-check. An explicit healthcheck
  must be provided using the `:8080/lancache-heartbeat` endpoint.

## Documentation

The documentation for the LanCache.net project can be found on [our website](http://www.lancache.net)

The specific documentation for this monolithic container is [here](http://lancache.net/docs/containers/monolithic/)

If you have any problems after reading the documentation please see [the support page](http://lancache.net/support/) before opening a new issue on github.

## Thanks

- Based on original configs from [ansible-lanparty](https://github.com/ti-mo/ansible-lanparty).
- Everyone on [/r/lanparty](https://reddit.com/r/lanparty) who has provided feedback and helped people with this.
- UK LAN Techs for all the support.

## License

The MIT License (MIT)

Copyright (c) 2019 Jessica Smith, Robin Lewis, Brian Wojtczak, Jason Rivers, James Kinsman

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
