#!/bin/bash
set -e

echo "=== Actualizando paquetes ==="
apt-get update -y
apt-get install -y bind9 bind9utils

dominio="reprobados.com"
ip="192.168.1.108"   # <-- IP Lubuntu

echo "=== Creando carpeta de zonas ==="
mkdir -p /etc/bind/zones
chown bind:bind /etc/bind/zones

zona_file="/etc/bind/zones/db.$dominio"

echo "=== Creando archivo de zona ==="
cat > $zona_file << EOF
\$TTL    86400
@       IN      SOA     ns1.$dominio. admin.$dominio. (
                        $(date +%Y%m%d)01 ; Serial
                        28800   ; Refresh
                        7200    ; Retry
                        864000  ; Expire
                        86400 ) ; Minimum TTL
;
        IN      NS      ns1.$dominio.
ns1     IN      A       $ip
@       IN      A       $ip
www     IN      A       $ip
EOF

echo "zone \"$dominio\" {
    type master;
    file \"$zona_file\";
};" >> /etc/bind/named.conf.local

echo "=== Verificando configuración ==="
named-checkconf
named-checkzone $dominio $zona_file

echo "=== Reiniciando servicio DNS ==="
systemctl restart bind9
systemctl enable bind9
