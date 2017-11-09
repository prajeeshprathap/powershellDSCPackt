Configuration ConfigDataDemo
{
    Node $AllNodes.NodeName
    {
        File TempLogDirectory
        {
            DestinationPath = $Node.TempLogLocation
            Type = "Directory"
            Ensure = "Present"
        }
    }
}

$configurationData = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            TempLogLocation = "C:\Temp"
        },
        @{
            NodeName = "TestVM01"
            TempLogLocation = "D:\Temp"
        },
        @{
            NodeName = "ProdVM01"
            TempLogLocation = "L:\Logs"
        }
    )
}

ConfigDataDemo -ConfigurationData $configurationData