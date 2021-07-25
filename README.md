# mbentley/ums

docker image for Universal Media Server (UMS)
based off of debian:buster or alpine:latest

To pull this image:
`docker pull mbentley/ums`

## Tags

| Tags | UMS Version | Dockerfile | Base Image | Arch |
| ---- | ----------- | ---------- | ---------- | ---- |
| `latest`<br>`10` | UMS 10.x | [Dockerfile](Dockerfile) | `debian:buster` | `amd64` |
| `10-alpine` | UMS 10.x | [Dockerfile.10-alpine](Dockerfile.10-alpine) | `alpine:latest` | `amd64` |
| `latest-arm64`<br>`latest-alpine`<br>`10-alpine-arm64` | UMS 10.x | [Dockerfile.10-alpine](Dockerfile.10-alpine) | `alpine:latest` | `arm64` |
| `9` | UMS 9.x | [Dockerfile.9](Dockerfile.9) | `debian:buster` | `amd64` |
| `9-alpine` | UMS 9.x | [Dockerfile.9-alpine](Dockerfile.9-alpine) | `alpine:latest` | `amd64` |
| `8` | UMS 8.x | [Dockerfile.8](Dockerfile.8) | `debian:stretch` | `amd64` |
| `7` | UMS 7.x | [Dockerfile.7](Dockerfile.7) | `debian:stretch` | `amd64` |
| `6` | UMS 6.x | [Dockerfile.6](Dockerfile.6) | `debian:stretch` | `amd64` |
| `5` | UMS 5.x | [Dockerfile.5](Dockerfile.5) | `debian:stretch` | `amd64` |

## Permission Prerequisites

By default, UMS will run as a non-root user.  Due to this, your media directory that you bind mount into the container must have `other` permissions set to `rx`:

```
chown -R o+rx /path/to/my/media
```

## Example usage

Default `UMS.conf` with a media folder specified:

```
docker run -d \
  --init \
  --net=host \
  --restart=always \
  --name ums \
  -e FOLDER="/media" \
  -e FORCE_CHOWN="false" \
  -e NETWORK_INTERFACE="" \
  -e LOG_LEVEL="" \
  -e PORT=5001 \
  -e SET_MEDIA_PERMISSIONS="false" \
  -v ums-data:/opt/ums/data \
  -v ums-database:/opt/ums/database \
  -v /path/to/your/media:/media \
  mbentley/ums
```

Custom `UMS.conf` and persistent `UMS.cred` file, `data` and `database` directories:

```
docker run -d \
  --init \
  --net=host \
  --restart=always \
  --name ums \
  -e FOLDER="" \
  -e FORCE_CHOWN="false" \
  -e NETWORK_INTERFACE="" \
  -e LOG_LEVEL="" \
  -e PORT=5001 \
  -e SET_MEDIA_PERMISSIONS="false" \
  -v /path/to/your/UMS.conf:/opt/ums/UMS.conf \
  -v /path/to/your/UMS.cred:/opt/ums/UMS.cred \
  -v /path/to/data:/opt/ums/data \
  -v /path/to/database:/opt/ums/database \
  -v /path/to/your/media:/media \
  mbentley/ums
```

## Environment Variables

* `FOLDER` - (default: _null_) Automatically set the path to the media folder for UMS in `UMS.conf`
* `FORCE_CHOWN` - (default: `false`) When set to `true`, forces ownership of the `/opt/ums/data` and `/opt/ums/database` directories so UMS can write to them
* `NETWORK_INTERFACE` - (default: _null_) UMS will autodetect the network interface; sometimes you want to specify which network interface to have UMS bind to
* `LOG_LEVEL` - (default: _null_) UMS defaults to `INFO`, can be `ALL`, `TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR` or `OFF`
* `PORT` - (default: _null_) Defaults to the UMS default which is currently 5001 if not set; changed the default port if set
* `SET_MEDIA_PERMISSIONS` - (default: `false`) When set to `true` & `FOLDER` passed, performs a `chmod` on the `FOLDER` directory so that it is world read/execute to be able to read the media files and traverse directories

## Persistent Data

**_Warning_**: Volumes for `UMS.conf`, `data` `database` are optional but the data in them will not persist otherwise.  If you need a `UMS.conf` file to start from, you can start a container and use `docker cp` to transfer the file to your host:

```
docker run -d --name ums-temp mbentley/ums bash
docker cp ums-temp:/opt/ums/UMS.conf UMS.conf
docker stop ums-temp
docker rm ums-temp
```

Note: You will likely need to `chown` all persistent files and directories to `500:500`.  The entrypoint script will attempt to do it for you if they're not set correctly.

If you would rather not use `--net=host`, you can expose the ports for UMS but autodiscovery might not work:

* TCP - 2869, 5001, 9001
* UDP - 1900
