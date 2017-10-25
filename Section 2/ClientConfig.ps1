param
(
    [Parameter(Mandatory)]
    [string] $ConfigurationServerUrl,

    [Parameter(Mandatory)]
    [string] $ConfigurationServerKey
)

[DSCLocalConfigurationManager()]
configuration PullClientConfiguration
{
    node localhost
    {
        Settings
        {
            AllowModuleOverwrite = $True;
            ConfigurationMode = 'ApplyAndAutoCorrect';
            ConfigurationModeFrequencyMins = 60;
            RefreshMode          = 'Pull';
            RefreshFrequencyMins = 30 ;
            RebootNodeIfNeeded   = $true;
        }

        #specifies an HTTP pull server for configurations
        ConfigurationRepositoryWeb DSCConfigurationServer
        {
            ServerURL          = $Node.ConfigServer;
            RegistrationKey    = $Node.ConfigServerKey;
            AllowUnsecureConnection = $true;
            ConfigurationNames = @("DemoConfig")
        }

        #specifies an HTTP pull server for sending reports
        ReportServerWeb DSCReportServer
        {
            ServerURL          = $Node.ConfigServer;
            RegistrationKey    = $Node.ConfigServerKey;
            AllowUnsecureConnection = $true;
        }

        PartialConfiguration DemoConfig
        {
            Description                     = "DemoConfig"
            ConfigurationSource             = @("[ConfigurationRepositoryWeb]DSCConfigurationServer") 
        }
    }
}

$configParams = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            ConfigServer = $ConfigurationServerUrl
            ConfigServerKey = $ConfigurationServerKey
        }
    )
}

PullClientConfiguration -ConfigurationData $configParams