$cert = New-SelfSignedCertificate -Type DocumentEncryptionCertLegacyCsp -DnsName 'DscEncryptionCert' -HashAlgorithm SHA256
Write-Verbose "Exporting certificate public key to C:\Temp\DscPublicKey.cer"
$cert | Export-Certificate -FilePath "C:\Temp\DscPublicKey.cer" -Force

Get-ChildItem Cert:\LocalMachine\My