# Demo local de la Consola DBA.
# Reproduce el entorno de una cuenta de hosting compartido (Virtualmin): la app vive en
# ~/public_html/consola, la configuración y los scripts fuera de la carpeta web, y
# Apache corre con el usuario de la cuenta, sin privilegios de administrador.
FROM php:8.2-apache

RUN apt-get update \
 && apt-get install -y --no-install-recommends mariadb-client \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-install pdo_mysql \
 && printf '[client]\nskip-ssl\n' > /etc/mysql/conf.d/demo-sin-ssl.cnf \
 && useradd --create-home --shell /bin/bash demo

ENV APACHE_RUN_USER=demo \
    APACHE_RUN_GROUP=demo \
    APACHE_DOCUMENT_ROOT=/home/demo/public_html

RUN sed -ri 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
 && sed -ri 's!/var/www/!/home/demo/public_html/!g' /etc/apache2/apache2.conf \
 && printf 'RedirectMatch ^/$ /consola/login.php\n' > /etc/apache2/conf-enabled/demo-raiz.conf

COPY --chown=demo:demo *.php /home/demo/public_html/consola/
COPY --chown=demo:demo includes /home/demo/public_html/consola/includes
COPY --chown=demo:demo css /home/demo/public_html/consola/css
COPY --chown=demo:demo js /home/demo/public_html/consola/js
COPY --chown=demo:demo img /home/demo/public_html/consola/img
COPY --chown=demo:demo grupo3_novacloud/scripts/backup.sh /home/demo/dba_scripts/backup.sh
COPY docker/entrypoint.sh /usr/local/bin/consola-entrypoint

RUN chmod 755 /usr/local/bin/consola-entrypoint \
 && chmod 700 /home/demo/dba_scripts/backup.sh \
 && install -d -o demo -g demo -m 700 /home/demo/dba_config /home/demo/dba_logs /home/demo/respaldos /home/demo/dba_planes

ENTRYPOINT ["consola-entrypoint"]
CMD ["apache2-foreground"]
