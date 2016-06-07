$t = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace “root/wmi” |select CurrentTemperature
$ret_value = 0
foreach ($temp in $t.CurrentTemperature)
{
    $currentTempKelvin = $temp / 10
    $currentTempCelsius = $currentTempKelvin - 273.15
    $currentTempCelsius

}

if ($currentTempCelsius -gt 30) 
{
        $ret_value = 1
}
if($currentTempCelsius -gt 35)
{
        $ret_value = 2
}


exit $ret_value