# info in quotes redacted

Import-Module ActiveDirectory

$results = Get-ADGroupMember -Identity "" | Where-Object {$_.objectClass -eq "computer" -and $_.name -like ""} | ForEach-Object {

    $member = Get-ADComputer $_.DistinguishedName -Properties Description
    $desc = $member.Description
    if ($desc -match "") {

        $model = $Matches[0]

    } else {

        $model = "Unknown"

    }

    [PSCustomObject]@{
        Name = $member.Name
        Model = $model
    }

}

$results | Export-Csv "" -NoTypeInformation