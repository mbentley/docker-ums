FROM debian:jessie
MAINTAINER Matt Bentley <mbentley@mbentley.net>

ENV UMSVER 5.1.3
RUN (echo 'deb http://www.deb-multimedia.org jessie main non-free' >> /etc/apt/sources.list &&\
  dpkg --add-architecture i386 &&\
  apt-get update &&\
  apt-get install -y --force-yes deb-multimedia-keyring &&\
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y dcraw mediainfo mencoder mplayer openjdk-7-jre vlc wget libfreetype6:i386 libstdc++6:i386)

RUN (wget "http://sourceforge.net/projects/unimediaserver/files/Official%20Releases/Linux/UMS-${UMSVER}-Java7.tgz/download" -O /opt/UMS-${UMSVER}-Java7.tgz &&\
  cd /opt &&\
  tar zxf UMS-${UMSVER}-Java7.tgz &&\
  rm UMS-${UMSVER}-Java7.tgz &&\
  mv ums-${UMSVER} ums)

ADD UMS.conf /opt/ums/UMS.conf
ADD WEB.conf /opt/ums/WEB.conf
ENV UMS_PROFILE /opt/ums/UMS.conf
RUN (useradd -d /opt/ums ums && chown -R ums:ums /opt/ums)

USER ums
WORKDIR /opt/ums
EXPOSE 5001 9001
CMD ["/opt/ums/UMS.sh"]
