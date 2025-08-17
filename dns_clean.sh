#!/bin/bash
dominio="reprobados.com"
rm -f /etc/bind/zones/db.$dominio
sed -i "/zone \"$dominio\" {/,/};/d" /etc/bind/named.conf.local
systemctl restart bind9
echo "Zona DNS $dominio eliminada."
