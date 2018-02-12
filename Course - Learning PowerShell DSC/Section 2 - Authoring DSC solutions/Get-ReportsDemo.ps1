$agentId = Get-DscLocalConfigurationManager | Select-Object -ExpandProperty AgentId
$reportServiceUrl = "http://pullserver9392.cloudapp.net/PSDSCPullServer.svc"
$requestUri = "$reportServiceUrl/Nodes(AgentId= '$AgentId')/Reports"

$request = Invoke-WebRequest -Uri $requestUri  `
                             -ContentType "application/json;odata=minimalmetadata;streaming=true;charset=utf-8" `
                             -UseBasicParsing `
                             -Headers @{Accept = "application/json";ProtocolVersion = "2.0"} `
                             -ErrorAction SilentlyContinue `
                             -ErrorVariable ev
ConvertFrom-Json $request.Content | Sort-Object {$_."StartTime" -as [DateTime] } -Descending
