New-MigrationBatch -Name IMAPBatch1 -SourceEndpoint IMAPEndpoint -CSVData ([System.IO.File]::ReadAllBytes("C:\legepost.csv")) -AutoStart
Get-MigrationBatch -Identity IMAPBatch1 | Format-List
Get-MigrationBatch -Identity IMAPBatch1 | Format-List Status