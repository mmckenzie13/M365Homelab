## User Offboarding - 

#Variables
$Creds = (Get-Credential)
$TermUserUPN = Read-Host -Prompt "Enter Term User's UPN"
$TermUserUPNNew = ("Term-" + $TermUserUPN) 
$TermGroup = "TermUsers@domain.com"

#Connect to Azure AD
Connect-AzureAD -credential $Creds

# Identify Manager via powershell 
$TermUserMgr = (get-azureadusermanager –ObjectID $TermUserUPN).objectid

# Disable User Sign In
Set-AzureADUser -ObjectID $TermUserUPN -AccountEnabled $false

# Connect to Exchange Online
Connect-ExchangeOnline -credential $Creds

# Add to Term M365 Group
Add-UnifiedGrouplinks –identity $TermGroup -linktype "members" -Links $TermUserUPN 

# Connect to MSOL
Connect-msolservice -credential $Creds

# Update UPN to New UPN
Set-MsolUserPrincipalName -UserPrincipalName $TermUserUPN -NewUserPrincipalName $TermUserUPNNew

# Remove Alias's so that original address NDRs
Set-Mailbox –identity $TermUserUPN –EmailAddresses @{Remove=$TermUserUPN} 

# Convert to Shared Mailbox 
Set-Mailbox –Identity $TermUserUPNNew –type Shared 

# Add Manager Full Permissions 
Add-MailboxPermission -Identity $TermUserUPNNew -User $TermUserMgr -AccessRights FullAccess -InheritanceType All 

# Sharepoint – User Profile Add Permissions 
# Reference Other PS1 for Sharepoint
## Remove Licensing by removing from Assigned & Dynamic Groups

# Assigned Group Removal
$TermUserUPNNew = Get-MSOLUser -UserPrincipalName $TermUserUPNNew
$GroupID = Get-MsolGroup –SearchString "Microsoft 365 E3"
$GroupIDGUID = $GroupID.ObjectID
Remove-MsolGroupMember –GroupObjectID $GroupID.ObjectId –GroupMemberType User –GroupMemberObjectID $TermUserUPNNew.ObjectID

# Dynamic Group Removal based on Active / Inactive Status so handled in disabling Sign In
