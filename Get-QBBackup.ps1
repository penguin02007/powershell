function Get-QBBackup {
  $QBBPath = 'C:\options\qb2017'
  $QBBFiles = Get-ChildItem $QBBPath\*QBB
  $NumOfQBBFiles = $QBBFiles.Count
  $NumOfQBBSinceYday = ($QBBFiles | Where {$_.LastWriteTime -ge (Get-Date).AddDays(-1)}).count
  if( $QBBFiles.LastWriteTime -ge [datetime]::Today){ 
     $BackupMessage = "## Backup was ran successfully in $QBBPath. ##"
  }else{
     $BackupMessage = "## Backup was not run or there is error encountered. Check in $QBBPath. ##"
  }
  $FullBackMessage ="`
  $BackupMessage `
  There are $NumOfQBBFiles total backup(s) and $NumOfQBBSinceYday backup(s) ran today.`
  "
  return $FullBackMessage
}

function Send-HSMail {
  $to = 'finance@hydesquare.org'
  $bcc = 'leochan@hydesquare.org'
  $from = 'quickbooks@hydesquare.org'
  $subject = 'Quickbooks Backup Status'
  $smtpserver = 'smtp-relay.gmail.com'
  $body = Get-QBBackup
  Send-MailMessage -To $to -Bcc $bcc -From $from -Subject $subject -SmtpServer $smtpserver -UseSsl -Body $body
}
Send-HSMail