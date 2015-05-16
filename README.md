mbentley/ums
==================

docker image for Universal Media Server (UMS)
based off of stackbrew/debian:wheezy

To pull this image:
`docker pull mbentley/ums`

Example usage:
`docker run -d --net="host" --restart=always -v /path/to/your/UMS.conf:/opt/ums/UMS.conf -v /path/to/your/media:/media --name ums mbentley/ums`
