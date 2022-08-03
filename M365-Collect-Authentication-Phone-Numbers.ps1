 Connect-MsolService
 
 # For Single User
 $user=Get-MsolUser -UserPrincipalName "user@company.com"
 $user.StrongAuthenticationUserDetails.PhoneNumber
 
 # For All Users
 Get-MsolUser -All | Select-Object @{N='UserPrincipalName';E={$_.UserPrincipalName}},@{N='MFA Status';E={if ($_.StrongAuthenticationRequirements.State){$_.StrongAuthenticationRequirements.State} else {"Disabled"}}},@{N='MFA Methods';E={$_.StrongAuthenticationUserDetails.PhoneNumber}} | Export-Csv -Path c:\MFA_Report.csv -NoTypeInformation
