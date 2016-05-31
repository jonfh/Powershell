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
            DO {
                $logfile = "c:\github\servers-$i.log"
                $i++
             } while (Test-Path $logfile)
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
        $credentials = Get-Credential($user)
        $servere = Import-Csv $filepath | ForEach-Object {
            if($PSCmdlet.ShouldProcess($_.IP)) 
            {
                Write-Verbose "connecting to $_"
                if ($namelog) 
                {
                    "connecting to $_" | Out-File $logfile -Append
                } 
                try 
                {
                    $session = New-PSSession -ComputerName $_.IP -Credential $credentials -EA 'Stop'
                } catch 
                {
                    "Error: could not connect to server $_ " | Out-File $logfile -Append
                    Write-Verbose "ERROR: could not connect to server"
                }
                    Write-Verbose "connected to $_"
                    "connected to $_.IP" | Out-File $logfile -Append
                    $core_path = "C:\GitHub\check_cores.ps1"
                    $sql_path = "C:\GitHub\get-SqlServerKeys.ps1"
                    $serial_path="C:\GitHub\get-serialnumber.ps1"
                    Write-Verbose "Copying files to $_"
                    if ($namelog) {
                        "Copying $core_path to $_" | Out-File $logfile -Append
                    }
                    
                    try 
                    {
                        Write-Verbose "Copying $serial_path to $_"
                        Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $serial_path -toSession $session 
                        Write-Verbose "$serial_pathh copied to $_"
                        "$serial_path copied to $_" | Out-File $logfile -Append
                    } catch 
                    {
                        Write-Verbose "copying file $core_path to $_ failed"
                        "ERROR: copying file $core_path to $_ failed" | Out-File $logfile -Append
                    }
                     
                    try 
                    {
                        Write-Verbose "Copying $core_path to $_"
                        Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $core_path -toSession $session 
                        Write-Verbose "$core_path copied to $_"
                        "$core_path copied to $_" | Out-File $logfile -Append
                    } catch 
                    {
                        Write-Verbose "copying file $core_path to $_ failed"
                        "ERROR: copying file $core_path to $_ failed" | Out-File $logfile -Append
                    }
                    if ($namelog) {
                        "Copying $sql_path to $_" | Out-File $logfile -Append
                    }
                    try 
                    {
                        Write-Verbose "Copying $sql_path to $_.IP"
                        copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $sql_path -toSession $session 
                        Write-Verbose "$sql_path copied to $_"
                        "$sql_path copied to $_" | Out-File $logfile -Append
                    }catch 
                    {
                       Write-Verbose "copying file $sql_path to $_ failed"
                        "ERROR: copying file $sql_path to $_ failed" | Out-File $logfile -Append
                    }
                        Write-Verbose "editing NSClient.ini on $_"
                      if ($namelog) 
                      {
                        "editing NSClient.ini on $_" | Out-File $logfile -Append
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
                        Write-Verbose "ERROR: editing NSClient.ini on $_ failed"
                       "ERROR: editing NSClient.ini on $_ failed" | Out-File $logfile -Append
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
                         Write-Verbose "ERROR: editing NSClient.ini on $_ failed"
                       "ERROR: editing NSClient.ini on $_ failed" | Out-File $logfile -Append
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
                            }elseif ($_ -notmatch ('^' + [regex]::Escape('check_serial=cmd /c echo scripts\get-serialnumber.ps1; exit($lastexitcode) | powershell.exe  -command -'))) # If line doesn't matches regex
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
                        Write-Verbose "ERROR: editing NSClient.ini on $_ failed"
                       "ERROR: editing NSClient.ini on $_ failed" | Out-File $logfile -Append
                    }





                    try 
                    {
                        "restarting nscp" |Out-File $logfile -append
                        Write-Verbose "restarting nscp"
                        Invoke-Command -Session $session -ScriptBlock {restart-service nscp}
                    } catch 
                    {
                        "Error: restarting nscp on $_ failed" |Out-File $logfile -Append
                        Write-Verbose " restarting nscp on $_ failed"
                    }
          
            }
        }
    }
    END {}
}
#set-nsclient -servers C:\GitHub\server.csv -username Administrator -namelog -Verbose