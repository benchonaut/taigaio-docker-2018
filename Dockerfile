FROM phusion/baseimage
MAINTAINER Benjamin Freitag <benjamin.freitag@kosmoskosmos.de>

#VOLUME ["/var/www"]

RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
RUN  apt-get -y --force-yes update && apt-get dist-upgrade -y --force-yes &&  apt-get install -y --force-yes build-essential binutils-doc autoconf flex bison libjpeg-dev libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev automake libtool libffi-dev curl git tmux gettext nginx rabbitmq-server redis-server circus sudo nano dropbear-run dropbear-bin wget curl rsync nano vim psmisc procps git postgresql
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/taiga --gecos "Taiga.io User" taiga && echo "taiga:taigapasswd" | chpasswd
RUN       apt-get clean &&  rm /var/lib/apt/lists/*_*
RUN echo "taiga ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN service postgresql start && su -c 'cd /home/taiga;pwd;mkdir .setup;git clone https://github.com/taigaio/taiga-scripts.git;cd taiga-scripts;bash setup-server.sh' taiga 

COPY taigaio-docker-2018/run-dropbear.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

CMD ["/usr/local/bin/run.sh"]
