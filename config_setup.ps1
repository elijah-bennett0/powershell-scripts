'''
Author: Elijah Bennett 
Version: 1.0
Description: This script edits and re-compresses printer configs so its ready to import

'''

$1_files = ""
$2_files = ""

[int]$opt = Read-Host "[1]  or [2]  ?"
$serial = Read-Host "Enter the serial number"
$bldg = Read-Host "Enter the building number"
$contact = Read-Host "Enter the shop name (ex )"
$ipname = $serial.Substring($serial.Length - 7) # get last 7
Write-Host "[!] Updating values..."

if ($opt -eq 1) {
	try {
		Copy-Item -Path $1_files -Destination "" -Recurse -PassThru # copy it to the users local machine to prevent corruption of my files.
    } catch {
		Write-Host "[!] Copy failed."
	}
	$bundle = ""
    [xml]$xml = Get-Content -Path $bundle
    $updates = @{
        "network.IPNAME" = ""
        "nvContactLocation" = ""
        "nvContactName" = ""
		"brassTag" = $serial
		"network.IPDHCPENABLE" = ""
		"network.IPAUTOIPENABLE" = ""
    }

    foreach ($node in $xml.SelectNodes("//setting[@name]")) {

        $name = $node.name
        if ($updates.ContainsKey($name)) {
            $node.InnerText = $updates[$name]
        }

    }
    $xml.Save($bundle)
    Write-Host "[!] Compressing configs..."
    
    $files = Get-ChildItem -Path "" -File | ForEach-Object { $_.FullName }
	try {
		mkdir -Path ""
		Compress-Archive -Path $files -DestinationPath ""
		Write-Host "[+] Config located at: "
    } catch {
		Write-Host "[!] Error creating config dir"
	}
	
} else {
	try {
		Copy-Item -Path $2_files -Destination "" -Recurse -PassThru # copy it to the users local machine to prevent corruption of my files.
	} catch {
		Write-Host "[!] Copy failed."
	}
	$bundle = ""
    [xml]$xml = Get-Content -Path $bundle
    $updates = @{
        "network.IPNAME" = ""
        "nvContactLocation" = ""
        "nvContactName" = ""
		"brassTag" = $serial
		"network.IPDHCPENABLE" = ""
		"network.IPAUTOIPENABLE" = ""
    }

    foreach ($node in $xml.SelectNodes("//setting[@name]")) {

        $name = $node.name
        if ($updates.ContainsKey($name)) {
            $node.InnerText = $updates[$name]
        }

    }
    $xml.Save($bundle)
    Write-Host "[!] Compressing configs..."
    
    $files = Get-ChildItem -Path "" -File | ForEach-Object { $_.FullName }
	try {
		mkdir -Path ""
		Compress-Archive -Path $files -DestinationPath ""
		Write-Host "[+] Config located at: "
    } catch {
		Write-Host "[!] Error creating config dir"
	}
}
