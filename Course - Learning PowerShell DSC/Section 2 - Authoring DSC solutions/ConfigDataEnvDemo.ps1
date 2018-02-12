Configuration ConfigDataEnvDemo
{
    Node $AllNodes.Where{ $_.Env -eq "Dev"}.NodeName
    {
        File IISLogs
        {
            DestinationPath = $Node.IISLogFile
            Type = "File"
            Ensure = "Present"
        }
    }
    Node $AllNodes.Where{ $_.Env -eq "Test"}.NodeName
    {
        File IISLogs
        {
            DestinationPath = $Node.IISLogFile
            Type = "File"
            Ensure = "Present"
        }
    }
}

$configurationData = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            IISLogFile = "C:\Temp\IISLogs\Logs.txt"
            Env = "Dev"
        },
        @{
            NodeName = "DEVVM-01"
            IISLogFile = "C:\Temp\IISLogs\Logs.txt"
            Env = "Dev"
        },
        @{
            NodeName = "VM-Test01"
            IISLogFile = "L:\IISLogs\Logs.txt"
            Env = "Test"
        },
        @{
            NodeName = "VM-Test02"
            IISLogFile = "L:\IISLogs\Logs.txt"
            Env = "Test"
        },
        @{
            NodeName = "VM-Test03"
            IISLogFile = "L:\IISLogs\Logs.txt"
            Env = "Test"
        }
    )
}

ConfigDataEnvDemo -ConfigurationData $configurationData