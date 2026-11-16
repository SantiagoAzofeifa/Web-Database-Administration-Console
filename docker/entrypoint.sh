#!/bin/sh
# Genera ~/dba_config/dba.conf a partir de las variables de docker-compose.yml.
# La contraseña de la consola se guarda solo como hash (password_hash), igual que en producción.
set -eu

CONF=/home/demo/dba_config/dba.conf
HASH=$(php -r 'echo password_hash(getenv("ADMIN_PASSWORD"), PASSWORD_DEFAULT);')

cat > "$CONF" <<EOF
DB_MOTOR='MariaDB'
DB_HOST='${DB_HOST}'
DB_PORT='${DB_PORT:-3306}'
DB_NAME='${DB_NAME}'
DB_USER='${DB_USER}'
DB_PASS='${DB_PASS}'
ADMIN_USER='${ADMIN_USER}'
ADMIN_HASH='${HASH}'
APP_VERSION='2.0'
APP_NOMBRE='Consola DBA'
EOF

chown demo:demo "$CONF"
chmod 600 "$CONF"
touch /home/demo/dba_logs/respaldos.log
chown demo:demo /home/demo/dba_logs/respaldos.log
chmod 600 /home/demo/dba_logs/respaldos.log

exec "$@"
