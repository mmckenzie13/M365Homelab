# Use CSV from Bulk User Import via https://admin.microsoft.com/ or https://portal.azure.com
# You'll need to add a column at the end for MailNickName, Manager, ID
# Manager field needs to be their UPN

# Sample CSV - Remove Comment
# Name [displayName] Required,User name [userPrincipalName] Required,Initial password [passwordProfile] Required,Block sign in (Yes/No) [accountEnabled] Required,First name [givenName],Last name [surname],Job title [jobTitle],Department [department],Usage location [usageLocation],Street address [streetAddress],State or province [state],Country or region [country],Office [physicalDeliveryOfficeName],City [city],ZIP or postal code [postalCode],Office phone [telephoneNumber],Mobile phone [mobile],MailNickName,Manager,ID
# Bob Smith,bsmith@domain.com,, No,Bob,Smith,Monkey Tamer,Creative,US,123 ABC Drive,AL,United States,Corp,Birmingham,35203,1234567891,1234567891,Bob,boss@domain.com,10006


# Install & Connect
import-module azuread
connect-azuread

# Setting all Users Passwords
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "MonkeyWrench2020##"

# Importing the CSV, populating variables with CSV in a loop while creating, looking up, modifying properties. 
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
  $UserManager = $User."Manager"
  $UserEmpID = $User."ID"

# Creating the User Initially
New-AzureADUser -DisplayName $UserDPN -UserPrincipalName $UPN -PasswordProfile $PasswordProfile -AccountEnabled $true -GivenName $UserFN -Surname $UserLN -JobTitle $UserTitle -Department $UserDept -UsageLocation $UserLoc -StreetAddress $UserAdd -State $UserState -Country $UserCountry -PhysicalDeliveryOfficeName $UserOffice -City $UserCity -PostalCode $UserZIP -TelephoneNumber $UserOffPhone -Mobile $UserMobile -MailNickName $UserMailNick

# Setting Employee ID
Set-AzureADUserExtension -Object $UPN -ExtensionName "employeeID" -ExtensionValue $UserEmpID

# Collecting the User Managers ObjectID and the Users Object ID to update the AzureADUserManager assignment and then applying the update to the user's properties
$UserManagerObjID = get-AzureADUser -objectID $UserManager
$UserObjID = Get-AzureAdUser -objectID $UPN
Set-AzureADUserManager -ObjectID $UserObjID.ObjectID -RefObjectID $UserManagerObjId.ObjectID
}
