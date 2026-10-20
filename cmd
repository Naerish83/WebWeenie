"===== 1 WHO / HOST ====="
whoami; $env:COMPUTERNAME; [System.Environment]::OSVersion.Version
"===== 2 TRX PROCESSES + COMMAND LINES ====="
Get-CimInstance Win32_Process -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'basilisk|jp2launcher|javaw|java' } | Select-Object Name,ProcessId,CommandLine | Format-List
"===== 3 LISTENING PORTS ====="
netstat -ano | Select-String LISTENING | Select-Object -First 25
"===== 4 ESTABLISHED CONNS ====="
netstat -ano | Select-String ESTABLISHED | Select-Object -First 25
"===== 5 TAILSCALE ====="
Get-Service Tailscale -ErrorAction SilentlyContinue | Select-Object Name,Status
"===== 6 DEPLOYMENT CACHE FILES ====="
Get-ChildItem C:\Users\wyoung\AppData\LocalLow\Sun\Java\Deployment\cache\6.0 -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize
"===== 7 CACHED URLS (from .map) ====="
$maps = Get-ChildItem C:\Users\wyoung\AppData\LocalLow\Sun\Java\Deployment\cache\6.0\*.map -File -ErrorAction SilentlyContinue
$maps | Select-Object Name,Length
if ($maps) { $m = $maps | Sort-Object Length -Descending | Select-Object -First 1; [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($m.FullName)) -split "`0" | Where-Object { $_ -match '\.jar$|\.fmx$|\.jnlp$' } | Select-Object -Unique -First 40 }
"===== 8 DEPLOYMENT PROPERTIES ====="
Select-String -Path C:\Users\wyoung\AppData\LocalLow\Sun\Java\Deployment\deployment.properties -Pattern 'codebase|security|jnlp|offline' -ErrorAction SilentlyContinue | Select-Object -First 25 Line
"===== 9 BASILISK PROFILE URLS ====="
Get-ChildItem C:\Users\wyoung\AppData\LocalLow\Basilisk -Recurse -File -Include *.js,*.txt,*.ini,*.html -ErrorAction SilentlyContinue | Select-String -Pattern 'gerharz|formservlet|\.jnlp' -List -ErrorAction SilentlyContinue | Select-Object Path,LineNumber,Line -First 25
"===== 10 URL SHORTCUTS ====="
Get-ChildItem C:\Users\wyoung\Desktop,C:\Users\wyoung\Documents -File -Filter *.url -ErrorAction SilentlyContinue | ForEach-Object { "$($_.FullName) => $((Get-Content $_.FullName -Raw).Trim())" }
"===== 11 TOOLS DIR ====="
Get-ChildItem C:\Users\wyoung\Tools -File -ErrorAction SilentlyContinue | Select-Object Name,Length,LastWriteTime | Format-Table -AutoSize
"===== 12 SCHEDULED TASKS ====="
Get-ScheduledTask -ErrorAction SilentlyContinue | Where-Object { $_.TaskName -match 'trx|cairn|gerharz' } | Select-Object TaskName,State | Format-Table -AutoSize
"===== 13 TRXRECORDER FILES ====="
Get-ChildItem C:\Users\wyoung\Tools,C:\Users\wyoung\Desktop,'C:\Program Files','C:\Program Files (x86)' -Recurse -File -Filter *TRXRecorder* -ErrorAction SilentlyContinue | Select-Object FullName,Length | Format-Table -AutoSize
