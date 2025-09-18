'''
Author: Elijah Bennett 
Date: 20250618
Version: 1.0


'''

$computer = Read-Host "[?] TARGET COMPUTER NAME"

$menu = "
[1] 
[2] 
[3] 
[4] 
[5] 
[6] 
[7] 
"
Write-Host $menu
$downloadPaths = @{

    1 = ""
    2 = ""
    3 = ""
    4 = ""
    5 = ""
	6 = ""
	7 = ""

}

$file = Read-Host "[?] Enter FULL path to software or select from above menu"

if ([int]$file -is [int]) { # If the user selects from the menu
	$download = $downloadPaths.[int]$file
    $dest = ""
	Copy-Item -Path $download -Destination $dest -Recurse -PassThru
    $splitpath = $download -split "\\" # split the directory path so we can get the app name and cd to it without worrying about conflicts
    $app = $splitpath[-1] # the last folder in the path should be the app name
    Invoke-Command -ComputerName $computer -ScriptBlock {
	param($app)
	Get-ChildItem "" -File -Recurse | Unblock-File # The files get blocked since they come from a remote computer. This unblocks them all
	}
	Invoke-Command -ComputerName $computer -ScriptBlock { 
    param($app)
    & ""
    } -ArgumentList $app # scriptblock runs in context of target machine so you have to pass variables as args
} else { # If the user enters their own path
	if (Test-Path -Path $file) {
		$dest = ""
		Copy-Item -Path $file -Destination $dest -Recurse -PassThru 
	    $splitpath = $file -split "\\" # split the directory path so we can get the app name and cd to it without worrying about conflicts
        $app = $splitpath[-1] # the last folder in the path should be the app name
        Invoke-Command -ComputerName $computer -ScriptBlock { 
        param($app)
        & ""
        } -ArgumentList $app # scriptblock runs in context of target machine so you have to pass variables as args

        #### WORKING AS OF 20250602
	
	} else {
	
		Write-Host "[-] Could not locate path: '$file'"
	
	}
}