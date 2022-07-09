﻿[DSCLocalConfigurationManager()]
Configuration PullClientConfigID
{
    param(
        [string[]]$NodeName = 'localhost',

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $DSCServerFQDN,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]] $Configurations,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $RegistrationKey
    )
    
    Node localhost
    {
        Settings
        {
            RefreshMode                     = 'Pull'
            RefreshFrequencyMins            = 30
            RebootNodeIfNeeded              = $true
            ConfigurationMode               = "ApplyAndAutoCorrect"
            AllowModuleOverwrite            = $true
        }

        ConfigurationRepositoryWeb PullSrv
        {
            ServerURL               = "http://$DSCServerFQDN`:8080/PSDSCPullServer.svc"
            RegistrationKey         = $RegistrationKey
            ConfigurationNames      = $Configurations
            AllowUnsecureConnection = $true
        }

        ResourceRepositoryWeb ResourceSrv
        {
            ServerURL               = "http://$DSCServerFQDN`:8080/PSDSCPullServer.svc"
            RegistrationKey         = $RegistrationKey
            AllowUnsecureConnection = $true
        } 

        PartialConfiguration WebServer
        {
            Description = "WebServer"
            ConfigurationSource = @("[ConfigurationRepositoryWeb]PullSrv")
        }

        PartialConfiguration OSQuery
        {
            Description = "OSQuery"
            ConfigurationSource = @("[ConfigurationRepositoryWeb]PullSrv")
        }
    }
}