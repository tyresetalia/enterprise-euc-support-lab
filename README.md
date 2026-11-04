# Enterprise EUC & IT Support Lab — End-User Computing & Smart Hands

![Windows](https://img.shields.io/badge/OS-Windows%2011%20Enterprise-blue?logo=windows)
![Support](https://img.shields.io/badge/Support-Smart%20Hands%20%26%20EUC-purple)
![Security](https://img.shields.io/badge/Security-UAC%20Least%20Privilege-red)
![Automation](https://img.shields.io/badge/Automation-PowerShell%20ITAM-green)
![ITSM](https://img.shields.io/badge/ITSM-ITIL%20Incident%20Tickets-orange)

Simulatie van een enterprise werkplek- en onsite supportomgeving in een industriële productiecontext voor **Talia Industries (Plant Westerlo)**: Windows 11 staging, scheiding van gebruikers- en beheerdersrechten (Least Privilege), netwerkdiagnostiek (Smart Hands), enterprise print queue herstel, geautomatiseerde IT Asset Management (ITAM) audits en gestructureerde incidentafhandeling met VIP-ondersteuning.

---

## 📌 Inhoudsopgave
1. [Projectoverzicht & Doelstelling](#-projectoverzicht--doelstelling)
2. [Architectuur & Omgevingsontwerp](#-architectuur--omgevingsontwerp)
3. [Componenten & Specificaties](#-componenten--specificaties)
4. [Beveiligingsmodel & Least Privilege](#-beveiligingsmodel--least-privilege)
5. [Stap-voor-stap Implementatie](#-stap-voor-stap-implementatie)
6. [Smart Hands Netwerkdiagnostiek (OSI-model)](#-smart-hands-netwerkdiagnostiek-osi-model)
7. [Systematische Troubleshooting & Incident Response](#-systematische-troubleshooting--incident-response)
8. [Documentatie & Bestanden](#-documentatie--bestanden)

---

## 🎯 Projectoverzicht & Doelstelling

Aantonen dat ik als **End-User Computing (EUC) Engineer / Onsite IT Support Specialist** zelfstandig een volledige bedrijfsomgeving kan beheren en troubleshooten:
* **Workplace Management:** Gecontroleerde uitrol van Windows 11 werkplekken, UAC-configuratie en strikte scheiding tussen standaardgebruikers en lokale administrators.
* **"Smart Hands" Onsite Support:** Fungeren als lokale handen en ogen voor centrale netwerk- en serverteams door gestructureerde OSI-troubleshooting uit te voeren (DHCP, DNS, Default Gateway, TCP/IP).
* **Enterprise Print Services:** Beheer van netwerkprinters, diagnosticeren van driver-/poortproblemen en het geautomatiseerd herstellen van vastgelopen Windows Print Spooler queues.
* **IT Asset Management (ITAM) & Lifecycle:** Hardware- en security-audits uitvoeren via herbruikbare PowerShell scripts (WMI/CIM) en naleving van data-sanitization standaarden bij uitdienstname.
* **ITSM / Incident Management:** Professionele ticketregistratie, communicatie naar eindgebruikers en "White-Glove Support" voor directie/VIP's conform enterprise SLA's.

---

## 🏗 Architectuur & Omgevingsontwerp

```
                         [ Global / Corporate Network ]
                                       │
                   ┌───────────────────┴───────────────────┐
                   │ (Central Network & Server Teams)      │
                   └───────────────────┬───────────────────┘
                                       │ (Smart Hands Interface)
┌──────────────────────────────────────┴────────────────────────────────────────┐
│  ONSITE PRODUCTIEOMGEVING (Talia Industries - Westerlo Site)                   │
│                                                                               │
│  [ Default Gateway: 10.0.2.2 ]                                                │
│         │                                                                     │
│         ├───> [ Werkstation: WKS-WEST-01 / DESKTOP-FUCGE37 (Windows 11) ]     │
│         │     • Accounts: Admin_Local (IT Support) | j.peeters (Standaard)    │
│         │     • IP: 10.0.2.15 (DHCP Verified)                                 │
│         │     • Security: UAC Enabled, Least Privilege beleid                 │
│         │                                                                     │
│         └───> [ Gesimuleerde Netwerkprinter: PRT-WEST-LOG01 ]                 │
│               • Poort: TCP/IP (LPR / RAW 9100)                                │
│               • Status: Spooler gecrasht / geautomatiseerd hersteld           │
│                                                                               │
│  [ IT Support Tooling & Automatisering ]                                      │
│  • PowerShell WMI/CIM Hardware Audit & Asset Scraping Script                  │
│  • Automated Print Spooler Flush & Service Recovery Script                    │
│  • Incident Ticket Dossier (SLA, Root Cause & VIP White-Glove Support)        │
└───────────────────────────────────────────────────────────────────────────────┘
```

---

## ⚙ Componenten & Specificaties

| Component | Identificatie / Naam | Specificaties / Rol | IP / Netwerk / Rechten |
| :--- | :--- | :--- | :--- |
| **Hypervisor** | Oracle VirtualBox | Host virtualisatie platform | NAT Networking |
| **Werkstation** | `WKS-WEST-01` (`DESKTOP-FUCGE37`) | Windows 11 Enterprise (Staging Build) | `10.0.2.15/24` |
| **Lokale Beheerder** | `Admin_Local` | Dedicated IT Support Administrator | Local Administrators Group |
| **Eindgebruiker** | `j.peeters` | Fabrieksoperator / Standaardprofiel | Standaard Gebruiker (No Admin) |
| **Netwerkprinter** | `PRT-WEST-LOG01` | Gesimuleerde label/rapportprinter | TCP/IP Poort 9100 |
| **ITAM Tooling** | `audit-asset.ps1` | PowerShell WMI/CIM Audit Script | Lokale hardware inspectie |
| **Spooler Recovery**| `fix-printspooler.bat` | Geautomatiseerde batch queue cleaner | Beheerdersrechten (`System32`) |

---

## 🛡 Beveiligingsmodel & Least Privilege

* **Strict Account Separation:** Het dagelijkse werkprofiel `j.peeters` heeft géén lidmaatschap van de lokale `Administrators`-groep.
* **UAC Hardening:** User Account Control (UAC) dwingt een expliciete beheerdersprompt af bij elke administratieve actie, waardoor malware en ongeautoriseerde tools geen persistente systeemaanpassingen kunnen maken.
* **Silent & Audited Packaging:** Bedrijfsapplicaties worden uitgerold met gecontroleerde command-line parameters (`winget` en silent `.msi`), met verificatie in het Windows register en de Event Viewer.

---

## 🚀 Stap-voor-stap Implementatie

1. **Werkplek Staging & Least Privilege Inrichting:** Opzetten van een Windows 11 werkstation (`WKS-WEST-01`) conform enterprise standaarden. Scheiding aangebracht tussen standaardgebruiker (`j.peeters`) en beheerder (`Admin_Local`).
2. **Onbeheerde Software Deployment:** Installatie en validatie van goedgekeurde enterprise tooling via silent command-line flags (`winget` en unattended `.msi`), inclusief verificatie in Windows Event Viewer.
3. **"Smart Hands" Netwerk Troubleshooting:** Gestructureerde OSI-laag analyse uitgevoerd via command-line tools om werkstation- en gatewayconnectiviteit te isoleren en te rapporteren aan het centrale netwerkteam.
4. **Enterprise Print Queue & Spooler Recovery:** Configuratie van een TCP/IP netwerkprinter (`PRT-WEST-LOG01`). Vastgelopen printopdracht nagebootst en geautomatiseerd hersteld via een CLI buffer opschoonscript.
5. **Geautomatiseerde IT Asset Management (ITAM) Audit:** Herbruikbaar PowerShell script (`audit-asset.ps1`) ontwikkeld om vitale hardware-, OS- en security-attributen uit te lezen via WMI/CIM.
6. **Incident Logging & VIP Scenario:** Registratie en documentatie van 4 realistische enterprise incident tickets in ITIL-formaat, inclusief White-Glove VIP-ondersteuning.

---

## 🔍 Smart Hands Netwerkdiagnostiek (OSI-model)

Bij netwerkstoringen is volgens het bottom-up OSI-model gehandeld:
1. **L1/L2 Fysiek & Datalink:** Netwerkadapter status en link lights gecontroleerd.
2. **L3 Netwerk:** `ipconfig /all` ter verificatie van DHCP-lease (`10.0.2.15`), `ping 127.0.0.1` (TCP/IP loopback test) en `ping 10.0.2.2` (Default Gateway connectiviteit).
3. **L4 Transport & WAN:** `ping 8.8.8.8` ter verificatie van routering naar het publieke internet.
4. **L7 Applicatie (DNS):** `nslookup google.com` ter validatie van DNS query resolutie.

---

## 🔧 Systematische Troubleshooting & Incident Response

* **Incident 1: Windows Package Manager Source Store Certificaatfout**
  * *Symptoom:* `winget install` gaf de foutmelding `0x8a15005e : The server certificate did not match any of the expected values`.
  * *Oorzaak:* Evaluatie-image miste actuele Microsoft Store certificaten.
  * *Oplossing:* Installatie geforceerd via de officiële community repo met de vlag `--source winget`.
* **Incident 2: Vastgelopen Print Spooler Buffer (Queue Lockdown)**
  * *Symptoom:* Printqueue van `PRT-WEST-LOG01` blokkeerde en de GUI weigerde opdrachten te annuleren.
  * *Oorzaak:* Corrupte `.SHD` en `.SPL` bestanden in `%systemroot%\System32\spool\PRINTERS` hielden een lock op de `spoolsv.exe` procesthread.
  * *Oplossing:* `Spooler` service gestopt via script, bufferbestanden geforceerd verwijderd en service herstart naar status `Running`.
* **Incident 3: Least Privilege Privilege Escalation Preventie**
  * *Symptoom:* Gebruiker `j.peeters` probeerde een administratieve terminal te openen.
  * *Oorzaak:* Strikte scheiding tussen `Users` en `Administrators` groepen.
  * *Oplossing:* UAC blokkeerde de actie correct en forceerde een expliciete beheerdersauthenticatie prompt (`Admin_Local`).

---

## 📁 Documentatie & Bestanden

* 📄 **Incident Management Dossier (ITIL Tickets):** [`documentatie/incident-management-tickets.md`](documentatie/incident-management-tickets.md)
* ⚙ **ITAM Audit Script:** [`scripts/audit-asset.ps1`](scripts/audit-asset.ps1)
* 🛠 **Spooler Recovery Tool:** [`scripts/fix-printspooler.bat`](scripts/fix-printspooler.bat)
* 📸 **Screenshots & Verificatie:** [`screenshots/`](screenshots/)
