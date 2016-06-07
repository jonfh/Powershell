function New-adadmin {
<#
.SYNOPSIS
.PARAMETER server
Name of server to copy to
.PARAMETER csv
CSV file with server to copy to
.PARAMETER filepath
path to the file that will be copied
.PARAMETER username 
The username one the remote server(s)
.PARAMETER namelog
switch for logging
.PARAMETER server
Name of server to copy to
.PARAMETER.PARAMETER filepath
filepath to CSV file with server to copy to
.PARAMETER newUserName
name of the user you wish to create on the server(s)
.Parameter Password
password of the user you wish to create on the server(s)
.DESCRIPTION
copy file to server or list of serveres
.EXAMPLE
create-adadmin -filepath c:\github\hosts.csv -username usadm -Verbose -newUserName usadm -namelog
.EXAMPLE
create-adadmin -server 10.8.200.89 -username administrator -Verbose -newUserName usadm -namelog
#>

    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Medium')]
     param(
        [string]$filepath,
        [string]$server,
        [string]$username,
        [Parameter(Mandatory=$true)][System.Security.SecureString] $Password,
        [string]$newUserName,
        [switch]$namelog  
          
    )
    BEGIN{
        if($namelog) 
        {
            Write-Verbose "Creating log file"
            $i =0
                        
            DO {
                $wrongPasswordLog="c:\wrongPasswordLog-$i.log"
                $alreadyexistslog="c:\alreadyexistslog-$i.log"
                $errorLogFile="c:\create-adadmin-Error-$i.log"
                $logfile = "c:\create-adadmin-servers-$i.log"
                $i++
              
             }
             while (Test-Path $logfile)
             Write-Verbose "logging in $logfile"
         }
         else 
         {
            Write-Verbose "logging off"
         }    
    }
   
    PROCESS {

        if ($server) 
        {           
   
            Write-Verbose "connecting to $server"                
            "INFO: connecting to $server" | Out-File $logfile -Append

            $credentials = Get-Credential($username)
            $session = New-PSSession -ComputerName $server -Credential $credentials       
            
            if ($session) 
            {
          
                Write-Verbose "connected to $server"
                Write-Verbose " Adding user $NewUserName to $server"
               
                "INFO: Adding user $NewUserName to $server" | Out-File $logfile -Append
                $result =  Invoke-Command -Session $session -Args $Password,$newUserName -ScriptBlock{param([Security.SecureString]$Password,$newUserName)  
                        Import-Module ActiveDirectory
                    try
                    {
                            $domainName = (Get-ADDomain).name
                            $OU = "Users"                            
                                New-ADUser `
                                    -Name "$newUserName" `
                                    -SamAccountName  "$newUserName" `
                                    -DisplayName "$newUserName" `
                                    -AccountPassword $Password `
                                    -ChangePasswordAtLogon $false  `
                                    -Enabled $true 
                                    Add-ADGroupMember "Domain Admins" "$newUserName";
                            Write-Verbose "INFO: Added user $NewUserName"       
                        } catch 
                        {                            
                            return "ERROR: adding user $newUserName to $env:COMPUTERNAME.$env:USERDNSDOMAIN failed: $_" 
                            
                        }
                    }
                   
                    Write-Verbose $result
                    if ($result) 
                    {
                        "$result  $server" | Out-File $logfile -Append
                        "$result  $server" | Out-File  $errorLogFile -Append
                        "$result  $server" | Out-File  $alreadyexistslog -Append
                        
                    }
                } else
                {
                        Write-Verbose "ERROR: could not connect to server $server $_"
                    "ERROR: could not connect to server $server $_"| Out-File $logfile -Append
                    "ERROR: could not connect to server $server $_"| Out-File  $errorLogFile -Append
                    "ERROR: could not connect to server $server $_"| Out-File  $wrongPasswordLog -Append
                }
             
        
        

        } elseif ($filepath) 
        {
           
                           
                $credentials = Get-Credential($username)
                $servere = Import-Csv $filepath | ForEach-Object {
                   
                    $session = New-PSSession -ComputerName $_.IP -Credential $credentials
                    if ($session) 
                    {
                 
                        Write-Verbose "connected to $_"
                        Write-Verbose " Adding user $NewUserName to $_"
                        "INFO: Adding user $NewUserName to $_" | Out-File $logfile -Append
         
                        $result =  Invoke-Command -Session $session  -Args $Password,$newUserName -ScriptBlock{param([Security.SecureString]$Password,$newUserName)  
                            Import-Module ActiveDirectory
                            try
                            {
                                $domainName = (Get-ADDomain).name
                                $OU = "Users"                                
                                    New-ADUser `
                                        -Name "$newUserName" `
                                        -SamAccountName  "$newUserName" `
                                        -DisplayName "$newUserName" `
                                        -AccountPassword $Password `
                                        -ChangePasswordAtLogon $false  `
                                        -Enabled $true 
                                        Add-ADGroupMember "Domain Admins" "$newUserName";
                                                                            
                                        Write-Verbose "INFO: Added user $NewUserName"       
                                } catch 
                                {   
                                    return "ERROR: adding user $newUserName to $env:COMPUTERNAME.$env:USERDNSDOMAIN failed: $_ " 
                            
                                }
                            }

                            Write-Verbose $result
                            if ($result) 
                            {
                                "$result  $_ " | Out-File $logfile -Append
                                "$result  $_" | Out-File  $errorLogFile -Append
                                 "$result  $_" | Out-File  $alreadyexistslog -Append

                            }

                     }
                     else
                     {
                        Write-Verbose "ERROR: could not connect to server $server $_"
                        "ERROR: could not connect to server $_"| Out-File $logfile -Append
                        "ERROR: could not connect to server $_"| Out-File  $errorLogFile -Append
                        "ERROR: could not connect to server $server $_"| Out-File  $wrongPasswordLog -Append
                     
                     }

                    }
             
            }
        }
    
    END{}
 }

