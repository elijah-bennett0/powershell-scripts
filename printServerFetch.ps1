$printers = Get-WmiObject -Class win32_printer -ComputerName 

foreach ($printer in $printers) {

    write-Host $printer

}