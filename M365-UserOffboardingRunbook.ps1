## User Offboarding

# Connections
$Creds = (Get-Credential)


#Connect to Azure AD
Connect-msolservice -credential $Creds
$GroupID = Get-MsolGroup –SearchString "Offboarding"


foreach($TermUser in (Get-MsolGroupMember -groupobjectid $GroupID.ObjectId))
{
	# Variables
	$TermUserUPNNew = ("Term-" + $TermUserUPN) 
	$TermGroup = "TermUsers@company.com"
	$TermUserUPN = $TermUser.EmailAddress

	#Connect to Azure AD
	Connect-AzureAD -credential $Creds

	# Identify Manager via powershell 
	$TermUserMgr = (get-azureadusermanager –ObjectID $TermUserUPN).objectid

	# Disable User Sign In
	Set-AzureADUser -ObjectID $TermUserUPN -AccountEnabled $false
	Get-AzureADUser -SearchString $TermUserUPN | Revoke-AzureADUserAllRefreshToken
	Set-AzureADUser -objectid $TermUserUPN -Company "InActive"

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

	# Assigned Group Removal
	$TermUserUPNNew = Get-MSOLUser -UserPrincipalName $TermUserUPNNew
	$GroupID = Get-MsolGroup –SearchString "Microsoft 365 E3"
	$GroupIDGUID = $GroupID.ObjectID
	Remove-MsolGroupMember –GroupObjectID $GroupID.ObjectId –GroupMemberType User –GroupMemberObjectID $TermUserUPNNew.ObjectID

	# OneDrive Reassignment
	$Tenant = "company"
	$SiteURL = ("https://" + $Tenant + ".sharepoint.com")
	$AdminSiteURL= ("https://" + $Tenant + "-admin" + ".sharepoint.com")
	$UserMgr = (Get-AzureADUserManager -ObjectId $TermUserUPNNew).UserPrincipalName
 
	#Connect to PnP Online
	Connect-PnPOnline -Url $SiteURL -Credentials $Creds
 
	#Get all properties of a User Profile
	$UserProfile = Get-PnPUserProfileProperty -Account $TermUserUPNNew

	# Match Up Collected Information into Variables
	$OneDriveSiteUrl = $UserProfile.PersonalUrl

	#Change OneDrive Ownership
	Connect-PnPOnline -Url $AdminSiteURL -Credentials $Creds
	Set-PnPTenantSite -Url $OneDriveSiteUrl -Owners $UserMgr
}
