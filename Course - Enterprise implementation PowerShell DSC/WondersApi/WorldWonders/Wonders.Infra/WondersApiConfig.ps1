configuration WondersApiConfig{
	Import-DscResource -ModuleName PSDesiredStateConfiguration
	Import-DscResource -ModuleName xWebAdministration
	node localhost {

		WindowsFeature DotNet45Core
		{
			Ensure = 'Present'
			Name = 'NET-Framework-45-Core'
		}

		WindowsFeature IIS
		{
			Ensure = 'Present'
			Name = 'Web-Server'
		}

		WindowsFeature AspNet45
		{
			Ensure = "Present"
			Name = "Web-Asp-Net45"
		}
 
		File WondersApi
		{
			Ensure = "Present"
			Type = "Directory"
			Recurse = $true
			SourcePath = "C:\Temp\WondersApi\Website"
			DestinationPath = "C:\inetpub\WondersApi"
		}

		xWebAppPool WondersApi
		{
			Ensure = "Present"
			Name = "WondersApi"
			State = "Started"
			DependsOn = "[WindowsFeature]IIS"
		}

		xWebsite WondersApi
		{
			Ensure = "Present"
			Name = "WondersApi"
			State = "Started"
			PhysicalPath = "C:\inetpub\WondersApi"
			BindingInfo = MSFT_xWebBindingInformation
			{
				Protocol = 'http'
				Port = '80'
				IPAddress = '*'
			}
			ApplicationPool = "WondersApi"
			DependsOn = "[xWebAppPool]WondersApi"
		}
 
		WindowsFeature IISTools
		{
			Ensure = "Present"
			Name = "Web-Mgmt-Tools"
		}
 
		xWebsite Default
		{
			Ensure = "Absent"
			Name = "Default Web Site"
		}

		xWebAppPool NETv45
		{
			Ensure = "Absent"
			Name = ".NET v4.5"
		}

		xWebAppPool NETv45Classic
		{
			Ensure = "Absent"
			Name = ".NET v4.5 Classic"
		}

		xWebAppPool Default
		{
			Ensure = "Absent"
			Name = "DefaultAppPool"
		}

		File wwwroot
		{
			Ensure = "Absent"
			Type = "Directory"
			DestinationPath = "C:\inetpub\wwwroot"
			Force = $True
		}
	}
}

WondersApiConfig