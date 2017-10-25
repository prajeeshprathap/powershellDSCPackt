 
$ComputerName = "localhost" 
$Password = "Password@12" 
$DomainName = "adcloud-lab.com" 
$MOFfiles = "C:\Temp\AD" 
 #Encrypt Passwords  
$Cred = ConvertTo-SecureString -String $Password -Force -AsPlainText  
$DomainCredential = New-Object System.Management.Automation.PSCredential ("$(($DomainName -split '\.')[0])\Administrator", $Cred)  
$DSRMpassword = New-Object System.Management.Automation.PSCredential ('No UserName', $Cred)  
#Create connection to remote computer  
$RemoteAdministratorCred = Get-Credential -UserName Administrator -Message "$ComputerName Administrator password"  
$CimSession = New-CimSession -ComputerName $ComputerName -Credential $RemoteAdministratorCred -Name $ComputerName  

Configuration NewActiveDirectoryConfig {  
    param (  
        [Parameter(Mandatory)]   
        [PSCredential]$DomainCredential,  
        [Parameter(Mandatory)]   
        [PSCredential]$DSRMpassword  
    )  
    Import-DscResource –ModuleName xActiveDirectory  

    Node $ComputerName {  
        #Install Active Directory role and required tools  
        WindowsFeature ActiveDirectory {  
            Ensure = 'Present'  
            Name = 'AD-Domain-Services'  
        }   
        WindowsFeature ADDSTools            
        {             
            Ensure = "Present"             
            Name = "RSAT-ADDS"     
            DependsOn = "[WindowsFeature]ActiveDirectory"         
        } 
        WindowsFeature ActiveDirectoryTools {  
            Ensure = 'Present'  
            Name = 'RSAT-AD-Tools'  
            DependsOn = "[WindowsFeature]ADDSTools"  
        } 
        WindowsFeature DNSServerTools {  
            Ensure = 'Present'  
            Name = 'RSAT-DNS-Server'  
            DependsOn = "[WindowsFeature]ActiveDirectoryTools"  
        }  
        WindowsFeature ActiveDirectoryPowershell {  
            Ensure = "Present"  
            Name  = "RSAT-AD-PowerShell"  
            DependsOn = "[WindowsFeature]DNSServerTools"  
        }  
        #Configure Active Directory Role   
        xADDomain RootDomain {  
            Domainname = $DomainName  
            SafemodeAdministratorPassword = $DSRMpassword  
            DomainAdministratorCredential = $DomainCredential  
            DependsOn = "[WindowsFeature]ActiveDirectory", "[WindowsFeature]ActiveDirectoryPowershell"  
        }  
        #LCM Configuration  
        LocalConfigurationManager {        
            ActionAfterReboot = 'ContinueConfiguration'        
            ConfigurationMode = 'ApplyOnly'        
            RebootNodeIfNeeded = $true        
        }        
    }  
}  
#Allow plain text password to be stored  
$ConfigurationData = @{  
    AllNodes = @(  
        @{  
            NodeName = $ComputerName  
            PSDscAllowPlainTextPassword = $true  
            DomainName = $DomainName  
        }  
    )  
}  
#Generate mof files  
NewActiveDirectoryConfig -DSRMpassword $DSRMpassword -DomainCredential $DomainCredential -OutputPath $MOFfiles -ConfigurationData $ConfigurationData  
#Configure LCM on remote computer  
Set-DSCLocalConfigurationManager -Path $MOFfiles –Verbose -CimSession $CimSession  
#Start Deployment remotely  
Start-DscConfiguration -Path $MOFfiles -Verbose -CimSession $CimSession -Wait -Force  