FROM debian:buster
MAINTAINER Matt Bentley <mbentley@mbentley.net>

# install packages per https://github.com/UniversalMediaServer/UniversalMediaServer/wiki/Linux-install-instructions
RUN (dpkg --add-architecture i386 &&\
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y dcraw flac libfreetype6:i386 libstdc++6:i386 libbz2-1.0:i386 lib32z1 lib32ncurses6 mediainfo mencoder mplayer procps vlc wget &&\
  rm -rf /var/lib/apt/lists/*)

ENV UMS_PROFILE /opt/ums/UMS.conf
ENV JAVA_OPTS="-XX:+UnlockExperimentalVMOptions"

# get latest release number and use that to install UMS; fail to install if version is not 9.x
RUN (UMSVER=$(wget -q -O - https://api.github.com/repos/UniversalMediaServer/UniversalMediaServer/releases/latest | python -c "import sys, json; print json.load(sys.stdin)['name']") &&\
  if [ "$(echo $UMSVER | awk -F '.' '{print $1}')" -ne "9" ]; then echo "Latest version number is no longer 9"; exit 1; fi &&\
  wget "https://github.com/UniversalMediaServer/UniversalMediaServer/releases/download/${UMSVER}/UMS-${UMSVER}.tgz" -O /opt/UMS-${UMSVER}.tgz &&\
  cd /opt &&\
  tar zxf UMS-${UMSVER}.tgz &&\
  rm UMS-${UMSVER}.tgz &&\
  mv ums-${UMSVER} ums &&\
  mkdir /opt/ums/database /opt/ums/data &&\
  groupadd -g 500 ums &&\
  useradd -u 500 -g 500 -d /opt/ums ums &&\
  chown -R ums:ums /opt/ums)

USER ums
WORKDIR /opt/ums
EXPOSE 1900/udp 2869 5001 9001
VOLUME ["/tmp","/opt/ums/database","/opt/ums/data"]
CMD ["/opt/ums/UMS.sh"]
