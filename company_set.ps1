'''
@Author: Ginsu
@Date  : 20250918
@Desc  : This script will take a roster of people with their assigned companies and change the users Job Title in AD to their company
         to make it easier for us to know where people are.
'''

$csv = ""
Import-Csv -Path $csv | ForEach-Object {

    $username = $_.sAMAccountName
    $company = $_.Company

    Write-Host "[+] User $username setting job title to $company ..."
    Set-ADUser -Identity $username -Title $company
}