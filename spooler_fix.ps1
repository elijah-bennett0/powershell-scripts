$computer = Read-Host "[?] Enter computer name"
Invoke-Command -ComputerName $computer -ScriptBlock {Restart-Service -Name Spooler}