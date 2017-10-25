[DSCLocalConfigurationManager()]
configuration LCMSettings
{
    node localhost
    {
        Settings
        {
            ConfigurationMode = 'ApplyAndAutoCorrect';
            RefreshMode          = 'Push';
            
        }
    }
}


LCMSettings