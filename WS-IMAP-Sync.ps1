## Setting up your IMAP Migration via Powershell
# https://docs.microsoft.com/en-us/microsoft-365/enterprise/use-powershell-to-perform-an-imap-migration-to-microsoft-365?view=o365-worldwide
# https://docs.microsoft.com/en-us/exchange/mailbox-migration/migrating-imap-mailboxes/csv-files-for-imap-migrations

# Test your site
Test-MigrationServerAvailability -IMAP -RemoteServer <FQDN of IMAP server> -Port <143 or 993> -Security <None, Ssl, or Tls>

# Create your IMAP Endpoint
New-MigrationEndpoint -IMAP -Name IMAPEndpoint -RemoteServer imap.contoso.com -Port 993 -Security Ssl

# Verify your IMAP Endpoint
Get-MigrationEndpoint IMAPEndpoint | Format-List EndpointType,RemoteServer,Port,Security,Max*

# Upload your CSV to create the job
New-MigrationBatch -Name IMAPBatch1 -SourceEndpoint IMAPEndpoint -CSVData ([System.IO.File]::ReadAllBytes("C:\Users\Administrator\Desktop\IMAPmigration_1.csv")) -AutoStart

# Verify job
Get-MigrationBatch -Identity IMAPBatch1 | Format-List
Get-MigrationBatch -Identity IMAPBatch1 | Format-List Status

# Delete the Job post migration cutover
Remove-MigrationBatch -Identity IMAPBatch1

# Verify Deletion
Get-MigrationBatch IMAPBatch1"
