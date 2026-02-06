Import-Module ActiveDirectory

$confirm = $true # change this to false if you dont want to have to confirm every time
$deadList = "" # currently in my scripts folder. change this to the path of your csv
$ignore = @() # Use this to ignore certain laptops. example: @("computer1", "computer2", "computer3")

Import-Csv -Path $deadList | ForEach-Object {
    $name = $_.CN
    $obj = Get-ADComputer -SearchBase "" -SearchScope Subtree -Filter 'Name -like $name'
    try {
        if ($obj.Enabled -eq $false -and $ignore -notcontains $name) { # if the computer is disabled and isnt in the ignore list
            Write-Host "[*] Computer inactive, deleting : $name"
            Remove-ADComputer -Identity $obj.Name -Confirm:$confirm
        }
    } catch {
        Write-Host "[-] Removing $name failed..."
    }
}

Write-Host "[+] Done."