function set-nsclient {
<#
.SYNOPSIS
.PARAMETER server
Name of server to copy to
.PARAMETER serveres
CSV file with server to copy to
.PARAMETER username 
The username one the remote server(s)
.PARAMETER namelog
switch for logging
.PARAMETER scriptsfolder
path to folder that contains scripts to be copied
.DESCRIPTION
copy .ps1 scripts to server(s) with nsclient++, adding script to nsclient.ini
.EXAMPLE
set-nsclient -servers C:\GitHub\host.csv -username administrator -namelog -Verbose -scriptsfolder C:\GitHub\PowerShell
.EXAMPLE
set-nsclient -server 10.8.200.120 -username administrator -Infolog -Verbose -scriptsfolder C:\GitHub\PowerShell
#>
   
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Medium')]
    param(
        
	    [string]$servers,
        [string]$username,
        [string]$server,
        [string]$scriptsfolder,
        [switch]$infolog    
    )

    BEGIN{
        if($infolog) 
        {
            Write-Verbose "Creating log file"
            $i =0
                        
            DO {
             
                $errorLogFile="c:\github\Error-$i.log"
                $logfile = "c:\github\servers-$i.log"
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

    PROCESS{
        
        $filepath = $servers
        $user = $username
        $connectionFailures =0
        $credentials = Get-Credential($user)
        if ($server) 
        {
            
                try 
                {
                   Write-Verbose "connecting to $server"
                   if ($infolog) {
                        "INFO: connecting to $server" | Out-File $logfile -Append
                   }
                    
                    try 
                    {
                        $session = New-PSSession -ComputerName $server -Credential $credentials
         
                        Write-Verbose "connected to $server"
                        if ($infolog) {
                            "INFO: connected to $server" | Out-File $logfile -Append
                        }
                        $core_path = "$scriptsfolder\check_cores.ps1"
                        $sql_path = "$scriptsfolder\get-SqlServerKeys.ps1"
                        $serial_path="$scriptsfolder\get-serialnumber.ps1"
                        $os_path="$scriptsfolder\get-OS.ps1"
                        $teamviewer_path="$scriptsfolder\check-teamviewer.ps1"
                        $temperature_path="$scriptsfolder\get-CurrentTemperature.ps1"

                        Write-Verbose "Copying files to $server"
                        if ($infolog) {
                            "INFO: Copying $core_path to $server" | Out-File $logfile -Append
                        } 

                        try 
                        {
                            Write-Verbose "INFO: Copying $teamviewer_path to $server"
                            Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $teamviewer_path -toSession $session 
                            Write-Verbose "INFO: $teamviewer_path copied to $server"
                            if ($infolog) {
                                "INFO: $teamviewer_path copied to $server" | Out-File $logfile -Append
                            }
                        } catch 
                        {
                            Write-Verbose $date  "ERROR: copying file $teamviewer_path to $server failed"
                             if ($infolog) {
                                "$date ERROR: copying file $teamviewer_path to $server failed" | Out-File $errorLogFile -Append
                             }
                             if($errorLogFile) {
                                "$date ERROR: copying file $teamviewer_path to $server failed" | Out-File $logfile -Append
                             }
                        }

                        try 
                        {
                            Write-Verbose "INFO: Copying $temperature_path to $server"
                            Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $temperature_path -toSession $session 
                            Write-Verbose "INFO: $temperature_path copied to $server"
                            if ($infolog) {
                                "INFO: $temperature_path copied to $server" | Out-File $logfile -Append
                            }
                        } catch 
                        {
                            Write-Verbose $date  "ERROR: copying file $temperature_path to $server failed"
                            if ($errorLogFile) {
                                "$date ERROR: copying file $temperature_path to $server failed" | Out-File $errorLogFile -Append
                            }
                            if ($infolog) {
                                "$date ERROR: copying file $temperature_path to $server failed" | Out-File $logfile -Append
                            }
                        }


                        try 
                        {
                            Write-Verbose "INFO: Copying $os_path to $server"
                            Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $os_path -toSession $session 
                            Write-Verbose "INFO: $os_path copied to $server"
                            if ($infolog) {
                                "INFO: $os_path copied to $server" | Out-File $logfile -Append
                            }
                        } catch 
                        {
                            Write-Verbose $date  "ERROR: copying file $os_path to $server failed"
                            if ($errorLogFile) {
                                "$date ERROR: copying file $os_path to $server failed" | Out-File $errorLogFile -Append
                            }
                            if ($infolog) {
                                "$date ERROR: copying file $os_path to $server failed" | Out-File $logfile -Append
                            }
                        }
                    
                        try 
                        {
                            Write-Verbose "INFO: Copying $serial_path to $server"
                            Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $serial_path -toSession $session 
                            Write-Verbose "INFO: $serial_path copied to $server"
                            if ($infolog)  {
                                "INFO: $serial_path copied to $server" | Out-File $logfile -Append
                             }
                        } catch 
                        {
                            Write-Verbose $date  "ERROR: copying file $serial_path to $server failed"
                            if ($errorLogFile) {
                                "$date ERROR: copying file $serial_path to $server failed" | Out-File $errorLogFile -Append
                            }
                            if ($infolog) {
                                "$date ERROR: copying file $serial_path to $server failed" | Out-File $logfile -Append
                            }
                        }
                     
                        try 
                        {
                            Write-Verbose "INFO: Copying $core_path to $server"
                            Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $core_path -toSession $session 
                            Write-Verbose "INFO: $core_path copied to $server"
                            if ($infolog) {
                                "INFO: $core_path copied to $server" | Out-File $logfile -Append
                            }
                        } catch 
                        {
                            Write-Verbose $date  "ERROR: copying file $core_path to $server failed"
                            if ($errorLogFile) {
                                "$date ERROR: copying file $core_path to $server failed" | Out-File $errorLogFile -Append
                            }
                            if ($infolog) {
                                "$date ERROR: copying file $core_path to $server failed" | Out-File $logfile -Append
                            }
                        }

                        try 
                        {
                            Write-Verbose "INFO: Copying $sql_path to $server"
                            copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $sql_path -toSession $session 
                            Write-Verbose "INFO: $sql_path copied to $server"
                            if ($infolog) {
                                "INFO: $sql_path copied to $server" | Out-File $logfile -Append
                            }
                        }catch 
                        {
                            Write-Verbose $date  "ERROR: copying file $sql_path to $server failed"
                            if ($errorLogFile) {
                                "$date ERROR: copying file $sql_path to $server failed" | Out-File $errorLogFile -Append
                            }
                            if ($infolog) {
                                "$date ERROR: copying file $sql_path to $server failed" | Out-File $logfile -Append
                            }
                        }
                       
                        try 
                        { 
                            Write-Verbose "INFO: Setting ExecutionPolicy to remotesigned"
                            if ($infolog) {
                                "INFO: Setting ExecutionPolicy to remotesigned" | Out-File $logfile -Append
                            }
                            Invoke-Command -Session $session -ScriptBlock{Set-ExecutionPolicy remotesigned}
                        }
                        catch
                        {
                            Write-Verbose "ERROR: failed to set executionPolicy on $server"
                            if ($errorLogFile) {
                                "ERROR: failed to set executionPolicy on $server" |Out-File $errorLogFile -Append
                            }
                            if ($logfile) {
                                "ERROR: failed to set executionPolicy on $server" |Out-File $logfile -Append
                            }
                        }

                        Write-Verbose "INFO: editing NSClient.ini on $server"
                        if ($infolog) 
                        {
                            "INFO: editing NSClient.ini on $server" | Out-File $logfile -Append
                        }
                        
                        try 
                        {
                        
                            Invoke-Command -Session $session -ScriptBlock {$File = 'c:\program files\nsclient++\nsclient.ini'
                                        # Process lines of text from file and assign result to $NewContent variable
                            $NewContent = Get-Content -Path $File |
                            ForEach-Object {
                                # If line matches regex
                                if($_ -match ('^' + [regex]::Escape('[/settings/external scripts/scripts]')))
                                {
                                    # Output this line to pipeline
                                    $_

                                    # And output additional line right after it
                                    'check_teamviewer=cmd /c echo scripts\check-teamviewer.ps1; exit($lastexitcode) | powershell.exe  -command -'
                                }elseif ($_ -notmatch ('^' + [regex]::Escape('check_teamviewer=cmd /c echo scripts\check-teamviewer.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
                                {
                                    # Output this line to pipeline
                                    $_
                                }
                            }

                            # Write content of $NewContent varibale back to file
                            $NewContent | Out-File -FilePath 'c:\program files\nsclient++\nsclient.ini' -Encoding Default -Force
                            } 
                        Write-Verbose "INFO: Added check_teamviewer to nsclient.ini"
                        } catch
                        { 
                        
                            Write-Verbose $date  "ERROR: editing NSClient.ini on $server failed"
                            if ($logfile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $logfile -Append
                            }
                            if ($errorLogFile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $errorLogFile -Append
                            }
                           
                        }

                         
                        try 
                        {
                            Invoke-Command -Session $session -ScriptBlock {$File = 'c:\program files\nsclient++\nsclient.ini'
                                        # Process lines of text from file and assign result to $NewContent variable
                            $NewContent = Get-Content -Path $File |
                            ForEach-Object {
                                # If line matches regex
                                if($_ -match ('^' + [regex]::Escape('[/settings/external scripts/scripts]')))
                                {
                                    # Output this line to pipeline
                                    $_

                                    # And output additional line right after it
                                    'check_temp=cmd /c echo scripts\get-CurrentTemperature.ps1; exit($lastexitcode) | powershell.exe  -command -'
                                }elseif ($_ -notmatch ('^' + [regex]::Escape('check_temp=cmd /c echo scripts\get-CurrentTemperature.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
                                {
                                    # Output this line to pipeline
                                    $_
                                }
                            }

                            # Write content of $NewContent varibale back to file
                            $NewContent | Out-File -FilePath 'c:\program files\nsclient++\nsclient.ini' -Encoding Default -Force
                            }
                         Write-Verbose "INFO: Added check_temp to nsclient.ini"    
                        
                        } catch
                        { 
                        
                            Write-Verbose $date  "ERROR: editing NSClient.ini on $server failed"
                            if ($logfile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $logfile -Append
                            }
                            if ($errorLogFile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $errorLogFile -Append
                            }
                           
                        }
                        
               

                        try 
                        {
                            Invoke-Command -Session $session -ScriptBlock {$File = 'c:\program files\nsclient++\nsclient.ini'
                                        # Process lines of text from file and assign result to $NewContent variable
                            $NewContent = Get-Content -Path $File |
                            ForEach-Object {
                                # If line matches regex
                                if($_ -match ('^' + [regex]::Escape('[/settings/external scripts/scripts]')))
                                {
                                    # Output this line to pipeline
                                    $_

                                    # And output additional line right after it
                                    'check_os=cmd /c echo scripts\get-os.ps1; exit($lastexitcode) | powershell.exe  -command -'
                                }elseif ($_ -notmatch ('^' + [regex]::Escape('check_os=cmd /c echo scripts\get-os.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
                                {
                                    # Output this line to pipeline
                                    $_
                                }
                            }

                            # Write content of $NewContent varibale back to file
                            $NewContent | Out-File -FilePath 'c:\program files\nsclient++\nsclient.ini' -Encoding Default -Force
                            }
                        Write-Verbose "INFO: Added check_os"
                        } catch
                        { 
                        
                            Write-Verbose $date  "ERROR: editing NSClient.ini on $server failed"
                            if ($logfile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $logfile -Append
                            }
                            if ($errorLogFile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $errorLogFile -Append
                            }
                           
                        }


             
                        try 
                        {
                            Invoke-Command -Session $session -ScriptBlock {$File = 'c:\program files\nsclient++\nsclient.ini'
                                        # Process lines of text from file and assign result to $NewContent variable
                            $NewContent = Get-Content -Path $File |
                            ForEach-Object {
                                # If line matches regex
                                if($_ -match ('^' + [regex]::Escape('[/settings/external scripts/scripts]')))
                                {
                                    # Output this line to pipeline
                                    $_

                                    # And output additional line right after it
                                    'check_cores=cmd /c echo scripts\check_cores.ps1; exit($lastexitcode) | powershell.exe  -command -'
                                }elseif ($_ -notmatch ('^' + [regex]::Escape('check_cores=cmd /c echo scripts\check_cores.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
                                {
                                    # Output this line to pipeline
                                    $_
                                }
                            }

                            # Write content of $NewContent varibale back to file
                            $NewContent | Out-File -FilePath 'c:\program files\nsclient++\nsclient.ini' -Encoding Default -Force
                            }
                        Write-Verbose "INFO: Added check_cores"
                        } catch
                            { 
                        
                            Write-Verbose $date  "ERROR: editing NSClient.ini on $server failed"
                            if ($logfile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $logfile -Append
                            }
                            if ($errorLogFile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $errorLogFile -Append
                            }
                           
                        }

                        try {
                            Invoke-Command -Session $session -ScriptBlock {$File = 'c:\program files\nsclient++\nsclient.ini'
                                # Process lines of text from file and assign result to $NewContent variable
                                $NewContent = Get-Content -Path $File |
                                ForEach-Object {
                                    # If line matches regex
                                    if($_ -match ('^' + [regex]::Escape('[/settings/external scripts/scripts]')))
                                    {
                                        # Output this line to pipeline
                                        $_

                                        # And output additional line right after it
                                        'check_sql=cmd /c echo scripts\Get-SqlServerKeys.ps1; exit($lastexitcode) | powershell.exe  -command -'
                                    }
                                    elseif ($_ -notmatch ('^' + [regex]::Escape('check_sql=cmd /c echo scripts\Get-SqlServerKeys.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
                                    {
                                        # Output this line to pipeline
                                        $_
                                    }
                                }

                                # Write content of $NewContent varibale back to file
                                $NewContent | Out-File -FilePath 'c:\program files\nsclient++\nsclient.ini' -Encoding Default -Force
                            } 
                        Write-Verbose "INFO: Added check_sql"

                        } catch
                        { 
                        
                            Write-Verbose $date  "ERROR: editing NSClient.ini on $server failed"
                            if ($logfile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $logfile -Append
                            }
                            if ($errorLogFile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $errorLogFile -Append
                            }
                           
                        }

                        try 
                        {
                            Invoke-Command -Session $session -ScriptBlock {$File = 'c:\program files\nsclient++\nsclient.ini'
                                        # Process lines of text from file and assign result to $NewContent variable
                            $NewContent = Get-Content -Path $File |
                            ForEach-Object {
                                # If line matches regex
                                if($_ -match ('^' + [regex]::Escape('[/settings/external scripts/scripts]')))
                                {
                                    # Output this line to pipeline
                                    $_

                                    # And output additional line right after it
                                    'check_serial=cmd /c echo scripts\get-serialnumber.ps1; exit($lastexitcode) | powershell.exe  -command -'
                                }elseif ($_ -notmatch ('^' + [regex]::Escape('check_serial=cmd /c echo scripts\get-serialnumber.ps1; exit($lastexitcode) | powershell.exe  -command -')) -and $_ -notmatch ('^' + [regex]::Escape('check_serial=cmd /c echo scripts\check_serialnumber.ps1; exit($lastexitcode) | powershell.exe  -command -')) -and $_ -notmatch ('^' + [regex]::Escape('check_cores=cmd /c echo scripts\check_serialnumber.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
                                {
                                    # Output this line to pipeline
                                    $_
                                }
                            }

                            # Write content of $NewContent varibale back to file
                            $NewContent | Out-File -FilePath 'c:\program files\nsclient++\nsclient.ini' -Encoding Default -Force
                            }
                        Write-Verbose "INFO: Added check_serial"
                        } catch
                        { 
                        
                            Write-Verbose $date  "ERROR: editing NSClient.ini on $server failed"
                            if ($logfile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $logfile -Append
                            }
                            if ($errorLogFile) {
                                "$date ERROR: editing NSClient.ini on $server failed" | Out-File $errorLogFile -Append
                            }
                           
                        }


                        try 
                        {
                            if ($logfile) {
                                "INFO: restarting nscp" |Out-File $logfile -append
                            }
                            Write-Verbose "INFO: restarting nscp"
                            Invoke-Command -Session $session -ScriptBlock {restart-service nscp}
                        } catch 
                        {
                            if ($logfile) {
                                "Error: restarting nscp on $server failed" |Out-File $logfile -Append
                            }
                            if ($errorLogFile) {
                                "Error: restarting nscp on $server failed" |Out-File $errorLogFile -Append
                            }
                            Write-Verbose "ERROR restarting nscp on $server failed"
                        }
                    } catch                         
                    {                                     
                        $date = (get-date -f dd-MM-HH:mm:ss) 
                        Write-Verbose "$date"
                        "$date Error: could not connect to server $server count $connectionFailures" | Out-File $errorLogFile -Append
                        "$date Error: could not connect to server $server count $connectionFailures" | Out-File $logfile -Append
                        # continue
                   
                    }



                }
                catch 
                {
                    
                }
                    
            } else 
                
            {
            
                Import-Csv $filepath | ForEach-Object {
                $ip = $_ -replace "@{IP=",""
                $ip = $ip -replace "}",""
                $connectionFailure = "FALSE"
        
                if($PSCmdlet.ShouldProcess($_.IP)) 
                {
                    Write-Verbose "connecting to $ip"
                    if ($infolog) 
                    {
                        "INFO: connecting to $ip" | Out-File $logfile -Append
                    } 
                    
                    try 
                    {
                        $session = New-PSSession -ComputerName $_.IP -Credential $credentials -EA 'Stop'
         
                        #if ($connectionFailure) {continue}
                        Write-Verbose "connected to $ip"
                        "INFO: connected to $ip" | Out-File $logfile -Append
                        $core_path = "$scriptsfolder\check_cores.ps1"
                        $sql_path = "$scriptsfolder\get-SqlServerKeys.ps1"
                        $serial_path="$scriptsfolder\get-serialnumber.ps1"
                        $os_path="$scriptsfolder\get-OS.ps1"
                        $teamviewer_path="$scriptsfolder\check-teamviewer.ps1"
                        Write-Verbose "Copying files to $ip"
                        if ($infolog) {
                            "INFO: Copying $core_path to $ip" | Out-File $logfile -Append
                        }

                         
                        try 
                        {
                            Write-Verbose "INFO: Copying $teamviewer_path to $ip"
                            Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $teamviewer_path -toSession $session 
                            Write-Verbose "INFO: $teamviewer_path copied to $ip"
                            "INFO: $teamviewer_path copied to $ip" | Out-File $logfile -Append
                        } catch 
                        {
                         
                            Write-Verbose $date  "ERROR: copying file $teamviewer_path to $ip failed"
                            "$date ERROR: copying file $teamviewer_path to $ip failed" | Out-File $errorLogFile -Append
                            "$date ERROR: copying file $teamviewer_path to $ip failed" | Out-File $logfile -Append
                        }
                        
                        try 
                        {
                            Write-Verbose "INFO: Copying $os_path to $ip"
                            Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $os_path -toSession $session 
                            Write-Verbose "INFO: $os_path copied to $ip"
                            "INFO: $os_path copied to $ip" | Out-File $logfile -Append
                        } catch 
                        {
                            Write-Verbose $date  "ERROR: copying file $core_path to $ip failed"
                            "$date ERROR: copying file $core_path to $ip failed" | Out-File $errorLogFile -Append
                            "$date ERROR: copying file $core_path to $ip failed" | Out-File $logfile -Append
                        }
                    
                        try 
                        {
                            Write-Verbose "INFO: Copying $serial_path to $ip"
                            Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $serial_path -toSession $session 
                            Write-Verbose "INFO: $serial_path copied to $ip"
                            "INFO: $serial_path copied to $ip" | Out-File $logfile -Append
                        } catch 
                        {
                            Write-Verbose $date  "ERROR: copying file $core_path to $ip failed"
                            "$date ERROR: copying file $core_path to $ip failed" | Out-File $errorLogFile -Append
                            "$date ERROR: copying file $core_path to $ip failed" | Out-File $logfile -Append
                        }
                     
                        try 
                        {
                            Write-Verbose "INFO: Copying $core_path to $ip"
                            Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $core_path -toSession $session 
                            Write-Verbose "INFO: $core_path copied to $ip"
                            "INFO: $core_path copied to $ip" | Out-File $logfile -Append
                        } catch 
                        {
                            Write-Verbose $date  "ERROR: copying file $core_path to $ip failed"
                            "$date ERROR: copying file $core_path to $ip failed" | Out-File $errorLogFile -Append
                            "$date ERROR: copying file $core_path to $ip failed" | Out-File $logfile -Append
                        }
                        if ($infolog) {
                            "INFO: Copying $sql_path to $ip" | Out-File $logfile -Append
                        }
                        try 
                        {
                            Write-Verbose "INFO: Copying $sql_path to $ip"
                            copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $sql_path -toSession $session 
                            Write-Verbose "INFO: $sql_path copied to $ip"
                            if ($infolog) {
                                "INFO: $sql_path copied to $ip" | Out-File $logfile -Append
                            }
                        }catch 
                        {
                            Write-Verbose $date  "ERROR: copying file $sql_path to $ip failed"
                            if ($infolog) {
                                "$date ERROR: copying file $sql_path to $ip failed" | Out-File $logfile -Append
                            }
                            if ($errorLogFile) {
                                "$date ERROR: copying file $sql_path to $ip failed" | Out-File $errorLogFile -Append
                            }
                            
                        }
                        Write-Verbose "INFO: editing NSClient.ini on $ip"
                        if ($infolog) 
                        {
                            "INFO: editing NSClient.ini on $ip" | Out-File $logfile -Append
                        }
                       
                        try 
                        { 
                            Invoke-Command -Session $session -ScriptBlock{Set-ExecutionPolicy remotesigned}
                        }
                        catch
                        {
                        
                        }

                        
                        try 
                        {
                            Invoke-Command -Session $session -ScriptBlock {$File = 'c:\program files\nsclient++\nsclient.ini'
                                # Process lines of text from file and assign result to $NewContent variable
                                $NewContent = Get-Content -Path $File |
                                ForEach-Object {
                                    # If line matches regex
                                    if($_ -match ('^' + [regex]::Escape('[/settings/external scripts/scripts]')))
                                    {
                                        # Output this line to pipeline
                                        $_

                                        # And output additional line right after it
                                        'check_teamviewer=cmd /c echo scripts\check-teamviewer.ps1; exit($lastexitcode) | powershell.exe  -command -'
                                    }elseif ($_ -notmatch ('^' + [regex]::Escape('check_teamviewer.ps1 /c echo scripts\check-teamviewer.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
                                    {
                                        # Output this line to pipeline
                                        $_
                                    }
                                }

                                # Write content of $NewContent varibale back to file
                                $NewContent | Out-File -FilePath 'c:\program files\nsclient++\nsclient.ini' -Encoding Default -Force
                            } -EA 'Stop'
                        } catch
                        { 
                        
                            Write-Verbose $date  "ERROR: editing NSClient.ini on $_ failed"
                            "$date ERROR: editing NSClient.ini on $_ failed" | Out-File $errorLogFile -Append
                            "$date ERROR: editing NSClient.ini on $_ failed" | Out-File $logfile -Append
                        }





                        try 
                        {
                            Invoke-Command -Session $session -ScriptBlock {$File = 'c:\program files\nsclient++\nsclient.ini'
                                        # Process lines of text from file and assign result to $NewContent variable
                                $NewContent = Get-Content -Path $File |
                                ForEach-Object {
                                    # If line matches regex
                                    if($_ -match ('^' + [regex]::Escape('[/settings/external scripts/scripts]')))
                                    {
                                        # Output this line to pipeline
                                        $_

                                        # And output additional line right after it
                                        'check_os=cmd /c echo scripts\get-os.ps1; exit($lastexitcode) | powershell.exe  -command -'
                                    }elseif ($_ -notmatch ('^' + [regex]::Escape('check_os=cmd /c echo scripts\get-os.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
                                    {
                                        # Output this line to pipeline
                                        $_
                                    }
                                }

                                # Write content of $NewContent varibale back to file
                                $NewContent | Out-File -FilePath 'c:\program files\nsclient++\nsclient.ini' -Encoding Default -Force
                                } -EA 'Stop'
                        } catch
                        { 
                        
                            Write-Verbose $date  "ERROR: editing NSClient.ini on $ip failed"
                            "$date ERROR: editing NSClient.ini on $ip failed" | Out-File $errorLogFile -Append
                            "$date ERROR: editing NSClient.ini on $ip failed" | Out-File $logfile -Append
                        }


             
                        try 
                        {
                            Invoke-Command -Session $session -ScriptBlock {$File = 'c:\program files\nsclient++\nsclient.ini'
                                 # Process lines of text from file and assign result to $NewContent variable
                                $NewContent = Get-Content -Path $File |
                                ForEach-Object {
                                    # If line matches regex
                                    if($_ -match ('^' + [regex]::Escape('[/settings/external scripts/scripts]')))
                                    {
                                        # Output this line to pipeline
                                        $_

                                        # And output additional line right after it
                                        'check_cores=cmd /c echo scripts\check_cores.ps1; exit($lastexitcode) | powershell.exe  -command -'
                                    }elseif ($_ -notmatch ('^' + [regex]::Escape('check_cores=cmd /c echo scripts\check_cores.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
                                    {
                                        # Output this line to pipeline
                                        $_
                                    }
                                }

                                # Write content of $NewContent varibale back to file
                                $NewContent | Out-File -FilePath 'c:\program files\nsclient++\nsclient.ini' -Encoding Default -Force
                            } -EA 'Stop'
                        } catch
                        { 
                        
                            Write-Verbose $date  "ERROR: editing NSClient.ini on $ip failed"
                            "$date ERROR: editing NSClient.ini on $ip failed" | Out-File $errorLogFile -Append
                        }

                        try {
                            Invoke-Command -Session $session -ScriptBlock {$File = 'c:\program files\nsclient++\nsclient.ini'
                                # Process lines of text from file and assign result to $NewContent variable
                                $NewContent = Get-Content -Path $File |
                                ForEach-Object {
                                    # If line matches regex
                                    if($_ -match ('^' + [regex]::Escape('[/settings/external scripts/scripts]')))
                                    {
                                        # Output this line to pipeline
                                        $_

                                        # And output additional line right after it
                                        'check_sql=cmd /c echo scripts\Get-SqlServerKeys.ps1; exit($lastexitcode) | powershell.exe  -command -'
                                    }
                                    elseif ($_ -notmatch ('^' + [regex]::Escape('check_sql=cmd /c echo scripts\Get-SqlServerKeys.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
                                    {
                                        # Output this line to pipeline
                                        $_
                                    }
                                }

                                # Write content of $NewContent varibale back to file
                                $NewContent | Out-File -FilePath 'c:\program files\nsclient++\nsclient.ini' -Encoding Default -Force
                            } -EA 'Stop'
                        } catch
                        {
                                Write-Verbose $date  "ERROR: editing NSClient.ini on $ip failed"
                            "$date ERROR: editing NSClient.ini on $ip failed" | Out-File $errorLogFile -Append
                            "$date ERROR: editing NSClient.ini on $ip failed" | Out-File $logfile -Append
                        }

                        try 
                        {
                            Invoke-Command -Session $session -ScriptBlock {$File = 'c:\program files\nsclient++\nsclient.ini'
                                        # Process lines of text from file and assign result to $NewContent variable
                                $NewContent = Get-Content -Path $File |
                                ForEach-Object {
                                    # If line matches regex
                                    if($_ -match ('^' + [regex]::Escape('[/settings/external scripts/scripts]')))
                                    {
                                        # Output this line to pipeline
                                        $_

                                        # And output additional line right after it
                                        'check_serial=cmd /c echo scripts\get-serialnumber.ps1; exit($lastexitcode) | powershell.exe  -command -'
                                    }elseif ($_ -notmatch ('^' + [regex]::Escape('check_serial=cmd /c echo scripts\get-serialnumber.ps1; exit($lastexitcode) | powershell.exe  -command -')) -and $_ -notmatch ('^' + [regex]::Escape('check_serial=cmd /c echo scripts\check_serialnumber.ps1; exit($lastexitcode) | powershell.exe  -command -')) -and $_ -notmatch ('^' + [regex]::Escape('check_cores=cmd /c echo scripts\check_serialnumber.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
                                    {
                                        # Output this line to pipeline
                                        $_
                                    }
                                }

                                # Write content of $NewContent varibale back to file
                                $NewContent | Out-File -FilePath 'c:\program files\nsclient++\nsclient.ini' -Encoding Default -Force
                            } -EA 'Stop'
                        } catch
                        { 
                            Write-Verbose $date  "ERROR: editing NSClient.ini on $ip failed"
                            "$date ERROR: editing NSClient.ini on $ip failed" | Out-File $errorLogFile -Append
                            "$date ERROR: editing NSClient.ini on $ip failed" | Out-File $logfile -Append
                        }





                        try 
                        {
                            "INFO: restarting nscp" |Out-File $logfile -append
                            Write-Verbose "INFO: restarting nscp"
                            Invoke-Command -Session $session -ScriptBlock {restart-service nscp}
                        } catch 
                        {
                            "Error: restarting nscp on $ip failed" |Out-File $errorLogFile -Append
                            "Error: restarting nscp on $ip failed" |Out-File $logfile -Append
                            Write-Verbose "ERROR restarting nscp on $ip failed"
                        }
                    } catch 
                    {
                        $connectionFailure = "TRUE"
                        $connectionFailures++                 
                        $date = (get-date -f dd-MM-HH:mm:ss) 
                        Write-Verbose "$date ERROR: could not connect to server $ip"
                        "$date Error: could not connect to server $ip count $connectionFailures" | Out-File $errorLogFile -Append
                        "$date Error: could not connect to server $ip count $connectionFailures" | Out-File $logfile -Append
                        # continue
                   
                    }
                }
          
            }
        }
    }
    END {}

}