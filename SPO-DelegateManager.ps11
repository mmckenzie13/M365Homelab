# Install Module - https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-pnp/sharepoint-pnp-cmdlets
Install-Module -Name "PnP.PowerShell"

# Consent if its your first time
Register-PnPManagementShellAccess

#Set Variables
$Creds = (Get-Credential)
$Tenant = read-host -prompt "Enter in your Microsoft Tenant (ex. Company.onmicrosoft.com would be Company)"
$SiteURL = ("https://" + $Tenant + ".sharepoint.com")
$AdminSiteURL= ("https://" + $Tenant + "-admin" + ".sharepoint.com")
$UserAccount = Read-Host -Prompt "Enter in the Users UPN"
$UserMgr = (Get-AzureADUserManager -ObjectId $UserAccount).UserPrincipalName
 
#Connect to PnP Online
Connect-PnPOnline -Url $SiteURL -Credentials $Creds
 
#Get all properties of a User Profile
$UserProfile = Get-PnPUserProfileProperty -Account $UserAccount

# Match Up Collected Information into Variables
$OneDriveSiteUrl = $UserProfile.PersonalUrl

#Change OneDrive Ownership
Connect-PnPOnline -Url $AdminSiteURL -Credentials $Creds
Set-PnPTenantSite -Url $OneDriveSiteUrl -Owners $UserMgr
