@echo off
:: ============================================================================
:: Enterprise Print Spooler Recovery Tool
:: Target: Windows Workstations & Print Servers
:: Purpose: Flushes stuck jobs, clears corrupt buffers and restarts spoolsv.exe
:: ============================================================================

echo [INFO] Stopping Print Spooler Service...
net stop spooler /y >nul 2>&1

echo [INFO] Purging corrupt print queue buffer files in System32\spool\PRINTERS...
del /Q /F /S "%systemroot%\System32\spool\PRINTERS\*.*" >nul 2>&1

echo [INFO] Starting Print Spooler Service...
net start spooler >nul 2>&1

sc query spooler | findstr /I "STATE"
echo [SUCCESS] Print Spooler recovery sequence complete.
pause
