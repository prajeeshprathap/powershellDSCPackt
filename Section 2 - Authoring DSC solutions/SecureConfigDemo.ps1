param
(
    [Parameter()]
    [pscredential] $Credentials
)
configuration SecureConfigDemo
{
    Node localhost
    {
        File DemoFile 
        {
            DestinationPath = "$env:windir\Temp\CredentialDemo2.txt"
            Contents = "CredentialDemo2 file contents"
            Credential = $Node.Credentials
        }
        LocalConfigurationManager 
        { 
             CertificateId = $node.Thumbprint 
        } 
    }
}

$configData = @{
    AllNodes = @(    
        @{  
            NodeName = "localhost"
            Credentials = $Credentials
            CertificateFile = "C:\Temp\DscPublicKey.cer"
            Thumbprint = "7611175B6835CABAE88CFD5D792A567DEF2BFAE5"
        }
    ) 
}

SecureConfigDemo -ConfigurationData $configData