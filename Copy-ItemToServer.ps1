function Copy-ItemToServer {
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
.DESCRIPTION
.EXAMPLE
copyItemToServer -csv C:\GitHub\host.csv -username administrator -filepath C:\Users\jonfh\ownCloud\UniSoft\PROG\TeamViewer\TeamViewerMSI.zip -Verbose -destinationPath 'C:\users\usadm\Desktop\'
.EXAMPLE
copyItemToServer -server 10.8.254.2 -username administrator -filepath C:\Users\jonfh\ownCloud\UniSoft\PROG\TeamViewer\TeamViewerMSI.zip -Verbose -destinationPath 'C:\users\usadm\Desktop\'
#>
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Medium')]
    param(
        
	    [string]$server,
        [string]$username,
        [string]$filepath,
        [string]$csv,
        [Parameter(Mandatory=$true)][string]$destinationPath,       
        [switch]$namelog    
    )



    


BEGIN{}
PROCESS{
    $credentials = Get-Credential($username)
    if($server) 
    {
        $session = New-PSSession -ComputerName $server -Credential $credentials

        if($session) 
        {
            Write-Verbose "connected to $server"
            try 
            {
                Copy-Item -Destination $destinationPath -path $filepath -toSession $session 
                Write-Verbose "copied $filepath to $destinationPath on $server"
            } catch 
            {
                Write-Verbose "could not copy $filepath to $destinationPath on $server"
            }
            try 
            {
                Write-Verbose "Removing session $session"
                Remove-PSSession $session
                Write-Verbose "Removed session $session"
            } catch 
            {
                Write-Verbose "could not remove session $session"
            }
        }
    }

    elseif ($csv)
    {   
             
        Import-Csv $csv | ForEach-Object { 
        $server = $_.IP                  
        $session = New-PSSession -ComputerName $server -Credential $credentials -Name $_.Host
        
        if ($session) 
            {
                Write-Verbose "connected to $server"
                try 
                {
                    Copy-Item -Destination $destinationPath -path $filepath -toSession $session 
                     Write-Verbose "copied $filepath to $destinationPath on $server"                     
                } catch 
                {
                     Write-Verbose "could not copy $filepath to $destinationPath on $server"
                }
                try 
                {
                    Write-Verbose "Removing session $session"
                    Remove-PSSession $session
                    Write-Verbose "Removed session $session"
                } catch 
                {
                    Write-Verbose "could not remove session $session"
                }

            }

        }
    
    }
}
END{}

}
