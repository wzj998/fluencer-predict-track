param(
    [string]$Endpoint = $env:FLUENCER_CDP_ENDPOINT
)

$ErrorActionPreference = "Stop"

if (-not $Endpoint) {
    $Endpoint = "http://127.0.0.1:15166"
}

$uri = [Uri]$Endpoint
$hostName = $uri.Host
$port = $uri.Port
if ($port -le 0) {
    if ($uri.Scheme -eq "https") {
        $port = 443
    } else {
        $port = 80
    }
}

function Test-CdpHealthy {
    param([string]$Endpoint)

    try {
        $version = Invoke-RestMethod -Uri "$Endpoint/json/version" -TimeoutSec 3 -ErrorAction Stop
        return [pscustomobject]@{
            Healthy = $true
            Browser = $version.Browser
            WebSocketDebuggerUrl = $version.webSocketDebuggerUrl
        }
    } catch {
        return [pscustomobject]@{
            Healthy = $false
            Error = $_.Exception.Message
        }
    }
}

function Get-PortOwner {
    param([int]$Port)

    $connection = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if (-not $connection) {
        return $null
    }

    $ownerPid = $connection.OwningProcess
    $processInfo = Get-CimInstance Win32_Process -Filter "ProcessId = $ownerPid" -ErrorAction SilentlyContinue
    [pscustomobject]@{
        Pid = $ownerPid
        LocalAddress = $connection.LocalAddress
        ProcessName = $processInfo.Name
        Path = $processInfo.ExecutablePath
        CommandLine = $processInfo.CommandLine
    }
}

function Format-PortOwner {
    param([object]$Owner)

    if (-not $Owner) {
        return "no listening process found"
    }
    return "PID=$($Owner.Pid); Name=$($Owner.ProcessName); Path=$($Owner.Path); CommandLine=$($Owner.CommandLine)"
}

$health = Test-CdpHealthy -Endpoint $Endpoint
if ($health.Healthy) {
    Write-Output "Chrome CDP is available: $Endpoint/json/version"
    Write-Output "Browser: $($health.Browser)"
    exit 0
}

$owner = Get-PortOwner -Port $port
if ($owner) {
    throw "Port $hostName`:$port is occupied but is not a healthy Chrome CDP. Owner: $(Format-PortOwner -Owner $owner)"
}

throw "Chrome CDP is not reachable at $Endpoint. Start Chrome/Chromium with --remote-debugging-port=$port, then rerun this script."
