## Microsoft Article for importing PSTs. Follow along to get the SAS URL required. 
## https://docs.microsoft.com/en-us/microsoft-365/compliance/use-network-upload-to-import-pst-files?view=o365-worldwide

## Make Working Directory
mkdir C:\O365\
Set-Location C:\O365\

## Download Files
# Source URL
$url = "https://aka.ms/downloadazcopy-v10-windows"
# Destation file
$dest = "c:\O365\azcopy.zip"
# Download the file
Invoke-WebRequest -Uri $url -OutFile $dest

## Extract AzCopy
Expand-Archive -LiteralPath 'C:\O365\azcopy.zip' -DestinationPath 'C:\O365'

## Move Excutable to working directory
get-childitem -path ".\*.exe" -recurse | move-item -destination "C:\O365"

## PST Import Prompt
$BlobSAS = Read-Host -Prompt "Enter in the O365 SAS Token Provided by the Provider"

## Optional, set the key yourself and comment the line above with # at the front
#$BlobSAS = "asdf"

# Run Script and define location
$env:USERPROFILE
$PSTLocation = $env:USERPROFILE +"\Documents\Outlook Files\*"
.\azcopy.exe copy '$PSTLocation' $BlobSAS
