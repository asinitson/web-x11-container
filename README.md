# Web X11 container

Docker container base image for packaging graphical applications (X11).
Graphical environment is accessible through web browser.

## How to use

### 1. Open project directory in Bash

### 2. Build and start container

* Through Docker Compose

  ```bash
  # Docker Compose v1
  docker-compose up

  # Docker Compose v2
  docker compose up
  ```

* ...or directly through Docker CLI

  ```bash
  docker build --tag web-x11 .
  docker run \
    --interactive \
    --tty \
    --publish 8080:8080 \
    web-x11
  ```

### 3. Connect to the graphical environment

> NOTE: Fluxbox window manager might need some time to start on the first run.

Open [http://localhost:8080](http://localhost:8080) in a web browser.

### 4. Open terminal (Bash in `xterm`)

Right click on the middle of the screen and navigate the menu:
`Applications -> Shell -> Bash` as shown on a screenshot below.

![Open Bash in `xterm`](./docs/fluxbox-open_bash_in_xterm.png)

## How add another process to autostart

### 1. Add executable path to [./system/services/example_service.sh](./system/services/example_service.sh#L14)

> NOTE: If you add your own script, [make sure it is executable](https://askubuntu.com/a/229592/982082).

### 2. Rebuild and restart container with docker-compose

```bash
# Docker Compose v1
docker-compose up --build --force-recreate --renew-anon-volumes

# Docker Compose v2
docker compose up --build --force-recreate --renew-anon-volumes
```

## Motivation

There are several base images with a similar setup.
This base image has a few improvements:

* Up-to-date [noVNC](https://novnc.com) version which plays well with both
  Firefox and Chrome/Chromium.

* [wait_for_x11_init.sh](./system/services/wait_for_x11_init.sh) is used for
  starting processes which need X11 (Xvfb) initialized. This way we
  exclude [race conditions](https://en.wikipedia.org/wiki/Race_condition#In_software).

* Proper process management with [supervisord](http://supervisord.org/) with
  ability to filter logs by process, start, stop, auto-restart processes without
  restarting the container. This comes handy when you add an application
  to the base image.

* Ubuntu 20.04.* LTS is taken as a base image for better integration with other
  applications (some applications are not trivial to install on Alpine Linux).

## Inspiration: similar container images

* https://github.com/soffchen/tiny-remote-desktop
* https://github.com/hdavid0510/docker-novnc/
* https://wiki.xnat.org/display/CS/Container+Desktop+Access+via+noVNC
