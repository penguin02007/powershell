# Dell Update Packages Silent Installer
# 
# Prepare.ps1 - Prepare install script
# install_pkg.ps1 - Install Dell Update Packages 
#
$pkgs           = Get-ChildItem packages
$install_script = 'install_pkg.ps1'
if (test-path $install_script -PathType Leaf) {
  del $install_script
}
foreach ($pkg in $pkgs) {
  Write-Output "write-host Installing $pkg" | Add-Content $install_script
  Write-Output ".\packages\$pkg /s | out-null" | Add-Content $install_script
}
Get-Content $install_script