###########################################################
# AUTHOR  : Marius / Hican - http://www.hican.nl - @hicannl 
# DATE    : 26-04-2012 
# EDIT    : 07-08-2014
# COMMENT : This script creates new Active Directory users,
#           including different kind of properties, based
#           on an input_create_ad_users.csv.
# VERSION : 1.3
###########################################################

# CHANGELOG
# Version 1.2: 15-04-2014 - Changed the code for better
# - Added better Error Handling and Reporting.
# - Changed input file with more logical headers.
# - Added functionality for account Enabled,
#   PasswordNeverExpires, ProfilePath, ScriptPath,
#   HomeDirectory and HomeDrive
# - Added the option to move every user to a different OU.
# Version 1.3: 08-07-2014
# - Added functionality for ProxyAddresses

# ERROR REPORTING ALL
Set-StrictMode -Version latest

#----------------------------------------------------------
# LOAD ASSEMBLIES AND MODULES
#----------------------------------------------------------
Try
{
  Import-Module ActiveDirectory -ErrorAction Stop
}
Catch
{
  Write-Host "[ERROR]`t ActiveDirectory Module couldn't be loaded. Script will stop!"
  Exit 1
}

#----------------------------------------------------------
#STATIC VARIABLES
#----------------------------------------------------------
$path     = Split-Path -parent $MyInvocation.MyCommand.Definition
$newpath  = $path + "\import_create_ad_users.csv"
$log      = $path + "\create_ad_users.log"
$date     = Get-Date
$addn     = (Get-ADDomain).DistinguishedName
$dnsroot  = (Get-ADDomain).DNSRoot
$i        = 1

#----------------------------------------------------------
#START FUNCTIONS
#----------------------------------------------------------
Function Start-Commands
{
  Create-Folders
 
}


Function Create-Folders {
write-host ("------------------------- Create-Folders------------------------")
    Import-CSV $newpath | ForEach-Object {
        If (($_.Implement.ToLower()) -eq "yes"){
            New-Item ($_.HomeDirectory  + $_.Initials.substring(0,1).ToLower() + $_.lastname.ToLower()) -Type Directory > null
            Create-User
            set-AccessRights
        }
        
    }
    
}

