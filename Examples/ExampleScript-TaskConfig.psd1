<#
    .Parameter TaskName
    The name of the task
    .Parameter TaskPath
    The path to the task in the task scheduler
    .Parameter Description
    A description of the task
    .Parameter TaskAction
    The action to be performed by the task.  Execute should contain the command to run, and Argument should contain any arguments to pass to the command
    .Parameter TaskTrigger
    The trigger for the task.  This should be a hashtable containing the trigger type and any necessary parameters
    .Parameter TaskPrincipal
    The principal for the task.  This should be a hashtable containing the user ID, logon type, and run level
    .Parameter PrincipalSecretName
    The name of the secret in the servers SecretStore vault containing the password for the principal
    .Parameter TaskSettingSet
    The settings for the task.  This should be a hashtable containing the settings to be applied to the task
#>
@{
    TaskName    = 'ExampleRepo-ExampleScript'
    TaskPath    = '\PSCAutomation\'
    Description = 'Example Task Description'
    TaskAction  = @{
        Execute                         = 'powershell.exe' 
        Argument                        = '-WindowStyle Hidden -File "C:\Git\PSConfigAsCodeFramework\\ExampleScript.ps1"'
        
        #WorkingDirectory                = 'D:\'
    }

    TaskTrigger = @{
        Once                            = $true 
        #Daily                           = $true
        #Weekly                          = $true
        #AtStartup                       = $true
        #AtLogOn                         = $true
        #DaysOfWeek                      = 'Monday'
        At                              = '2:00'
        RepetitionInterval              = "00.00:10:00"

    }

    TaskPrincipal = @{
        UserId                          = 'PSCAutomation'
        LogonType                       = 'Password' # Password is equivalent to checking the box "Run whether user is logged on or not"
        RunLevel                        = 'Limited' # Limited is equivalent to not checking the box "Run with highest privileges".  This is the desired setting for cloning repos.  Cloning as admin can cause permission issues.
    }
    PrincipalSecretName                 = 'PSCAutomation'

    TaskSettingSet = @{
        AllowStartIfOnBatteries             = $false            #<bool>
        AsJob                               = $false            #<bool>
        #CimSession                          = $null             # <CimSession[]>
        Compatibility                       = 'Win7'            #{At | V1 | Vista | Win7 | Win8}
        #DeleteExpiredTaskAfter              = "00.00:00:00"     #<timespan>
        Disable                             = $false            #<bool>
        DisallowDemandStart                 = $false            #<bool>
        DisallowHardTerminate               = $false            #<bool>
        DisallowStartOnRemoteAppSession     = $false            #<bool>
        DontStopIfGoingOnBatteries          = $false            #<bool>
        DontStopOnIdleEnd                   = $false            #<bool>
        ExecutionTimeLimit                  = "03.00:00:00"     #<timespan>
        Hidden                              = $false            #<bool>
        IdleDuration                        = "00.00:10:00"     #<timespan>
        IdleWaitTimeout                     = "00.01:00:00"     #<timespan>
        #MaintenanceDeadline                 = "00.00:00:00"     #<timespan>
        #MaintenanceExclusive                = $false            #<bool>
        #MaintenancePeriod                   = "00.00:00:00"     #<timespan>
        MultipleInstances                   = "IgnoreNew"       #{Parallel | Queue | IgnoreNew}
        #NetworkId                           = ""                #<string>
        #NetworkName                         = ""                #<string>
        Priority                            = 7                 #<int>
        RestartCount                        = 0                 #<int>
        #RestartInterval                     = "00.00:00:00"     #<timespan>
        RestartOnIdle                       = $false            #<bool>
        RunOnlyIfIdle                       = $false            #<bool>
        RunOnlyIfNetworkAvailable           = $false            #<bool>
        StartWhenAvailable                  = $false            #<bool>    
        WakeToRun                           = $false            #<bool>
    }


}

