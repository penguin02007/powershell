#  Run as Admin

function install-choco {
  iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

function install-nvr-apps {
  $hostname       = $env:COMPUTERNAME
  $nvrWorkStation = "nvr"
  if ($hostname -match $nvrWorkStation) {
    Write-Host "Hostname matches NVR."
    choco install tightvnc -y
  } else {
    Write-Host "Hostname does not match NVR."
  }

function install-imageglass {
 choco install imageglass -y
 $extension      = ".heic"
 $imageGlassPath = "C:\Program Files\ImageGlass\ImageGlass.exe"
 $progId         = "ImageGlass.heic"

  # Register the file extension with a ProgID
  New-Item -Path "HKCU:\Software\Classes\$extension" -Force | Out-Null
  Set-ItemProperty -Path "HKCU:\Software\Classes\$extension" -Name "(Default)" -Value $progId
}

function install-common-apps {
  choco install vcredist140 vcredist2015 sharex git adobereader vlc jre8 putty firefox googlechrome zoom dotnet4.5 python -y
}

function install_all {
  [CmdletBinding(SupportsShouldProcess=$true,
  ConfirmImpact='Medium')]
  Set-ExecutionPolicy Bypass -Scope Process -Force;

  install-choco
  install-imageglass
  install-common-apps
  install-nvr-apps
  Write-Host "All applications installed successfully."
}
