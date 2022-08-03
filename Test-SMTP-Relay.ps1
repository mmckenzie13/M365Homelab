## First test connectivity to the mail server. Then send a test e-mail. 
# Variables
$MailServer = "FQDN_or_IP"
$Sender = "sender@domain.com"
$Recipient = "recipient@domain.com"
$Subject = "Connectivity Test"

# Test Network Connectivity
Test-netconnection $MailServer -port 25

#Verify TcpTestSucceed shows True
Send-MailMessage -SmtpServer $MailServer -Port 25 -usessl -From $Sender -To $Recipient -Subject $Subject 
