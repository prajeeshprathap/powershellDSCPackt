$credentials = Get-Credential -UserName "prajeesh" -Message "Enter password for azure login"
$session = New-PSSession -ComputerName "nanosrv-dsc.westeurope.cloudapp.azure.com" -Credential $credentials

Invoke-Command -ScriptBlock {
    Install-PackageProvider -Name NanoServerPackage -Force

    Import-PackageProvider NanoServerPackage

    Install-NanoServerPackage -Name Microsoft-NanoServer-DSC-Package -Culture en-us -Force
} -Session $session

Remove-PSSession -Session $session

<#

$credentials = Get-Credential -UserName "prajeesh" -Message "Enter password for azure login"
Enter-PSSession -ComputerName "nanosrv-dsc.westeurope.cloudapp.azure.com" -Credential $credentials

#>