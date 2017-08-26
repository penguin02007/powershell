#  Must be running as administrator

function test-web-conn {
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
