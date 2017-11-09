Install-Module xDscDiagnostics -Force

Get-xDscOperation -Newest 10


# $jobId - ""
# Trace-xDscOperation -JobId $jobId

# $trace = Trace-xDscOperation -JobId $jobId
# $trace.Event | select -expand Message