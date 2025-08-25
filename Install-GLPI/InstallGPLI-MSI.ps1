# ===========================
# Instalação do GLPI
# ===========================
$Path = "C:\Program Files\GLPI-Agent\glpi-agent"
$GLPIUrl = "https://github.com/glpi-project/glpi-agent/releases/download/1.15/GLPI-Agent-1.15-x64.msi"
$GLPIFile = "$env:TEMP\glpi-agent.msi"

    # ==== GLPI NÃO IDENTIFICADO - REALIZARA A INSTALAÇÃO ====
    if (!(Test-Path -Path $Path)) {
        try {
            Write-Host "Tentando instalar GLPI via MSI diretamente..." -ForegroundColor Yellow
            Invoke-WebRequest -Uri $GLPIUrl -OutFile $GLPIFile
           $process = Start-Process msiexec.exe -ArgumentList @("/i `"$GLPIFile`"", "DELAYTIME=120", "HTTPD_TRUST=127.0.0.1", "NO_SSL_CHECK=1", "SCAN_HOMEDIRS=0", "SCAN_PROFILES=0", "SERVER=http://172.173.167.109/marketplace/glpiinventory/", "DELAYTIME=120", "TAG=%COMPUTERNAME%", "RUNNOW=1", "/qn", "/norestart") -Wait -PassThru
    # VERIFICAÇÃO e VALIDAÇÃO
    $exitCode = $process.ExitCode
    if ($exitCode -eq 0){
        Write-host "Insalação teve sucesso." -ForegroundColor Green
    } else {
        Write-Host "A instalação falhou. Codigo do erro: $exitCode" -ForegroundColor Red
    }
            Write-Host "Instalação via MSI concluída com sucesso." -ForegroundColor Green
            exit 0
        } catch {
            Write-Host "Erro durante a instalação via MSI: $($_.Exception.Message)" -ForegroundColor Red
            exit 1
        }
    } if (Test-Path -Path $Path) {
        Write-Host "Agent GLPI instalado corretamente!" -ForegroundColor Green
    } else {
        Write-Host "Falha ao instalar o Agent GLPI." -ForegroundColor Red
    } Stop-Transcript    
    else {
    Write-Host "Agent GLPI já está instalado." -ForegroundColor Green
}