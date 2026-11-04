# Lab 5 (EUC) — Enterprise End-User Computing & IT Support Lab

**Windows 11 Workplace Staging, Least Privilege (UAC), Smart Hands OSI-Troubleshooting, Enterprise Print Spooler Recovery, PowerShell ITAM & ITIL Incident Management**  
*Tyrese Talia | 2026*

---

## Inhoudsopgave
1. [Waarvoor dit lab is & Doel](#1-waarvoor-dit-lab-is--doel)
2. [Waarom ik gekozen heb om dit lab te bouwen](#2-waarom-ik-gekozen-heb-om-dit-lab-te-bouwen)
3. [Wat ik heb geleerd & Technische Vaardigheden](#3-wat-ik-heb-geleerd--technische-vaardigheden)
4. [Stapsgewijze Uitvoering (Fasering)](#4-stapsgewijze-uitvoering-fasering)
5. [Smart Hands Netwerkdiagnostiek (OSI-model)](#5-smart-hands-netwerkdiagnostiek-osi-model)
6. [Troubleshooting & Incident Response](#6-troubleshooting--incident-response)
7. [ITIL Incident Tickets & VIP Support Dossier](#7-itil-incident-tickets--vip-support-dossier)

---

## 1. Waarvoor dit lab is & Doel
Dit lab simuleert een enterprise werkplek- en onsite IT supportomgeving in een industriële productiecontext voor **Talia Industries (Plant Westerlo)**:
* **Workplace Management:** Gecontroleerde uitrol van Windows 11 werkplekken met strikte scheiding tussen standaardgebruikers (j.peeters) en lokale administrators (Admin_Local).
* **"Smart Hands" Onsite Support:** Fungeren als lokale handen en ogen voor centrale netwerk- en serverteams via gestructureerde OSI-troubleshooting (DHCP, DNS, Default Gateway, TCP/IP).
* **Enterprise Print Services:** Beheer van TCP/IP netwerkprinters, diagnosticeren van driverproblemen en het geautomatiseerd herstellen van gecrashte Windows Print Spooler queues.
* **IT Asset Management (ITAM):** Hardware-, BIOS- en security-audits automatiseren via herbruikbare PowerShell WMI/CIM-scripts.
* **ITSM & Incident Management:** Professionele ticketregistratie (P1 t/m P4), communicatie naar eindgebruikers en "White-Glove Support" voor directie/VIP's conform enterprise SLA's.

---

## 2. Waarom ik gekozen heb om dit lab te bouwen
Als aankomend IT Support Engineer / Junior Sysadmin wil ik aantonen dat ik zowel de technische diepgang van besturingssystemen begrijp als uitstekende servicegerichtheid bezit:
1. **Praktische werkplekervaring aantonen:** Bewijzen dat ik zelfstandig werkplekken kan installeren, beveiligen en troubleshooten.
2. **De brug slaan tussen lokaal en centraal:** Laten zien dat ik als "Smart Hands" effectief kan communiceren met centrale netwerk- en cloudteams.
3. **Automatisering integreren in supportwerk:** Routinetaken (zoals het leegmaken van vastgelopen spoolers of inventariseren van hardware) oplossen met PowerShell i.p.v. handmatige muisklikken.
4. **Professionele ITIL-communicatie demonstreren:** Heldere ticketverslaglegging met duidelijke root cause analyse en empathische communicatie naar eindgebruikers.

---

## 3. Wat ik heb geleerd & Technische Vaardigheden
* **Windows 11 Workplace Staging:** Scheiding van gebruikersprofielen, Local Users and Groups (lusrmgr.msc), UAC hardening volgens het Least Privilege principe.
* **Silent Software Deployment:** Unattended installaties via winget CLI en MSI-parameters, inclusief register- en Event Viewer validatie.
* **Smart Hands OSI-Analyse:** Systematische stappen doorlopen van Layer 1 tot Layer 7 (ipconfig /all, loopback pings, default gateway pings, DNS tests).
* **Print Spooler Recovery:** Begrip van de bestandsstructuur in %systemroot%\System32\spool\PRINTERS en het ontwikkelen van geautomatiseerde herstelscripts.
* **PowerShell WMI/CIM Auditing:** Gebruik van Get-CimInstance voor het uitlezen van CPU, BIOS-serienummers, disk info en geheugenbanken.
* **ITIL Incident Handling:** Prioritering van tickets, SLA-bewaking en VIP escalatieprotocollen.

---

## 4. Stapsgewijze Uitvoering (Fasering)

### Fase 1: Werkplek Staging & Least Privilege Inrichting
* Werkstation WKS-WEST-01 voorzien van Windows 11 Enterprise.
* Lokale beheerder Admin_Local en standaardgebruiker j.peeters geconfigureerd.
* UAC ingeschakeld om privilege escalation door gewone gebruikers direct te blokkeren.

### Fase 2: Unattended Software Deployment
* Command-line installatie uitgevoerd met winget install --id 7zip.7zip --source winget.
* Installatiestatus en registersleutels geverifieerd via PowerShell.

### Fase 3: Smart Hands Netwerkdiagnose
* Bottom-up OSI diagnose uitgevoerd: adapter link status gecontroleerd, IP-lease (10.0.2.15) geverifieerd, TCP/IP stack (127.0.0.1), gateway (10.0.2.2) en DNS-resolutie (
slookup google.com) getest.

### Fase 4: Enterprise Print Spooler Crash & Recovery
* Netwerkprinter PRT-WEST-LOG01 (TCP/IP poort 9100) geconfigureerd.
* Crash gesimuleerd waarbij corrupte spoolbestanden (.SHD/.SPL) de service blokkeerden.
* Geautomatiseerd herstel uitgevoerd via [scripts/fix-printspooler.bat](../scripts/fix-printspooler.bat).

### Fase 5: Geautomatiseerde ITAM Hardware Audit
* PowerShell script [scripts/audit-asset.ps1](../scripts/audit-asset.ps1) uitgevoerd om vitale systeemparameters via WMI/CIM objecten te exporteren.

---

## 5. Smart Hands Netwerkdiagnostiek (OSI-model)
1. **L1/L2 Fysiek & Datalink:** Netwerkkabel en adapter status gecontroleerd.
2. **L3 Netwerk:** ipconfig /all en ping naar Default Gateway (10.0.2.2).
3. **L4 Transport & WAN:** ping 8.8.8.8 ter verificatie van externe connectiviteit.
4. **L7 Applicatie (DNS):** 
slookup query uitgevoerd naar DNS servers.

---

## 6. Troubleshooting & Incident Response
* **Incident 1: Winget Store Certificaatfout:** Omzeild door expliciete repository selectie (--source winget).
* **Incident 2: Print Spooler Lockdown:** Geforceerde buffer purge en service herstart via batch script.
* **Incident 3: UAC Privilege Escalation Preventie:** Gebruiker geblokkeerd bij administratieve acties; actie vereist expliciete credentials van Admin_Local.

---

## 7. ITIL Incident Tickets & VIP Support Dossier
Het volledige dossier met 4 uitgewerkte ITIL tickets is te raadplegen in [documentatie/incident-management-tickets.md](incident-management-tickets.md).
