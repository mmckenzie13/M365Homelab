# Use CSV from Bulk User Import via https://admin.microsoft.com/ or https://portal.azure.com
# You'll need to add a column at the end for MailNickName

# Install & Connect
import-module azuread
connect-azuread

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "MonkeyWrench2020##"

$CSV = import-csv -Path .\UserCreateTemplate.csv
ForEach ($User in $CSV){

  $UserDPN = $User."Name [displayName] Required"
  $UPN = $User."User name [userPrincipalName] Required"
  $UserFN = $User."First name [givenName]"
  $UserLN = $User."Last name [surname]"
  $UserTitle = $User."Job title [jobTitle]"
  $UserDept = $User."Department [department]"
  $UserLoc = $User."Usage location [usageLocation]"
  $UserAdd = $User."Street address [streetAddress]"
  $UserState = $User."State or province [state]"
  $UserCountry = $User."Country or region [country]"
  $UserOffice = $User."Office [physicalDeliveryOfficeName]"
  $UserCity = $User."City [city]"
  $UserZIP = $User."ZIP or postal code [postalCode]"
  $UserOffPhone = $User."Office phone [telephoneNumber]"
  $UserMobile = $User."Mobile phone [mobile]"
  $UserMailNick = $User."MailNickName"

New-AzureADUser -DisplayName $UserDPN -UserPrincipalName $UPN -PasswordProfile $PasswordProfile -AccountEnabled $true -GivenName $UserFN -Surname $UserLN -JobTitle $UserTitle -Department $UserDept -UsageLocation $UserLoc -StreetAddress $UserAdd -State $UserState -Country $UserCountry -PhysicalDeliveryOfficeName $UserOffice -City $UserCity -PostalCode $UserZIP -TelephoneNumber $UserOffPhone -Mobile $UserMobile -MailNickName $UserMailNick

}
