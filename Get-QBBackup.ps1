$QBCwd = 'C:\options\qb\cwd'
$QBBackUpPath = '\\hstf.local\public\aaOfficeMgr\qb'
$QBBFiles = Get-ChildItem $QBBackUpPath\*QBB
$Today = (Get-Date).Date
$MaxAgeInDays = 14

function Purge-QBBackup {
  foreach ($file in $QBBFiles) {
    if (($file.Name -match "Hyde Square Task Force") -and (($Today - $file.CreationTime).Days -ge $MaxAgeInDays)){
    Remove-Item $file.FullName
    }
  }
}

function Get-QBBackup {
  $QBBFiles = Get-ChildItem $QBBackUpPath\*QBB
  $NumOfQBBFiles = $QBBFiles.Count
  $NameOfQBFiles = $QBBFiles.Name -join "`n"
  $NumOfQBBSinceYday = ($QBBFiles | Where {$_.LastWriteTime -ge (Get-Date).AddDays(-1)}).count
  if( $QBBFiles.LastWriteTime -ge [datetime]::Today){ 
     $BackupMessage = "SUCCESS :: Backup ran successfully today."
  }else{
     $BackupMessage = "WARNING :: Backup did not run today."
  }
  $FullBackMessage ="`
####################################################################################`
$BackupMessage `
####################################################################################`
Working Directory - $QBCwd
Backup Directory - $QBBackUpPath
There are $NumOfQBBFiles backup(s) and $NumOfQBBSinceYday backup(s) ran today.`
$NameOfQBFiles
`n`
"
  return $FullBackMessage
}

function Send-QBReport {
  param( [string]$to,[string]$bcc )
  $from = 'quickbooks@hydesquare.org'
  $subject = 'Quickbooks Backup Status'
  $smtpserver = 'smtp-relay.gmail.com'
  $body = Get-QBBackup
  Send-MailMessage -To $to -Bcc $bcc -From $from -Subject $subject -SmtpServer $smtpserver -UseSsl -Body $body
}
 
 Purge-QBBackup
