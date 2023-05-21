#  Must be running as administrator

$lab_pcs = 'lab209,lab210,lab211,lab212,lab213,lab214,lab215,lab207'.Split(',')

function testif-admin {
  $user = [Security.Principal.WindowsIdentity]::GetCurrent();
(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function test-web-connection {
  if (-not(testif-admin)) {
    write-host "Must be running as administrator."
    break
  }
  $lab_pcs | %{
    $ErrorActionPreference = 'Stop'
    $pc  = $_
    $src = 'http://www.msn.com'
    $dst = 'c:\test-web-conn.log'
    $wc  = New-Object System.Net.WebClient
    try {
      Test-Connection $pc -count 1| Out-Null
      $wc.DownloadFile($src,$dst)
      remove-item $dst
      Write-Host "$pc - succeeded"
    }
    catch {
      Write-host "$pc - fail"
    }
  }
}

function shutdown-lab {
  if (-not(testif-admin)) {
    write-host "Must be running as administrator."
    break
  }
  $lab_pcs | % {
    $ErrorActionPreference = 'stop'
    try {
    $pc  = $_
    stop-computer -comp $pc -force
    write-host "$pc - shutdown success"
    }
    catch {
    write-host "$pc - shutdown failed"
    }
  }
}

function restart-lab {
  $lab_pcs | % {
    $ErrorActionPreference = 'stop'
    try {
    $pc  = $_
    restart-computer -comp $pc -force
    write-host "$pc - shutdown success"
    }
    catch {
    write-host "$pc - shutdown failed"
    }
  }
}

function install-choco {
  Set-ExecutionPolicy Bypass -Scope Process -Force;
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function install-common-apps {
  choco install sharex git adobereader vlc jre8 putty strawberryperl gnu firefox -y
}
