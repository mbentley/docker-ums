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

## Example usage

```
docker run -d \
  --net=host \
  --restart=always \
  --name ums \
  -e FOLDER="/media" \
  -v /path/to/your/UMS.conf:/opt/ums/UMS.conf \
  -v /path/to/your/UMS.cred:/opt/ums/UMS.cred \
  -v /path/to/data:/opt/ums/data \
  -v /path/to/database:/opt/ums/database \
  -v /path/to/your/media:/media \
  mbentley/ums
```

The optional environment variable `FOLDER` will set the value of where `UMS.conf` looks for media files on a default `UMS.conf` with not value set.

Note: Volumes for `UMS.conf` and `database` are optional but the data in them will not persist otherwise.  If you need a `UMS.conf` file to start from, you can start a container and use `docker cp` to transfer the file to your host:

```
docker run -itd --name ums-temp mbentley/ums bash
docker cp ums-temp:/opt/ums/UMS.conf UMS.conf
docker stop ums-temp
docker rm ums-temp
```

Note: You will likely need to `chown` all persistent files and directories to `500:500`.

If you would rather not use `--net=host`, you can expose the ports for UMS:

* TCP - 5001, 9001
* UDP - 1900
