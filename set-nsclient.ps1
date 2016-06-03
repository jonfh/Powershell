function set-nsclient {
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Medium')]
    param(
        
	    [string]$servers,
        [string]$username,
        [switch]$namelog    
    )

    BEGIN{
        if($namelog) 
        {
            Write-Verbose "Creating log file"
            $i =0
            $j =0
            
            DO {
                $errorLogFile="c:\github\Error-$j.log"
                $logfile = "c:\github\servers-$i.log"
                $i++
                $j++
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
        $servere = Import-Csv $filepath | ForEach-Object {
        $ip = $_ -replace "@{IP=",""
        $ip = $ip -replace "}",""
        $connectionFailure = "FALSE"
        
            if($PSCmdlet.ShouldProcess($_.IP)) 
            {
                Write-Verbose "connecting to $ip"
                if ($namelog) 
                {
                    "INFO: connecting to $ip" | Out-File $logfile -Append
                } 
                try 
                {
                    $session = New-PSSession -ComputerName $_.IP -Credential $credentials -EA 'Stop'
         
                    #if ($connectionFailure) {continue}
                    Write-Verbose "connected to $ip"
                    "INFO: connected to $ip" | Out-File $logfile -Append
                    $core_path = "C:\GitHub\check_cores.ps1"
                    $sql_path = "C:\GitHub\get-SqlServerKeys.ps1"
                    $serial_path="C:\GitHub\get-serialnumber.ps1"
                    $os_path="C:\GitHub\get-OS.ps1"
                    Write-Verbose "Copying files to $ip"
                    if ($namelog) {
                        "INFO: Copying $core_path to $ip" | Out-File $logfile -Append
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
                    if ($namelog) {
                        "INFO: Copying $sql_path to $ip" | Out-File $logfile -Append
                    }
                    try 
                    {
                        Write-Verbose "INFO: Copying $sql_path to $ip"
                        copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $sql_path -toSession $session 
                        Write-Verbose "INFO: $sql_path copied to $ip"
                        "INFO: $sql_path copied to $ip" | Out-File $logfile -Append
                    }catch 
                    {
                        Write-Verbose $date  "ERROR: copying file $sql_path to $ip failed"
                        "$date ERROR: copying file $sql_path to $ip failed" | Out-File $errorLogFile -Append
                        "$date ERROR: copying file $sql_path to $ip failed" | Out-File $logfile -Append
                    }
                    Write-Verbose "INFO: editing NSClient.ini on $ip"
                    if ($namelog) 
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
    END {}
}