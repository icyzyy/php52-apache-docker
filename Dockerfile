FROM ubuntu:14.04

COPY ./karmic.list /etc/apt/sources.list.d/
COPY ./php_52 /etc/apt/preferences.d/

RUN apt-get update && \
    apt-get -y install apache2 libapache2-mod-php5 php-pear php5-curl \
    php5-dbg php5-mhash php5-mysql php5-tidy php5-xmlrpc \
    php5-xsl php5-mssql php5-gd php5-gmp php5-imap php5-ldap \
    php5-odbc php5-pgsql php5-sqlite php5-mcrypt php5-pspell \
    php5-recode

RUN apt-get download php5-snmp && \
	dpkg -i --ignore-depends=libsnmp15 php5-snmp_5.2.10.dfsg.1-2ubuntu6_amd64.deb && \
	rm php5-snmp_5.2.10.dfsg.1-2ubuntu6_amd64.deb

RUN rm /etc/apt/sources.list.d/karmic.list && \
    rm /etc/apt/preferences.d/php_52

RUN a2enmod rewrite

RUN echo "<?php phpinfo();" > /var/www/index.php && \
    rm /var/www/index.html

CMD /etc/init.d/apache2 start && tail -f /var/log/apache2/access.log
