# For Openshift

FROM centos:7

MAINTAINER telnetman

RUN yum -y update

RUN yum -y install telnet \
 mlocate \
 traceroute \
 tcpdump \
 wget \
 zip \
 unzip \
 gcc \
 epel-release \
 git \
 mariadb-server \
 httpd \
 mod_ssl \
 memcached


RUN yum -y install perl-CGI \
 perl-JSON \
 perl-Archive-Zip \
 perl-Test-Simple \
 perl-Digest-MD5 \
 perl-ExtUtils-MakeMaker \
 perl-libwww-perl \
 perl-LWP-Protocol-https \
 perl-Crypt-SSLeay \
 perl-Crypt-CBC \
 perl-Cache-Memcached \
 cpan


# CPAN
RUN echo q | /usr/bin/perl -MCPAN -e shell && \
    cpan -f URI::Escape::JavaScript && \
    cpan -f Crypt::Blowfish


# TimeZone
RUN \cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime


# Copy startup script
ADD ./install/start_openshift.sh /sbin/start.sh
RUN chmod 755 /sbin/start.sh


# MariaDB
RUN sed -i -e 's/\[mysqld\]/\[mysqld\]\ncharacter-set-server = utf8\nskip-character-set-client-handshake\nmax_connect_errors=999999999\n\n\[client\]\ndefault-character-set=utf8/' /etc/my.cnf.d/server.cnf && \
    mkdir /var/lib/mysql/TelnetmanWF && \
    chmod 700 /var/lib/mysql/TelnetmanWF && \
    chown mysql:mysql /var/lib/mysql/TelnetmanWF
ADD ./install/TelnetmanWF_Docker.sql /root/TelnetmanWF.sql


# Apache
RUN sed -i -e 's/Options Indexes FollowSymLinks/Options MultiViews FollowSymLinks/' /etc/httpd/conf/httpd.conf && \
    sed -i -e 's/Options None/Options ExecCGI/' /etc/httpd/conf/httpd.conf && \
    sed -i -e 's/#AddHandler cgi-script \.cgi/AddHandler cgi-script .cgi/' /etc/httpd/conf/httpd.conf && \
    sed -i -e 's/DirectoryIndex index\.html/DirectoryIndex index.html index.cgi/' /etc/httpd/conf/httpd.conf && \
    sed -i -e 's/80/8080/g' /etc/httpd/conf/httpd.conf && \
    sed -i -e '/ErrorDocument 403/s/^/#/' /etc/httpd/conf.d/welcome.conf && \
    sed -i -e 's/<Directory "\/var\/www\/html">/<Directory "\/var\/www\/html">\n    RewriteEngine on\n    RewriteBase \/\n    RewriteRule ^$ TelnetmanWF\/index.html [L]\n    RewriteCond %{REQUEST_FILENAME} !-f\n    RewriteCond %{REQUEST_FILENAME} !-d\n    RewriteRule ^(.+)$ TelnetmanWF\/$1 [L]\n/' /etc/httpd/conf/httpd.conf


# SSL
RUN sed -i -e "\$a[SAN]\nsubjectAltName='DNS:telnetman" /etc/pki/tls/openssl.cnf && \
    openssl req \
     -newkey rsa:2048 \
     -days 3650 \
     -nodes \
     -x509 \
     -subj "/C=JP/ST=/L=/O=/OU=/CN=telnetman" \
     -extensions SAN \
     -reqexts SAN \
     -config /etc/pki/tls/openssl.cnf \
     -keyout /etc/pki/tls/private/server.key \
     -out /etc/pki/tls/certs/server.crt && \
    chmod 644 /etc/pki/tls/private/server.key && \
    chmod 644 /etc/pki/tls/certs/server.crt && \
    sed -i -e 's/localhost\.key/server.key/' /etc/httpd/conf.d/ssl.conf && \
    sed -i -e 's/localhost\.crt/server.crt/' /etc/httpd/conf.d/ssl.conf && \
    sed -i -e 's/443/8443/g' /etc/httpd/conf.d/ssl.conf


# Directories & Files
RUN mkdir /usr/local/TelnetmanWF && \
    mkdir /usr/local/TelnetmanWF/lib && \
    mkdir /usr/local/TelnetmanWF/pl && \
    mkdir /var/www/html/TelnetmanWF && \
    mkdir /var/www/html/TelnetmanWF/js && \
    mkdir /var/www/html/TelnetmanWF/css && \
    mkdir /var/www/html/TelnetmanWF/img && \
    mkdir /var/www/cgi-bin/TelnetmanWF && \
    mkdir /var/TelnetmanWF && \
    mkdir /var/TelnetmanWF/data && \
    mkdir /var/TelnetmanWF/log && \
    mkdir /var/TelnetmanWF/tmp
ADD ./html/* /var/www/html/TelnetmanWF/
ADD ./js/*   /var/www/html/TelnetmanWF/js/
ADD ./css/*  /var/www/html/TelnetmanWF/css/
ADD ./img/*  /var/www/html/TelnetmanWF/img/
ADD ./cgi/*  /var/www/cgi-bin/TelnetmanWF/
ADD ./lib/*  /usr/local/TelnetmanWF/lib/
ADD ./pl/*   /usr/local/TelnetmanWF/pl/
RUN chmod 755 /var/www/cgi-bin/TelnetmanWF/* && \
    chown -R apache:apache /usr/local/TelnetmanWF && \
    chown -R apache:apache /var/www/html/TelnetmanWF && \
    chown -R apache:apache /var/www/cgi-bin/TelnetmanWF && \
    chown -R apache:apache /var/TelnetmanWF


# Update Source Code
RUN sed -i -e "s/'telnetman', 'tcpport23'/'root', ''/" /usr/local/TelnetmanWF/lib/Common_system.pm && \
    sed -i -e "s/192\.168\.203\.96/telnetman2/" /usr/local/TelnetmanWF/lib/Common_system.pm && \
    sed -i -e "s/:443/:8443/" /usr/local/TelnetmanWF/lib/TelnetmanWF_common.pm


# Logrotate 
ADD ./install/TelnetmanWF.logrotate.txt /etc/logrotate.d/TelnetmanWF


# permissions for root group
RUN chgrp -R 0   /run && \
    chmod -R g=u /run && \
    chgrp -R 0   /var/log/mariadb && \
    chmod -R g=u /var/log/mariadb && \
    chgrp -R 0   /var/log/httpd && \
    chmod -R g=u /var/log/httpd && \
    chgrp -R 0   /var/lib/mysql && \
    chmod -R g=u /var/lib/mysql && \
    chgrp -R 0   /var/TelnetmanWF && \
    chmod -R g=u /var/TelnetmanWF


EXPOSE 8443


CMD ["/sbin/start.sh"]
