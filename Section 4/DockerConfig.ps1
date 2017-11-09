$MOFfiles = "C:\Temp\DockerConfig" 

Configuration DockerConfig {

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xPSDesiredStateConfiguration
    Import-DscResource -ModuleName xPendingReboot

    Node $AllNodes.NodeName {

        WindowsFeature InstallContainersFeature
        {
            Ensure = "Present"
            Name   = "Containers"
        }

        xRemoteFile DownloadDockerZipFile
        {
            DestinationPath = $ConfigurationData.NonNodeData.DockerDownloadPath
            Uri             = $ConfigurationData.NonNodeData.DockerEngineUrl
            MatchSource     = $False
            DependsOn       = "[WindowsFeature]InstallContainersFeature"
        }
        
        Archive ExtractDockerZipContents
        {
            Destination = $ENV:ProgramFiles
            Path        = $ConfigurationData.NonNodeData.DockerDownloadPath
            Ensure      = 'Present'
            Validate    = $false
            Force       = $true
            DependsOn   = '[xRemoteFile]DownloadDockerZipFile'
        }

        xEnvironment DockerPath
        {
            Ensure    = 'Present'
            Name      = 'Path'
            Value     = $ConfigurationData.NonNodeData.DockerInstallPath
            Path      = $True
            DependsOn = '[Archive]ExtractDockerZipContents'
        }

        xPendingReboot Reboot
        {
            Name = "Reboot After Docker Install"
        }

        Script RegisterDockerService
        {
            SetScript = {
                $DockerDPath = (Join-Path $($Using:ConfigurationData.NonNodeData.DockerInstallPath) "dockerd.exe")
                & $DockerDPath @('--register-service')
            }
            GetScript = {
                return @{
                    'Service' = (Get-Service -Name Docker).Name
                }
            }
            TestScript = {
                if (Get-Service -Name Docker -ErrorAction SilentlyContinue) {
                    return $True
                }
                return $False
            }
            DependsOn = '[xEnvironment]DockerPath'
        }

        xService StartDockerService
        {
            Ensure      = 'Present'
            Name        = 'Docker'
            StartupType = 'Automatic'
            State       = 'Running'
            DependsOn   = '[Script]RegisterDockerService'
        }
        
        LocalConfigurationManager {        
            ActionAfterReboot = 'ContinueConfiguration'        
            ConfigurationMode = 'ApplyOnly'        
            RebootNodeIfNeeded = $true        
        }
    }
}

$ConfigData = @{
    AllNodes = @(
        @{  
            NodeName = $ENV:COMPUTERNAME  
        }
    )
    NonNodeData = @{
        DockerEngineUrl = "https://download.docker.com/components/engine/windows-server/17.06/docker-17.06.2-ee-5.zip"
        DockerInstallPath = (Join-Path -Path $ENV:ProgramFiles "Docker")
        DockerDownloadPath = (Join-Path "C:\Windows\Temp" "docker-17.06.2-ee-5.zip")
    }
}

DockerConfig -OutputPath $MOFfiles -ConfigurationData $ConfigData
Set-DSCLocalConfigurationManager -Path $MOFfiles -Verbose
Start-DscConfiguration -Path $MOFfiles -Wait -Verbose -Force