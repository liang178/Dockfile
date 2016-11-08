# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>

FROM centos:v1
MAINTAINER The CentOS Project <cloud-ops@centos.org>


#RUN yum -y update; yum clean all
#RUN yum -y install epel-release; yum clean all
ENV     TZ=Asia/Shanghai
RUN     ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

COPY rpms /tmp 
RUN cd /tmp && rpm -ivh *.rpm
RUN rm -rf /tmp/*
COPY fix-permissions.sh ./
RUN ./fix-permissions.sh /var/lib/mysql/   && \
    ./fix-permissions.sh /var/run/
COPY docker-entrypoint.sh /
#RUN mysql_install_db
#RUN chown -R mysql:mysql /var/lib/mysql
#COPY my.cnf /etc/my.cnf
#RUN yum -y install yum-utils; yum clean all
#RUN yum-config-manager --disable mysql57-community
#RUN yum-config-manager --enable mysql56-community
#RUN yum -y install mysql-community-server mysql; yum clean all
#COPY my.cnf /etc/my.cnf
VOLUME ["/var/lib/mysql"]

USER 27

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["mysqld_safe"]
