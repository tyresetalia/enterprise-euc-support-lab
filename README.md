# Enterprise EUC & IT Support Lab — End-User Computing & Smart Hands

Simulatie van een enterprise werkplek- en onsite supportomgeving in een industriële/productiecontext voor **Talia Industries (Plant Westerlo)**: Windows 11 staging, scheiding van gebruikers- en beheerdersrechten (Least Privilege), netwerkdiagnostiek (Smart Hands), enterprise print queue herstel, geautomatiseerde IT Asset Management (ITAM) audits en gestructureerde incidentafhandeling met VIP-ondersteuning.

---

## Doel

Aantonen dat ik als **End-User Computing (EUC) Engineer / Onsite IT Support Specialist** zelfstandig een volledige bedrijfsomgeving kan beheren en troubleshooten:
1. **Workplace Management:** Gecontroleerde uitrol van Windows 11 werkplekken, UAC-configuratie en strikte scheiding tussen standaardgebruikers en lokale administrators.
2. **"Smart Hands" Onsite Support:** Fungeren als lokale handen en ogen voor centrale netwerk- en serverteams door gestructureerde OSI-troubleshooting uit te voeren (DHCP, DNS, Default Gateway, TCP/IP).
3. **Enterprise Print Services:** Beheer van netwerkprinters, diagnosticeren van driver-/poortproblemen en het geautomatiseerd herstellen van vastgelopen Windows Print Spooler queues.
4. **IT Asset Management (ITAM) & Lifecycle:** Hardware- en security-audits uitvoeren via herbruikbare PowerShell scripts (WMI/CIM) en naleving van data-sanitization standaarden bij uitdienstname.
5. **ITSM / Incident Management:** Professionele ticketregistratie, communicatie naar eindgebruikers en "White-Glove Support" voor directie/VIP's conform enterprise SLA's.

---

## Architectuur & Omgevingsontwerp

```
                         [ Global / Corporate Network ]
                                       |
                   +-------------------+-------------------+
                   | (Central Network & Server Teams)      |
                   +-------------------+-------------------+
                                       | (Smart Hands Interface)
+-------------------------------------------------------------------------------+
|  ONSITE PRODUCTIEOMGEVING (Talia Industries - Westerlo Site)                   |
|                                                                               |
|  [ Switch / Gateway: 10.0.2.2 ]                                               |
|         |                                                                     |
|         +---> [ Werkstation: WKS-WEST-01 / DESKTOP-FUCGE37 (Windows 11) ]     |
|         |     - Accounts: Admin_Local (IT Support) | j.peeters (Standaard)    |
|         |     - IP: 10.0.2.15 (DHCP Verified)                                 |
|         |     - Security: UAC Enabled, Least Privilege beleid                 |
|         |                                                                     |
|         +---> [ Gesimuleerde Netwerkprinter: PRT-WEST-LOG01 ]                 |
|               - Poort: TCP/IP (LPR / RAW 9100)                                |
|               - Queue: Spooler gecrasht / automatisch hersteld               |
|                                                                               |
|  [ IT Support Tooling & Automatisering ]                                      |
|  - PowerShell WMI/CIM Hardware Audit & Asset Scraping Script                  |
|  - Automated Print Spooler Flush & Service Recovery Script                    |
|  - Incident Ticket Dossier (SLA, Root Cause & VIP White-Glove Support)        |
+-------------------------------------------------------------------------------+
```

### Componenten & Omgevingsspecificaties

| Component | Identificatie / Naam | Specificaties / Rol | IP / Netwerk / Rechten |
|---|---|---|---|
| **Hypervisor** | Oracle VirtualBox | Host virtualisatie platform | NAT Networking |
| **Werkstation** | `WKS-WEST-01` (`DESKTOP-FUCGE37`) | Windows 11 Enterprise (Staging Build) | 10.0.2.15 / 24 |
| **Lokale Beheerder** | `Admin_Local` | Dedicated IT Support Administrator | Local Administrators Group |
| **Eindgebruiker** | `j.peeters` | Fabrieksoperator / Standaardprofiel | Standaard Gebruiker (No Admin) |
| **Netwerkprinter** | `PRT-WEST-LOG01` | Gesimuleerde label/rapportprinter | TCP/IP Poort 9100 |
| **ITAM Tooling** | `audit-asset.ps1` | PowerShell WMI/CIM Audit Script | Lokale hardware inspectie |
| **Spooler Recovery**| `fix-printspooler.bat` | Geautomatiseerde batch/CLI queue cleaner| Beheerdersrechten (System32) |

