# Incident & Request Management Dossier — Talia Industries (Plant Westerlo)

Dit document bevat de formele ITIL-conforme registratie van incidenten en serviceverzoeken die zijn afgehandeld binnen de End-User Computing (EUC) en Onsite Support scope van de productielocatie Westerlo (Talia Industries).

---

## Ticket Overzicht

| Ticket ID | Type | Prioriteit | Categorie | Korte Omschrijving | Status |
|---|---|---|---|---|---|
| **INC-1042** | Incident | **P1 (Kritiek)** | Hardware / Printers | Verzendlabelprinter `PRT-WEST-LOG01` reageert niet — logistiek geblokkeerd | **Resolved** |
| **INC-1043** | Incident | **P2 (Hoog)** | Executive / VIP | Plant Director laptop crash / Outlook data corruption (White-Glove Support) | **Resolved** |
| **INC-1044** | Incident | **P3 (Normaal)** | Netwerk / Smart Hands | Werkstation `WKS-WEST-01` verliest verbinding met ERP-applicatie | **Resolved** |
| **REQ-2015** | Service Request | **P4 (Laag)** | Workplace Staging | Onboarding & Staging nieuwe werkplek operator `j.peeters` (Least Privilege) | **Closed** |

---

## 📋 Ticket Details

### Ticket 1: INC-1042 — Vastgelopen Print Spooler op Bedrijfskritische Verzendprinter
* **Melder:** Magazijn Supervisor (Logistiek Westerlo)
* **Urgentie / Impact:** Hoog / Hoog -> **P1 (Kritiek)** (Vrachtwagens kunnen niet vertrekken zonder verzenddocumenten).
* **Probleemomschrijving:**  
  De netwerkprinter `PRT-WEST-LOG01` (TCP/IP poort 9100) verwerkt geen printopdrachten meer. Op het werkstation staat een afdruktaak continu op de status *"Deleting - Printing"*. Gebruikers kunnen de printwachtrij niet wissen via de Windows GUI.
* **Troubleshooting & Uitvoering:**
  1. Oplevering geclassificeerd als P1 met een SLA-streeftijd van < 30 minuten.
  2. Ter plaatse geverifieerd dat de fysieke printer online is en reageert op ICMP-pings.
  3. Via Administrator PowerShell vastgesteld dat de Windows service `Spooler` geblokkeerd is geraakt door een corrupte bufferfile.
  4. Uitvoering van de herstelprocedure (`fix-printspooler.bat`):
     ```cmd
     net stop spooler /y
     del /Q /F /S "C:\Windows\System32\spool\PRINTERS\*.*"
     net start spooler
     ```
  5. Testpagina succesvol afgedrukt.
* **Root Cause:** Een beschadigd PDF-verzendlabel veroorzaakte een buffer-lockdown in `%systemroot%\System32\spool\PRINTERS`.
* **Communicatie naar Melder:** *"De printerdienst is gereset en de geblokkeerde buffer is opgeschoond. De testpagina is succesvol afgedrukt; verzendlabels kunnen direct weer worden ingestuurd."*

---

### Ticket 2: INC-1043 — VIP Executive Support (White-Glove Assistance)
* **Melder:** Directiesecretaresse namens de Plant Director (VIP)
* **Urgentie / Impact:** Zeer Hoog / Enkel individu -> **P2 (Hoog)**
* **Probleemomschrijving:**  
  De Plant Director heeft over 20 minuten een strategische kwartaalmeeting met het Global Executive Team. Outlook start niet op en geeft de foutmelding: *"Cannot start Microsoft Outlook. Cannot open the Outlook window. The set of folders cannot be opened."*
* **Troubleshooting & "White-Glove" Protocol:**
  1. Direct fysiek naar het directiekantoor gegaan met een voorbereide reserve-laptop (Spare asset) als backup-oplossing.
  2. Rustige, professionele houding aangenomen en de directeur direct gerustgesteld dat zijn documenten veilig zijn.
  3. Werkstation gestart in Safe Mode (`outlook.exe /safe`) om corrupte invoegtoepassingen uit te sluiten.
  4. Geconstateerd dat het lokale offline cache-bestand (`.ost`) gecorrumpeerd was na een geforceerde herstart.
  5. Snel het corrupte bestand hernoemd naar `.ost.old` en Outlook herstart, waardoor het profiel automatisch een schone synchronisatie startte met Exchange Online / M365.
  6. Geverifieerd dat de vergaderagenda en e-mail direct weer synchroon liepen binnen 12 minuten.
* **Afsluiting:** Persoonlijk aanwezig gebleven tot de meeting succesvol begon.

---

### Ticket 3: INC-1044 — "Smart Hands" Diagnostiek & Netwerkescalatie
* **Melder:** Productieplanning Lijn 3
* **Urgentie / Impact:** Gemiddeld / Gemiddeld -> **P3 (Normaal)**
* **Probleemomschrijving:**  
  Het werkstation op de productievloer kan de centrale planningdatabase niet meer bereiken. De gebruiker vermoedt dat de pc kapot is.
* **Troubleshooting & Smart Hands Werkwijze:**
  1. Stapsgewijze OSI-laag analyse uitgevoerd via Windows Terminal:
     * **Laag 1 (Fysiek):** Link-leds op de netwerkpoort van het werkstation en de wandcontactdoos gecontroleerd (groen knipperend, fysiek in orde).
     * **Laag 2 & 3 (Data & Netwerk):** `ipconfig /all` uitgevoerd. Machine heeft een geldig IP verkregen via DHCP (`10.0.2.15/24`) met gateway `10.0.2.2`.
     * **Loopback:** `ping 127.0.0.1` -> 0% packet loss (interne netwerkkaart en stack werken 100%).
     * **Gateway:** `ping 10.0.2.2` -> 0% packet loss (lokaal subnet bereikbaar).
     * **DNS:** `nslookup google.com` -> Succesvolle omzetting via DNS-servers.
  2. Conclusie: Werkplek en lokaal switchsegment functioneren vlekkeloos. Het probleem bevindt zich in de routing of de firewall op de centrale applicatieserver.
  3. **Escalatie:** Ticket met bijgevoegde CLI logs geëscaleerd naar het *Global Network & Infrastructure Team*, inclusief MAC-adres, IP-configuratie en switchpoort-nummer.

---

### Ticket 4: REQ-2015 — Werkplek Staging & Least Privilege Inrichting
* **Melder:** HR Department / Operations Manager
* **Urgentie / Impact:** Laag / Laag -> **P4 (Standaard Request)**
* **Omschrijving:**  
  Nieuwe werkplek klaarmaken voor operator `Jan Peeters` (`j.peeters`) op de productievloer van de fabriek in Westerlo.
* **Staging Checklist:**
  1. [x] Werkstation voorzien van officiële Windows 11 Enterprise image.
  2. [x] Lokaal IT Support administrator-account `Admin_Local` aangemaakt en toegevoegd aan de lokale `Administrators` groep.
  3. [x] Standaard gebruikersaccount `j.peeters` aangemaakt zonder administratieve rechten.
  4. [x] User Account Control (UAC) ingeschakeld op het hoogste beveiligingsniveau ter voorkoming van ongeautoriseerde executables en malware.
  5. [x] Goedgekeurde softwaretools (o.a. compressie- en viewersoftware) unattended gedeployed via `winget` CLI scripts.
  6. [x] Hardware-inventarisatie uitgevoerd via `audit-asset.ps1` en serienummer gekoppeld aan de asset database.
* **Status:** Uitgeleverd aan de medewerker na acceptatietest.
