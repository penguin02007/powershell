function Get-QBBackup {
  $QBCwd = 'C:\options\qb\cwd'
  $QBBackUpPath = 'C:\options\qb2017'
  $QBBFiles = Get-ChildItem $QBBackUpPath\*QBB
  $NumOfQBBFiles = $QBBFiles.Count
  $NameOfQBFiles = $QBBFiles.Name -join "`n"
  $NumOfQBBSinceYday = ($QBBFiles | Where {$_.LastWriteTime -ge (Get-Date).AddDays(-1)}).count
  if( $QBBFiles.LastWriteTime -ge [datetime]::Today){ 
     $BackupMessage = "SUCCESS :: Backup ran successfully."
  }else{
     $BackupMessage = "WARNING :: Backup did not run."
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
function Send-HSMail {
  param( [string]$to,[string]$bcc )
  $from = 'quickbooks@hydesquare.org'
  $subject = 'Quickbooks Backup Status'
  $smtpserver = 'smtp-relay.gmail.com'
  $body = Get-QBBackup
  Send-MailMessage -To $to -Bcc $bcc -From $from -Subject $subject -SmtpServer $smtpserver -UseSsl -Body $body
}
Send-HSMail -to leochan@hydesquare.org -bcc leochan@hydesquare.org
