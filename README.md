mbentley/ums
============

docker image for Universal Media Server (UMS)
based off of debian:jessie

To pull this image:
`docker pull mbentley/ums`

Example usage:
`docker run -d --net="host" --restart=always -v /path/to/your/UMS.conf:/opt/ums/UMS.conf -v /path/to/database:/opt/ums/database -v /path/to/your/media:/media --name ums mbentley/ums`

Note: Volumes for `UMS.conf` and `database` are optional but the data in them will not persist otherwise.
