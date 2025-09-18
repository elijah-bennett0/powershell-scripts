# Define the input and output Excel file paths
$inputExcelPath = ""
$outputExcelPath = ""

# Get all AD users in the specified search base, including the employeeID and mail attributes
$users = Get-ADUser -Filter * -SearchBase "" -Properties mail, employeeID

# Open the Excel application
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excel.DisplayAlerts = $false

# Open the workbook
$workbook = $excel.Workbooks.Open($inputExcelPath)
$worksheet = $workbook.Worksheets.Item(1)

# Get the range of used cells
$usedRange = $worksheet.UsedRange
$rowCount = $usedRange.Rows.Count

# Find the column indices for "" and ""
$headerRow = $worksheet.Rows.Item(1)
$p = $headerRow.Find("").Column
$o = $headerRow.Find("").Column

# Loop through each row of the Excel file (starting from the second row)
for ($i = 2; $i -le $rowCount; $i++) {
    # Get the  value from the Excel file
    $i = $worksheet.Cells.Item($i, $p).Text

    # Find the user in the pre-fetched AD data using the employeeID attribute
    $adUser = $users | Where-Object {
        $_.employeeID -eq $i
    }

    if ($adUser) {
        # Handle email address (array or null)
        $emailAddress = if ($null -ne $adUser.mail) {
            $adUser.mail -join ";"
        } else {
            "NO_EMAIL_FOUND"
        }

        # Update the  column with the user's email address
        $worksheet.Cells.Item($i, $o).Value = $emailAddress
    } else {
        # If no match is found, write "NO_MATCH" to the  column
        $worksheet.Cells.Item($i, $o).Value = "NO_MATCH"
    }
}

# Save the updated workbook to a new file
$workbook.SaveAs($outputExcelPath)

# Close the workbook and quit Excel
$workbook.Close()
$excel.Quit()

# Release COM objects to free memory
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($worksheet) | Out-Null
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook) | Out-Null
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null

Write-Host "Finished processing. Updated file saved to $outputExcelPath"