#!/bin/sh

CONF_DIR="/etc/dropbear"
SSH_KEY_DSS="${CONF_DIR}/dropbear_dss_host_key"
SSH_KEY_RSA="${CONF_DIR}/dropbear_rsa_host_key"
SSH_KEY_ECDSA="${CONF_DIR}/dropbear_ecdsa_host_key"
# Check if conf dir exists
if [ ! -d ${CONF_DIR} ]; then
    mkdir -p ${CONF_DIR}
fi
chown root:root ${CONF_DIR}
chmod 755 ${CONF_DIR}

# Check if keys exists
if [ ! -f ${SSH_KEY_DSS} ]; then
    dropbearkey  -t dss -f ${SSH_KEY_DSS}
fi
chown root:root ${SSH_KEY_DSS}
chmod 600 ${SSH_KEY_DSS}

if [ ! -f ${SSH_KEY_RSA} ]; then
    dropbearkey  -t rsa -f ${SSH_KEY_RSA} -s 2048
fi
if [ ! -f ${SSH_KEY_ECDSA} ]; then
    dropbearkey  -t ecdsa -f ${SSH_KEY_ECDSA}
fi
chown root:root ${SSH_KEY_RSA}
chmod 600 ${SSH_KEY_RSA}
sed -i 's/PUBLIC_REGISTER_ENABLED = True//g' /home/taiga/taiga-back/settings/local.py
echo >> /home/taiga/taiga-back/settings/local.py
env|grep -e TAIGA_PUBLIC_REGISTER_ENABLED -e TAIGA_EMAIL|cut -d"_" -f2-|sed 's/=/ = /g' >> /home/taiga/taiga-back/settings/local.py
exec service postgresql start &
exec /etc/init.d/nginx start &
exec service circusd start &
exec circusctl start taiga & 
exec /usr/sbin/dropbear -j -k -s -E -F

