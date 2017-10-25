param
(
    [Parameter(Mandatory=$false)]
    [string] $OutputPath = "C:\Temp\SoftwarePackagesConfig"
)

Configuration SoftwarePackagesConfig {
    
    Import-DscResource -ModuleName cChoco

    Node $env:COMPUTERNAME  {

        cChocoInstaller InstallChocolatey {
            InstallDir = "C:\ProgramData\chocolatey"
        }

        cChocoPackageInstaller KeePass {
            Name = "keepass.install"
            Version = "2.37"
            DependsOn = "[cChocoInstaller]InstallChocolatey"
        }
    }
}

SoftwarePackagesConfig -Output $OutputPath
Start-DscConfiguration -Verbose -Wait -Path $OutputPath