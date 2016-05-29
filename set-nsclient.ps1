param(
	[string]$servers,
    [string]$username,
    [switch]$namelog    
)


$filepath = $servers
$user = $username
$credentials = Get-Credential($user)
$servere = Import-Csv $filepath | ForEach-Object {
    Write-Verbose "connected to $_.IP"
    
    $session = New-PSSession -ComputerName $_.IP -Credential $credentials
    $core_path = "C:\GitHub\check_cores.ps1"
    $sql_path = "C:\GitHub\get-SqlServerKeys.ps1"

    Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $core_path  -toSession $session
    Copy-Item -Destination 'C:\Program Files\NSClient++\scripts\' -path $sql_path -toSession $session
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


    Invoke-Command -Session $session -ScriptBlock {restart-service nscp}
}

