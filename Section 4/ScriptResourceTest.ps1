Configuration ScriptResourceTest {
    Node $AllNodes.NodeName {
        Script TestScript {
            GetScript = { return @{TestData = "Hello"}}
            TestScript =  { return $false }
            SetScript = { Write-Warning $($Using:configData.NonNodeData.TestData)}
        }
    }
}

$configData = @{
    AllNodes = @(
        @{
            NodeName = $ENV:COMPUTERNAME
        }
    )
    NonNodeData = @{
        TestData = "Some data"
    }
}

ScriptResourceTest -OutputPath "D:\Temp" -ConfigurationData $configData
Start-DscConfiguration -Wait -Verbose -Path "D:\Temp"  

