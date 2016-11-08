# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>
#
# Enriched by patterns found at https://github.com/openshift/postgresql/blob/master/9.4/Dockerfile.rhel7 by
#   Christoph Görn <goern@redhat.com>

FROM centos:v1
MAINTAINER The CentOS Project <cloud-ops@centos.org>

# Labels consumed by Red Hat build service
LABEL Component="nginx" \
      Name="centos/nginx-180-centos7" \
      Version="1.8.0" \
      Release="1"

# Labels could be consumed by OpenShift
LABEL io.k8s.description="nginx [engine x] is an HTTP and reverse proxy server, a mail proxy server, and a generic TCP/UDP proxy server, originally written by Igor Sysoev." \
      io.k8s.display-name="nginx 1.8.0" \
      io.openshift.expose-services="80:http" \
      io.openshift.tags="nginx"
ENV     TZ=Asia/Shanghai
RUN     ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

RUN yum -y install epel-release && \
    yum -y install nginx && \
    yum clean all 

# Get prefix path and path to scripts rather than hard-code them in scripts

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.

ADD nginx.conf /etc/nginx/nginx.conf

# ADD https://git.centos.org/sources/httpd/c7/acf5cccf4afaecf3afeb18c50ae59fd5c6504910 /usr/share/nginx/html/
# RUN sed -i -e 's/Apache/nginx/g' -e '/apache_pb.gif/d' /usr/share/nginx/html/index.html

EXPOSE 80 81 82 83

#USER 997

ENTRYPOINT ["/usr/sbin/nginx"]
