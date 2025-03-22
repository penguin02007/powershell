<#
.SYNOPSIS
    Manages QuickBooks backup files by purging old backups, verifying backup status, and sending email report.

.DESCRIPTION
    1. Purges QuickBooks backup files older than 30 days.
    2. Checks if a backup was created last 24 hours.
    3. Generates a summary report of available backups.
    4. Sends an email notification with backup status.

.PARAMETER to
    Specifies the recipient email address for the backup report.

.PARAMETER bcc
    Specifies the BCC recipient email address for the backup report.

.EXAMPLE
    . C:\options\scripts\Get-QBBackup.ps1; Send-QBReport -to foo@bar.zoo -bcc foo@bar.zoo

.NOTES
    - Ensure script is run with necessary permissions to delete backup files and send emails.

.AUTHOR
    Leo Chan

.VERSION
    1.0

#>

$QBCwd = 'C:\options\qb\cwd'
$QBBackUpPath = '\\hstf.local\public\aaOfficeMgr\qb'
$QBBFiles = Get-ChildItem $QBBackUpPath\*QBB
$Today = (Get-Date).Date
$MaxAgeInDays = 30

function Purge-QBBackup {
  foreach ($file in $QBBFiles) {
    if (($file.Name -match "Hyde Square Task Force") -and (($Today - $file.CreationTime).Days -ge $MaxAgeInDays)){
    Remove-Item $file.FullName
    }
  }
}

function Get-QBBackup {
  $QBBFiles = Get-ChildItem "$QBBackUpPath\*Hyde Square Task Force*QBB"
  $NumOfQBBFiles = $QBBFiles.Count
  $NameOfQBFiles = $QBBFiles.Name -join "`n"
  $NumOfQBBSinceYday = ($QBBFiles | Where {$_.LastWriteTime -ge (Get-Date).AddDays(-1)}).count
  if( $QBBFiles.LastWriteTime -ge [datetime]::Today){
     $BackupMessage = "SUCCESS :: Backup ran successfully today."
     $Subject       = "Quickbooks Backup Status - Success" 
  }else{
     $BackupMessage = "WARNING :: Backup did not run today."
     $Subject       = "Quickbooks Backup Status - Warning" 
  }
  $FullBackMessage ="`
##########################################################################`
$BackupMessage `
##########################################################################`
Working Directory - $QBCwd
Backup Directory - $QBBackUpPath
There are $NumOfQBBFiles backup(s) and $NumOfQBBSinceYday backup(s) ran today.`
$NameOfQBFiles
`n`
"
  $Result = @($Subject, $FullBackMessage)
  return $Result
}

function Send-QBReport {
  param( [string]$to,[string]$bcc )
  $from          = 'quickbooks@hydesquare.org'
  $smtpserver    = 'smtp-relay.gmail.com'
  $Result        = Get-QBBackup
  $Subject       = $Result[0]
  $body          = $Result[1]
  Send-MailMessage -To $to -Bcc $bcc -From $from -Subject $subject -SmtpServer $smtpserver -UseSsl -Body $body
}
Purge-QBBackup