---

## Wat is gedaan

1. **Werkplek Staging & Least Privilege Inrichting** — Opzetten van een Windows 11 werkstation (`WKS-WEST-01`) conform enterprise standaarden. Scheiding aangebracht tussen de dagelijkse standaardgebruiker (`j.peeters`) en een lokaal IT Support beheerdersaccount (`Admin_Local`). User Account Control (UAC) geverifieerd om ongeautoriseerde software-installaties en privilege escalation te blokkeren.
2. **Onbeheerde Software Deployment** — Installatie en validatie van goedgekeurde enterprise tooling via silent command-line flags (`winget` en unattended `.msi`), inclusief verificatie van installatielogs in Windows Event Viewer en register.
3. **"Smart Hands" Netwerk Troubleshooting** — Gestructureerde OSI-laag analyse uitgevoerd via command-line tools (`ipconfig /all`, `ping 127.0.0.1`, `ping 8.8.8.8`, `nslookup google.com`) om werkstation- en gatewayconnectiviteit te isoleren en te rapporteren aan het centrale netwerkteam.
4. **Enterprise Print Queue & Spooler Recovery** — Configuratie van een TCP/IP netwerkprinter (`PRT-WEST-LOG01`). Een vastgelopen printopdracht en print spooler crash nagebootst, gevolgd door een geautomatiseerde herstelprocedure via PowerShell/Batch om corrupte printbuffers in `%systemroot%\System32\spool\PRINTERS` op te schonen.
5. **Geautomatiseerde IT Asset Management (ITAM) Audit** — Een herbruikbaar PowerShell script (`audit-asset.ps1`) ontwikkeld om direct vitale hardware-, OS- en security-attributen (o.a. CPU, RAM, BIOS serienummer, computer model) uit te lezen via WMI/CIM objecten.
6. **Incident Logging & "White-Glove" VIP Scenario** — Registratie en documentatie van 4 realistische enterprise incident tickets in ITIL-formaat (`documentatie/incident-management-tickets.md`), variërend van productieverstorende printproblemen tot directe white-glove VIP-ondersteuning voor een directielid.

---

## Screenshots & Bewijsvoering

Alle bewijsvoering is gestructureerd opgeslagen in de map `screenshots/`:

* `01-workstation-staging-accounts.png` — Inrichting van `Admin_Local` en `j.peeters` in Local Users and Groups (`lusrmgr.msc`).
* `01b-admin-group-membership.png` — Lidmaatschap van `Admin_Local` in de lokale `Administrators` groep.
* `01c-windows-logon-users.png` — Windows inlogscherm met de beschikbare gebruikersprofielen.
* `02-uac-least-privilege-enforcement.png` — UAC-prompt bij een poging van de standaardgebruiker om beheerderssoftware te draaien.
* `03-silent-software-deployment.png` — Succesvolle unattended installatie van bedrijfssoftware via `winget` CLI.
* `03b-software-registry-verification.png` — Verificatie van geïnstalleerde pakketten in het Windows register via PowerShell.
* `04a-ipconfig-all.png` — Volledige IP-, subnet-, gateway- en DNS-configuratie via `ipconfig /all`.
* `04b-loopback-ping.png` — Verificatie van de lokale TCP/IP-stack via `ping 127.0.0.1`.
* `04c-gateway-internet-ping.png` — Externe netwerkconnectiviteitstest via `ping 8.8.8.8`.
* `04d-nslookup-dns-query.png` — DNS-naamomzetting verificatie via `nslookup google.com`.
* `05-print-spooler-stuck-queue.png` — Gesimuleerde vastgelopen/gestopte Print Spooler service (`Stop-Service Spooler`).
* `06-print-spooler-recovery-script.png` — Geautomatiseerd opschonen van corrupte printbuffers en herstart naar status `Running`.
* `07-powershell-itam-audit-output.png` — Hardware, BIOS en OS inventarisatie via geautomatiseerde PowerShell CIM-queries.