Function Create-User
{
write-host ("------------------------- Create-User------------------------")

      If (($_.GivenName -eq "") -Or ($_.LastName -eq "") -Or ($_.Initials -eq ""))
      {
        Write-Host "[ERROR]`t Please provide valid GivenName, LastName and Initials. Processing skipped for line $($i)`r`n"
        "[ERROR]`t Please provide valid GivenName, LastName and Initials. Processing skipped for line $($i)`r`n" | Out-File $log -append
      }
      Else
      {
        # Set the target OU
        $location = $_.TargetOU + ",$($addn)"

        # Set the Enabled and PasswordNeverExpires properties
        If (($_.Enabled.ToLower()) -eq "true") { $enabled = $True } Else { $enabled = $False }
        If (($_.PasswordNeverExpires.ToLower()) -eq "true") { $expires = $True } Else { $expires = $False }

        # A check for the country, because those were full names and need 
        # to be land codes in order for AD to accept them. I used Netherlands 
        # as example
        #If($_.Country -eq "Netherlands")
        #{
         # $_.Country = "NL"
        #}
        #Else
        #{
          $_.Country = "NO"
        #}
        # Replace dots / points (.) in names, because AD will error when a 
        # name ends with a dot (and it looks cleaner as well)
        $replace = $_.Lastname.Replace(".","")
        If($replace.length -lt 20)
        {
          $lastname = $replace
        }
        Else
        {
          $lastname = $replace.substring(0,4)
        }
        # Create sAMAccountName according to this 'naming convention':
        # <FirstLetterInitials><FirstFourLettersLastName> for example
        # htehp
        $sam = $_.Initials.substring(0,1).ToLower() + $lastname.ToLower()
        Try   { $exists = Get-ADUser -LDAPFilter "(sAMAccountName=$sam)" }
        Catch { }
        If(!$exists)
        {
          # Set all variables according to the table names in the Excel 
          # sheet / import CSV. The names can differ in every project, but 
          # if the names change, make sure to change it below as well.
          $setpass = ConvertTo-SecureString -AsPlainText $_.Password -force

          Try
          {
            Write-Host "[INFO]`t Creating user : $($sam)"
            "[INFO]`t Creating user : $($sam)" | Out-File $log -append
            New-ADUser $sam -GivenName $_.GivenName -Initials $_.Initials `
            -Surname $_.LastName -DisplayName ($_.LastName + ","  + $_.GivenName) `
            -EmailAddress $_.Mail `
            -StreetAddress $_.StreetAddress -City $_.City `
            -PostalCode $_.PostalCode -Country $_.Country -UserPrincipalName ($sam + "@" + $dnsroot) `
            -Company $_.Company `
            -homeDirectory ($_.HomeDirectory + $sam) `
            -homeDrive $_.HomeDrive `
            -AccountPassword $setpass `
            -Enabled $enabled -PasswordNeverExpires $expires
            Write-Host "[INFO]`t Created new user : $($sam)"
            "[INFO]`t Created new user : $($sam)" | Out-File $log -append
     
            $dn = (Get-ADUser $sam).DistinguishedName
            
            # Move the user to the OU ($location) you set above. If you don't
            # want to move the user(s) and just create them in the global Users
            # OU, comment the string below
            If ([adsi]::Exists("LDAP://$($location)"))
            {
              Move-ADObject -Identity $dn -TargetPath $location
              Write-Host "[INFO]`t User $sam moved to target OU : $($location)"
              "[INFO]`t User $sam moved to target OU : $($location)" | Out-File $log -append
            }
            Else
            {
              Write-Host "[ERROR]`t Targeted OU couldn't be found. Newly created user wasn't moved!"
              "[ERROR]`t Targeted OU couldn't be found. Newly created user wasn't moved!" | Out-File $log -append
            }
       
            # Rename the object to a good looking name (otherwise you see
            # the 'ugly' shortened sAMAccountNames as a name in AD. This
            # can't be set right away (as sAMAccountName) due to the 20
            # character restriction
            $newdn = (Get-ADUser $sam).DistinguishedName
            Rename-ADObject -Identity $newdn -NewName ($_.GivenName + " " + $_.LastName)
            Write-Host "[INFO]`t Renamed $($sam) to $($_.GivenName) $($_.LastName)`r`n"
            "[INFO]`t Renamed $($sam) to $($_.GivenName) $($_.LastName)`r`n" | Out-File $log -append
          }
          Catch
          {
            Write-Host "[ERROR]`t Oops, something went wrong: $($_.Exception.Message)`r`n"
          }
        }
        Else
        {
          Write-Host "[SKIP]`t User $($sam) ($($_.GivenName) $($_.LastName)) already exists or returned an error!`r`n"
          "[SKIP]`t User $($sam) ($($_.GivenName) $($_.LastName)) already exists or returned an error!" | Out-File $log -append
        }
      }
    }

    


function set-AccessRights {
write-host ("-------------------------set-AccessRights------------------------")
    $homefolder = ($_.HomeDirectory  + $_.Initials.substring(0,1).ToLower() + $_.lastname.ToLower())
    $homefolderACL = get-acl $homefolder
    $user = ($_.Initials.substring(0,1).ToLower() + $_.lastname.ToLower())
    
    $FilesystemRights = [System.Security.AccessControl.FileSystemRights]"FullControl"
    $AccessControlType = [System.Security.AccessControl.AccessControlType]"Allow"
    $InheritanceFlags = [System.Security.AccessControl.InheritanceFlags]"ContainerInherit,ObjectInherit"
    $PropagationFlags = [System.Security.AccessControl.PropagationFlags]"InheritOnly"
    $IdentityReference = $user

    $FileSystemAccessRules = New-Object System.Security.AccessControl.FileSystemAccessRule($IdentityReference,$FilesystemRights,$InheritanceFlags,$PropagationFlags,$AccessControlType)
    $homefolderACL.AddAccessRule($FileSystemAccessRules)
    Set-Acl $homefolder $homefolderACL

    
}


Write-Host "STARTED SCRIPT`r`n"
Start-Commands
Write-Host "STOPPED SCRIPT"