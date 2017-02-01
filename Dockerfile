FROM centos:centos7

MAINTAINER Ville Valtonen <ville.valtonen@digia.com>

RUN yum -y update \
    && yum -y install wget mod_ssl \
    && wget http://download.opensuse.org/repositories/security://shibboleth/CentOS_7/security:shibboleth.repo -P /etc/yum.repos.d \
    && yum -y install httpd shibboleth.x86_64 \
    && yum -y install shibboleth-embedded-ds \
    && yum -y clean all

COPY httpd-shibd-foreground /usr/local/bin/
COPY build-federation.sh /etc/shibboleth-ds/

RUN test -d /var/run/lock || mkdir -p /var/run/lock \
    && test -d /var/lock/subsys/ || mkdir -p /var/lock/subsys/ \
    && sed -i -r '/<\/?IfModule.*?>/d' /etc/httpd/conf.d/shibboleth-ds.conf \
    && chmod +x /etc/shibboleth/shibd-redhat \
    && chmod +x /etc/shibboleth-ds/build-federation.sh \
    && echo $'export LD_LIBRARY_PATH=/opt/shibboleth/lib64:$LD_LIBRARY_PATH\n'\
       > /etc/sysconfig/shibd \
    && chmod +x /etc/sysconfig/shibd \
    && chmod +x /usr/local/bin/httpd-shibd-foreground \
    && mkdir /etc/shib-volume/ \
    && mkdir /etc/shibboleth-ds/idp_metadata/ \
    && ln -s /etc/shibboleth/sp-key.pem /etc/shib-volume/sp-key.pem \
    && ln -s /etc/shibboleth/sp-cert.pem /etc/shib-volume/sp-cert.pem

EXPOSE 80 443

CMD ["httpd-shibd-foreground"]