---

## Opgeloste Incidenten & Troubleshooting Scenarios

- **Incident 1: Windows Package Manager Source Store Certificaatfout**
  - *Symptoom*: Bij uitvoeren van `winget install --id 7zip.7zip` gaf de Microsoft Store bron de fout `0x8a15005e : The server certificate did not match any of the expected values`.
  - *Oorzaak*: De evaluatie-image miste up-to-date Store-certificaten of synchronisatie met de cloud store.
  - *Oplossing*: De specifieke vlag `--source winget` meegegeven aan het commando om de installatie direct via de officiële Winget Community repository te voltooien.
- **Incident 2: Vastgelopen Print Spooler Buffer (Queue Lockdown)**
  - *Symptoom*: Netwerkprintqueue van `PRT-WEST-LOG01` blokkeerde, service kon geen nieuwe opdrachten aannemen en GUI reageerde niet op "Annuleren".
  - *Oorzaak*: Corrupte `.SHD` en `.SPL` bufferbestanden in `%systemroot%\System32\spool\PRINTERS` hielden een lock op de `spoolsv.exe` procesthread.
  - *Oplossing*: Service `Spooler` gestopt, bufferbestanden geforceerd verwijderd via CLI script en de service herstart naar status `Running`.
- **Incident 3: Least Privilege Privilege Escalation Preventie**
  - *Symptoom*: Gebruiker `j.peeters` probeerde een administratieve terminal te openen.
  - *Oorzaak*: Strikte scheiding tussen `Users` en `Administrators` groepen.
  - *Oplossing*: UAC blokkeerde de actie correct en forceerde een expliciete beheerdersauthenticatie prompt (`Admin_Local`).

---

## Wat is geleerd / Skills aangetoond

- **Workplace & Endpoint Management:** Windows 11 staging, scheiding van gebruikersprofielen, Local Users and Groups (`lusrmgr.msc`), UAC hardening volgens het Least Privilege principe.
- **Software Lifecycle & Packaging:** Silent software deployments (`winget`, unattended parameters), register-validatie van geïnstalleerde pakketten.
- **Smart Hands & Netwerkdiagnostiek:** Gestructureerde OSI-troubleshooting (L1 t/m L7) met `ipconfig /all`, loopback pings (`127.0.0.1`), gateway checks (`8.8.8.8`) en DNS-queries (`nslookup`).
- **Printer & Peripheral Management:** TCP/IP netwerkprintqueues configureren, Windows Print Spooler crashes diagnosticeren en geautomatiseerd herstellen via command-line scripts.
- **IT Asset Management (ITAM):** Hardware-, BIOS- en OS-inventarisatie automatiseren met PowerShell en WMI/CIM objecten.
- **ITSM & Incident Documentatie:** ITIL-conforme registratie van incidenten (P1 t/m P4), root-cause analyses en White-Glove VIP-ondersteuningsprotocollen.

---

## Documentatie & Bestanden

- 📄 **Incident Management Dossier:** [`documentatie/incident-management-tickets.md`](file:///c:/Users/talia/Desktop/PersonalGit/enterprise-euc-support-lab/documentatie/incident-management-tickets.md)
- ⚙️ **ITAM Audit Script:** [`scripts/audit-asset.ps1`](file:///c:/Users/talia/Desktop/PersonalGit/enterprise-euc-support-lab/scripts/audit-asset.ps1)
- 🛠️ **Spooler Recovery Tool:** [`scripts/fix-printspooler.bat`](file:///c:/Users/talia/Desktop/PersonalGit/enterprise-euc-support-lab/scripts/fix-printspooler.bat)
- 📸 **Screenshots:** [`screenshots/`](file:///c:/Users/talia/Desktop/PersonalGit/enterprise-euc-support-lab/screenshots)
