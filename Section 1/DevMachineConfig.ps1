Configuration DevMachineConfig
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Node localhost
    {

        File TempDirectory
        {
            DestinationPath = "C:\Temp"
            Ensure = "Present"
            Type = "Directory"
        }
        
        Service WindowsInstaller
        {
            Name = "msiserver"
            State = "Running"
        }
    }
}

DevMachineConfig