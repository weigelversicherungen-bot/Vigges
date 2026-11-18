#!/bin/bash
# WLAN-Check (nur lesend, ändert nichts, liest keine Passwörter aus)
# Ausführen: bash wlan-check-mac.sh
out="$HOME/Desktop/wlan-check.txt"
{
  echo "=== WLAN (Standard, Sicherheit, Kanal, Signal, Nachbarnetze) ==="; system_profiler SPAirPortDataType
  echo "=== Router / Routen ==="; netstat -rn -f inet | head -20
  echo "=== DNS ==="; scutil --dns | grep nameserver | sort -u
  echo "=== Geräte im Netz (ARP) ==="; arp -a
  gw=$(route -n get default 2>/dev/null | awk '/gateway/{print $2}')
  echo "=== Router-Ports (Schnelltest) $gw ==="
  for p in 21 22 23 53 80 443 1900 5000 7547 8080 8443 49000; do
    nc -z -G 2 "$gw" $p 2>/dev/null && echo "$p offen" || echo "$p zu"
  done
} > "$out" 2>&1
echo "Fertig: $out  -> Inhalt an Claude schicken (vorher ggf. Netzname/MAC-Adressen schwärzen)."
