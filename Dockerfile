FROM ioft/armhf-ubuntu:15.10

MAINTAINER Timo Schmid

ENV DEBIAN_FRONTEND "noninteractive"

VOLUME ["/etc/backuppc"]
VOLUME ["/var/lib/backuppc"]

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y python python-pip debconf-utils msmtp

RUN pip install supervisor

RUN echo "postfix postfix/main_mailer_type select Local only" | debconf-set-selections
RUN echo "backuppc backuppc/configuration-note note" | debconf-set-selections
RUN echo "backuppc backuppc/restart-webserver boolean true" | debconf-set-selections
RUN echo "backuppc backuppc/reconfigure-webserver multiselect apache2" | debconf-set-selections

RUN apt-get install -y backuppc apache2-utils

RUN apt-get install -y libsocket6-perl

COPY supervisord.conf /etc/supervisord.conf
COPY msmtprc /var/lib/backuppc/.msmtprc
COPY run.sh /run.sh
COPY 000-localhost.conf /etc/apache2/sites-available/000-localhost.conf

RUN rm -rf /etc/bakuppc/* /etc/apache2/conf-enabled/backuppc.conf

RUN a2dissite 000-default
RUN a2ensite  000-localhost

RUN chmod 0755 /run.sh

EXPOSE 80

CMD ["/run.sh"]
