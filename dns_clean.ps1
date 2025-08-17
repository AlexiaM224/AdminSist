$dominio = "reprobados.com"
Remove-DnsServerZone -Name $dominio -Force
Restart-Service -Name DNS
Write-Host "Zona DNS $dominio eliminada."
