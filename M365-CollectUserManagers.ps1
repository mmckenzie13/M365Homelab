## Connects to Azure AD and Pulls All Users & Managers
# Permissions to run can be any Azure AD User, no role required

import-module azuread

Connect-azuread

$UserReport = 
foreach($azaduser in (Get-AzureADUser -All:$true)){
    [pscustomobject]@{
        DisplayName       = $azaduser.DisplayName
        UserPrincipalName = $azaduser.UserPrincipalName
        GivenName         = $azaduser.GivenName
        Surname           = $azaduser.Surname
        JobTitle          = $azaduser.JobTitle
        Department        = $azaduser.Department
        City              = $azaduser.City
        Country           = $azaduser.Country
        StreetAddress     = $azaduser.StreetAddress
        CompanyName       = $azaduser.CompanyName
        Mail              = $azaduser.Mail
        manager           = (Get-AzureADUserManager -ObjectId $azaduser.ObjectId).displayname
    }
}

$UserReport |
export-csv "c:\Exports\AzureADManagers.csv" -NoTypeInformation
