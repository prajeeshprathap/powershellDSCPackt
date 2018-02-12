$ErrorActionPreference = 'Stop'
if((Get-ExecutionPolicy) -eq 'Restricted')
{
    throw 'Execution policy should be set atlease to RemoteSigned..'
}
if(-not(Test-WSMan -ErrorAction SilentlyContinue))
{
    Set-WSManQuickConfig -Force 
}

$configServerUrl = 'http://pullserver9392.cloudapp.net/PSDSCPullServer.svc/'
$configServerKey = 'c944ce11-0ffe-467b-bb22-fd1cd2fd769l'

.\ClientConfig.ps1 -ConfigurationServerUrl $configServerUrl `
                    -ConfigurationServerKey $configServerKey


Set-DscLocalConfigurationManager -Path .\PullClientConfiguration -Verbose -Force 