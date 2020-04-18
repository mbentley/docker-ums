# mbentley/ums

docker image for Universal Media Server (UMS)
based off of debian:stretch

To pull this image:
`docker pull mbentley/ums`

## Tags

* `latest`, `9` - UMS 9.x (debian:buster based)
* `8` - UMS 8.x (debian:stretch based)
* `7` - UMS 7.x (debian:stretch based)
* `6` - UMS 6.x (debian:stretch based)
* `5` - UMS 5.x (debian:stretch based)

## Permission Prerequesites

By default, UMS will run as a non-root user.  Due to this, your media directory that you bind mount into the container must have `other` permissions set to `rx`:

```
chown -R o+rx /path/to/my/media
```

## Example usage

Default `UMS.conf` with a media folder specified:

```
docker run -d \
  --net=host \
  --restart=always \
  --name ums \
  -e FOLDER="/media" \
  -e FORCE_CHOWN="false" \
  -e SET_MEDIA_PERMISSIONS="false" \
  -v ums-data:/opt/ums/data \
  -v ums-database:/opt/ums/database \
  -v /path/to/your/media:/media \
  mbentley/ums
```

Custom `UMS.conf` and persistent `UMS.cred` file, `data` and `database` directories:

```
docker run -d \
  --net=host \
  --restart=always \
  --name ums \
  -e FOLDER="" \
  -e FORCE_CHOWN="false" \
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
* `SET_MEDIA_PERMISSIONS` - (default: `false`) When set to `true` & `FOLDER` passed, performs a `chmod` on the `FOLDER` directory so that it is world read/execute to be able to read the media files and traverse directories

Note: Volumes for `UMS.conf`, `data` `database` are optional but the data in them will not persist otherwise.  If you need a `UMS.conf` file to start from, you can start a container and use `docker cp` to transfer the file to your host:

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
