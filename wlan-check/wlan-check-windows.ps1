# WLAN-Check (nur lesend, ändert nichts, liest keine Passwörter aus)
# Ausführen: PowerShell öffnen -> powershell -ExecutionPolicy Bypass -File .\wlan-check-windows.ps1
$out = "$env:USERPROFILE\Desktop\wlan-check.txt"
& {
  "=== Verbundenes WLAN (Standard, Verschlüsselung, Kanal, Signal) ==="; netsh wlan show interfaces
  "=== Nachbarnetze / Kanalbelegung ==="; netsh wlan show networks mode=bssid
  "=== Treiber / unterstützte Standards (WPA3, Wi-Fi 6) ==="; netsh wlan show drivers
  "=== IP-Konfiguration, Router, DNS ==="; ipconfig /all
  "=== Geräte im Netz (ARP) ==="; arp -a
  "=== Router-Ports (Schnelltest) ===";
  $gw = (Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Sort-Object RouteMetric | Select-Object -First 1).NextHop
  foreach ($p in 21,22,23,53,80,443,1900,5000,7547,8080,8443,49000) {
    $r = Test-NetConnection -ComputerName $gw -Port $p -WarningAction SilentlyContinue
    "{0}:{1} offen={2}" -f $gw,$p,$r.TcpTestSucceeded
  }
  "=== UPnP-Dienste auf diesem PC ==="; Get-Service SSDPSRV,upnphost -ErrorAction SilentlyContinue | Format-Table Name,Status
} *> $out
Write-Host "Fertig: $out  -> Inhalt an Claude schicken (vorher ggf. Netzname/MAC-Adressen schwärzen)."
