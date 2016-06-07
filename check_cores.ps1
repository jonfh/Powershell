$cores = (Get-WmiObject -class Win32_processor | fl NumberOfCores | out-string).trim()
$cores = $cores -replace "NumberOfCores : ", "";
$cores
exit 0