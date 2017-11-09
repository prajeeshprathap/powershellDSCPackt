$MOFfiles = "C:\Temp\DockerConfig" 

Configuration NanoServerConfig {
    Node "nanosrv-dsc.westeurope.cloudapp.azure.com" {
        File TempFolder {
            DestinationPath =  "C:\Temp"
            Type = "Directory"
            Ensure = "Present"
        }
        
        File TestFile {
            DestinationPath = "C:\Temp\Demo.txt"
            Contents = "This is a test"
            Ensure = "Present"
            DependsOn = "[File]TempFolder"
        }
    }
}

NanoServerConfig -OutputPath $MOFfiles
Start-DscConfiguration -Path $MOFfiles -ComputerName "nanosrv-dsc.westeurope.cloudapp.azure.com" -Wait -Verbose -Force -Credential (Get-Credential)