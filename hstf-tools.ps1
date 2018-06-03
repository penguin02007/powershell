#  Must be running as administrator

function testif-admin {
  $user = [Security.Principal.WindowsIdentity]::GetCurrent();
(New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function test-web-conn {
  if (-not(testif-admin)) {
    write-host "Must be running as administrator."
    break
  }
  201..216 | %{
    $ErrorActionPreference = 'Stop'
    $pc  = "lab$($_)"
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

function shutdown-comp {
  if (-not(testif-admin)) {
    write-host "Must be running as administrator."
    break
  }
  201..216 | % {
    $ErrorActionPreference = 'stop'
    try {
    $pc  = "lab$($_)"  
    write-host $pc
    stop-computer -comp $pc -force
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
  choco install sharex git flashplayerplugin flashplayeractivex adobereader vlc jre8 putty strawberryperl gnu firefox tigervnc -y
}
