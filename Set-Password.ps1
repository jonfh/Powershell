﻿Get-MsolUser | Select-object UserPrincipalName | Export-Csv C:\Users.csv -NoTypeInformation

#Import-Csv "C:\Users.csv" | % { Set-MsolUserPassword -userPrincipalName "$_.UserPrincipalName" -NewPassword "$PASS" -ForceChangePassword $True } //funker av en eller annen grunn ikke

$Users = import-csv C:\Users.csv
ForEach ($User in $Users) {
$Pass = "Lege"
    $Epost=$User.UserPrincipalName 
    $Pass=$Pass + (Get-Random -Maximum 10000 -Minimum 1000)
    (Set-MsolUserPassword -UserPrincipalName $User.UserPrincipalName -NewPassword $Pass -ForceChangePassword $TRUE)
    "Hei.  `r`nPassordet på din nye epost-konto er: " + $Pass + " `r`nMed vennelig hilsen Jon, UniSoft."| Out-File C:\Users\jon_h\ownCloud\documents\legepost\$Epost.txt
    } 
