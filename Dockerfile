# Dockerfile for minun
# https://github.com/fzaninotto/uptime
#
# VERSION 0.1.0

FROM ubuntu
MAINTAINER Eugene Kalinin <e.v.kalinin@gmail.com>

# refresh
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# munin
RUN apt-get install -y munin
ADD conf/munin.conf /etc/munin/munin.conf

# nginx
RUN apt-get install -y nginx
RUN rm /etc/nginx/sites-enabled/default
ADD conf/munin.nginx.conf /etc/nginx/sites-enabled/munin.conf
RUN service nginx restart

# supervisord
RUN mkdir -p /var/log/supervisor
RUN apt-get install -y supervisor

# ssh
RUN mkdir -p /var/run/sshd
RUN apt-get install -y openssh-server
RUN /bin/sh -c 'echo root:munin | chpasswd'

# config for auto start ssh/mongod
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# ports
EXPOSE 22 80

# start all
CMD ["/usr/bin/supervisord", "-n"]
