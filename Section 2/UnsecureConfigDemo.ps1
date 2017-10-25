param
(
    [Parameter()]
    [pscredential] $Credentials
)
configuration UnSecureConfigDemo
{
    Node localhost
    {
        File DemoFile 
        {
            DestinationPath = "$env:windir\Temp\CredentialDemo1.txt"
            Contents = "CredentialDemo1 file contents"
            Credential = $Node.Credentials
        }
    }
}

$configData = @{
    AllNodes = @(    
        @{  
            NodeName = "localhost"
            Credentials = $Credentials
            PsDscAllowPlainTextPassword = $true
        }
    ) 
}

UnSecureConfigDemo -ConfigurationData $configData