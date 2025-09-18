'''
@Author: Ginsu
@Date  : 20250918
@Desc  : 
'''

$newCSV = Import-Csv -Path ""
$oldCSV = Import-Csv -Path ""

$updated = @()

function cleanName($name) {
    # Remove whitespace and capitals so I can compare names from both CSV's
    return ($name -replace "[^a-zA-Z0-9]", "").ToLower().Trim()
}

foreach ($newUser in $newCSV) {
    # Normalize the name from the new CSV
    $normalName = cleanName $newUser.Name

    # Debugging: Print the normalized name from the new CSV
    Write-Host "[!] Normalized New Name: $normalName"

    # Find the matching user in the old CSV
    $matchUser = $oldCSV | Where-Object {
        $oldName = cleanName $_.Name
        # Debugging: Print the normalized name from the old CSV
        Write-Host "[!] Checking Old Name: $oldName"
        $oldName -eq $normalName
    } | Select-Object -First 1

    if ($matchUser) {
        # Debugging: Print the matched user and their company
        Write-Host "[+] Matched User: $($matchUser.Name) - Company: $($matchUser.Company)"
        $newUser | Add-Member -MemberType NoteProperty -Name Company -Value $matchUser.Company
    } else {
        # Debugging: Print when no match is found
        Write-Host "[-] No match found for: $($newUser.Name)"
        $newUser | Add-Member -MemberType NoteProperty -Name Company -Value "UNK"
    }

    $updated += $newUser
}

$updated | Export-Csv -Path "" -NoTypeInformation