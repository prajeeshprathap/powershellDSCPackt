Configuration DSCLogDemoConfig {
    Node $env:COMPUTERNAME {
        
        File DemoFolder {
            DestinationPath = "C:\Temp"
            Type = "Directory"
            Ensure = "Present"
        }

        File DemoFile {
            DestinationPath = "C:\Temp\Demo.txt"
            Contents = "This is a test"
            Ensure = "Present"
        }

        Script ErrorScript {
            GetScript = {
                return @{"Data" = "Test Data"}
            }
            TestScript = {
                return $false
            }
            SetScript = {
                throw "error in configuration"
            }
        }
    }
}

DSCLogDemoConfig