Write-Host "=== Instalando servicio DNS ==="
Install-WindowsFeature -Name DNS -IncludeManagementTools

Write-Host "=== Verificando instalación ==="
Get-WindowsFeature -Name DNS

# Definir dominio e IP fija
$dominio = "reprobados.com"
$ip = "192.168.0.50"   # <-- aquí pones la IP de la VM Ubuntu o cliente

Write-Host "=== Creando zona primaria para $dominio ==="
Add-DnsServerPrimaryZone -Name $dominio -ZoneFile "$dominio.dns" -DynamicUpdate NonsecureAndSecure

Write-Host "=== Creando registros A para $dominio y www.$dominio ==="
Add-DnsServerResourceRecordA -Name "@" -ZoneName $dominio -IPv4Address $ip
Add-DnsServerResourceRecordA -Name "www" -ZoneName $dominio -IPv4Address $ip

Write-Host "=== Reiniciando servicio DNS ==="
Restart-Service -Name DNS
Write-Host "DNS configurado correctamente."
