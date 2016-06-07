$exitcode=0 

$teamviewer = (Get-Service -name TeamViewer |fl status | out-string).trim()
$teamviewer = $teamviewer -replace "Status : ", "";
if($teamviewer -match ('^' + [regex]::Escape('Running')))
{       
    $exitcode = 0
} else 
{
    $exitcode = 1
}
$teamviewer
exit $exitcode


