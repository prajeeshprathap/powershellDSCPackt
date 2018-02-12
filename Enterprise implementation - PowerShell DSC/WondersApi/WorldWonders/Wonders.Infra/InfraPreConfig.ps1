configuration InfraPreConfig {
	node localhost {
		Script InstallDSCResources {
			GetScript = {
				return @{"Module" = "xWebAdministration"}
			}
			SetScript = {
				Install-Module xWebAdministration -Force
			}
			TestScript = {
				return ((Get-Module xWebAdminstration) -ne $null)
			}
		}
	}
}


InfraPreConfig