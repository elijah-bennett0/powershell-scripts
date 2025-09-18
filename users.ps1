'''
@Author: Ginsu
@Date  : 20250917
@Desc  : This is to extract all users with some useful info about them.

'''

Import-Module ActiveDirectory

Get-ADUser -Filter * -SearchBase "" -Properties Name, givenName, sn, mail, employeeID, msExchExtensionAttribute35, title, sAMAccountName | 
Select-Object Name, givenName, sn, mail, employeeID, msExchExtensionAttribute35, title, sAMAccountName | 
Export-Csv -Path "" -NoTypeInformation