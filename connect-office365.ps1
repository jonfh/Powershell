function connect-office365
<#
.SYNOPSIS
.DESCRIPTION
connect to office365 
.PARAMETER $username
username for administrator account
.EXAMPLE
connect-office365 -username admin@unisoft.no
#> 
{
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Medium')]
    param(
        [string]$username,
        [switch]$infolog    
    )
    BEGIN {}
    
    PROCESS {    
        
        try
        {
            $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $username -Authentication Basic -AllowRedirection -Name "Office365"    
        }catch 
        {
                Write-Verbose "ERROR: could not create session $session"
        }
        if ($Session)
        {
            try {
                Import-PSSession $Session    
            } catch {
                Write-Verbose "ERROR: could not import session $session"
            }
        }
    }
    END {}
}


function connect-MSOnline {
     param(
        [string]$username,
        [switch]$infolog    
    )     
    BEGIN{}
    PROCESS {
        $credential = Get-Credential $username
        Import-Module MSOnline
        Connect-MsolService -Credential $credential

    }
    END{}
}

function connect-exchangeOnline {
    param(
        [string]$username
    )
    $credential =Get-Credential $username
    $ExchangeSession = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://outlook.office365.com/powershell-liveid/" -Credential $credential -Authentication "Basic" -AllowRedirection -Name "exchangeOnline"
    Import-PSSession $ExchangeSession
}

