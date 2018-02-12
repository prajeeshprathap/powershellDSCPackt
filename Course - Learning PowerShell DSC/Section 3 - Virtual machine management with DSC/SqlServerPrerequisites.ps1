If(-not (Get-Module -ListAvailable xSqlServer -ErrorAction SilentlyContinue)) {
    Install-Module -Name xSqlServer -Force
}

If(-not (Test-Path "C:\Temp\SQL2017")) {
    New-Item -ItemType Directory -Path "C:\Temp\SQL2017" -Force
}
$mountResult = Mount-DiskImage -ImagePath "C:\Temp\en_sql_server_2017_developer_x64_dvd_11296168.iso" -PassThru
$volumeInfo = $mountResult | Get-Volume
$driveInfo =  Get-PSDrive -Name $volumeInfo.DriveLetter
Copy-Item -Path ( Join-Path -Path $driveInfo.Root -ChildPath '*' ) -Destination "C:\Temp\SQL2017\" -Recurse
Dismount-DiskImage -ImagePath "C:\Temp\en_sql_server_2017_developer_x64_dvd_11296168.iso"