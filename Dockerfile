FROM base
MAINTAINER Henrik Mühe <henrik.muehe@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

# Fake a fuse install
RUN apt-get install libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

# Fake upstart
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Install basex
RUN apt-get -y install basex

# Install node
RUN apt-get -y install software-properties-common python-software-properties python g++ make
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y install nodejs

# Install src and modules
ADD . /src
RUN cd /src ; npm install
RUN cd /src ; ./node_modules/jamjs/bin/jam.js install
RUN cd /src ; make

# Run
EXPOSE 8080
CMD ["/src/startup.sh"]
