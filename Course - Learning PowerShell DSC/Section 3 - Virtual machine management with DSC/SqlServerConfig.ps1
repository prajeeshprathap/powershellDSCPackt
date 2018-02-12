param
(
    [Parameter(Mandatory=$false)]
    [string] $SourcePath = "C:\Temp\SQL2017",

    [Parameter(Mandatory=$false)]
    [string] $MOFPath = "C:\Packt\Section 3\Scripts\SQLServerConfig"
)

Configuration SqlServerConfig
{
     Import-DscResource -ModuleName xSQLServer
     Import-DscResource -ModuleName PSDesiredStateConfiguration

     node localhost
     {
          WindowsFeature NetFramework45
          {
               Name = 'NET-Framework-45-Core'
               Ensure = 'Present'
          }

          xSQLServerSetup InstallSQL
          {
               InstanceName = $Node.InstanceName
               Features = 'SQLENGINE'
               SourcePath = $Node.SourcePath
               SQLSysAdminAccounts = @('Administrators')
               DependsOn = "[WindowsFeature]NetFramework45"
          }

          xSQLServerNetwork ConfigureSQLNetwork
          {
              DependsOn = "[xSqlServerSetup]InstallSQL"
              InstanceName = $Node.InstanceName
              ProtocolName = "tcp"
              IsEnabled = $true
              TCPPort = 1433
              RestartService = $true
          }

          xSQLServerAlwaysOnService EnableAlwaysOn
          {
              SQLServer = $ComputerName
              SQLInstanceName = $Node.InstanceName
              DependsOn = "[xSQLServerNetwork]ConfigureSQLNetwork"
              Ensure = "Present"
          }
     }
}

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = localhost
            SourcePath = $SourcePath
            PSDscAllowPlainTextPassword = $true  
            InstanceName = "MSSQLSERVER"
        }
    )
}

SqlServerConfig -ConfigurationData $ConfigData -Output $MOFPath
Start-DscConfiguration -Path $MOFPath -Verbose -Wait -Force 