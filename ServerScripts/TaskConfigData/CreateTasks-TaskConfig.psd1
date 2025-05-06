<#
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
    .Parameter TaskName
    The name of the task
    .Parameter TaskPath
    The path to the task in the task scheduler
    .Parameter Description
    A description of the task
#>
@{
    TaskAction  = @{
        Execute                         = 'powershell' 
        Argument                        = "-WindowStyle Hidden -File C:\GitHub\PSConfigAsCodeFramework\ServerScripts\CreateEditOrDisableTasksFromConfigs.ps1"
        #Id                              = '1'
        #WorkingDirectory                = 'D:\Manual Scripts'
    }

    TaskTrigger = @{
        Once                            = $true 
        #Daily                           = $true
        #Weekly                          = $true
        #AtStartup                       = $true
        #AtLogOn                         = $true
        #DaysOfWeek                      = 'Monday'
        At                              = '2:02'
        RepetitionInterval              = "00.00:10:00"

    }

    TaskPrincipal = @{
        UserId                          = 'AutomationUser'
        LogonType                       = 'Password'
        RunLevel                        = 'Highest'
        Id                              = 'Author'
    }
    PrincipalSecretName                 = 'AutomationUser'

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

    TaskName    = "Automation - Create New Scheduled Tasks from Task Config Files"
    TaskPath    = "\Automation\"
    Description = "Creates new scheduled tasks from task configuration files"
}

  
<#
    .EXAMPLE
        New-PSCServerScheduledTask -ConfigFilePath "C:\Scripts\TaskConfig.psd1"
        C:\Scripts\TaskConfig.psd1:
        @{
            TaskAction  = @{
                Execute                         = 'powershell' 
                Argument                        = '-WindowStyle Hidden -File "D:\Manual Scripts\Git-AndroidISDAutomation-Repo.ps1'
            }

            TaskTrigger = @{
                Once                            = $true 
                At                              = '2:00'
                RepetitionInterval              = "00.00:10:00"
            }

            TaskPrincipal = @{
                UserId                          = 'AutomationUser'
                LogonType                       = 'Password'
                RunLevel                        = 'Limited'
            }
            PrincipalSecretName                 = 'AutomationUser'

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

            TaskName    = 'Github - Pull AndroidISDAutomation'
            TaskPath    = "\Github Core\"
            Description = "Clones the AndroidISDAutomation Repo"

        }

    .NOTES
    
    Available options for Action:

        -Execute (example: 'powershell', 'cmd', 'notepad')
        -Argument (example: '-WindowStyle hidden -file "D:\Manual Scripts\Git-AndroidISDAutomation-Repo.ps1')
        -WorkingDirectory (example: 'D:\Manual Scripts')
        -Id <string>

    Available options for TaskTrigger:

        -Once <bool>
        -Daily <bool>
        -Weekly <bool>
        -AtStartup <bool>
        -AtLogOn <bool>
        -At <datetime>
        -RepetitionInterval <timespan>
        -RepetitionDuration <timespan>
        -DaysInterval <uint32>
        -WeeksInterval <uint32>
        -DaysOfWeek {Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday}
        -RandomDelay <timespan>
        -User <string>

    Available options for TaskSettingSet:

        -AllowStartIfOnBatteries <bool>
        -AsJob <bool>
        -CimSession <CimSession[]>
        -Compatibility {At | V1 | Vista | Win7 | Win8}
        -DeleteExpiredTaskAfter <timespan>
        -Disable <bool>
        -DisallowDemandStart <bool>
        -DisallowHardTerminate <bool>
        -DisallowStartOnRemoteAppSession <bool>
        -DontStopIfGoingOnBatteries <bool>
        -DontStopOnIdleEnd <bool>
        -ExecutionTimeLimit <timespan>
        -Hidden <bool>
        -IdleDuration <timespan>
        -IdleWaitTimeout <timespan>
        -MaintenanceDeadline <timespan>
        -MaintenanceExclusive <bool>
        -MaintenancePeriod <timespan>
        -MultipleInstances {Parallel | Queue | IgnoreNew}
        -NetworkId <string>
        -NetworkName <string>
        -Priority <int>
        -RestartCount <int>
        -RestartInterval <timespan>
        -RestartOnIdle <bool>
        -RunOnlyIfIdle <bool>
        -RunOnlyIfNetworkAvailable <bool>
        -StartWhenAvailable <bool>
        -WakeToRun <bool>
        
    Available options for TaskPrincipal:

        -UserId <string>
        -LogonType {None | Password | S4U | InteractiveToken | Group | Service | Batch | Interactive | Network | Cleartext}
        -RunLevel {LeastPrivilege | HighestAvailable}
        -GroupId <string>
        -ProcessTokenSidType {Default | Unrestricted | Restricted | AppContainer}
        -RequiredPrivilege {None | CreateToken | AssignPrimaryToken | LockMemory | IncreaseQuota | MachineAccount | TrustedComputingBase | Security | TakeOwnership | LoadDriver | SystemProfile | ProfileSingleProcess | IncreaseBasePriority | CreatePagefile | CreatePermanent | Backup | Restore | Shutdown | Debug | Audit | SystemEnvironment | ChangeNotify | RemoteShutdown | Undock | SyncAgent | EnableDelegation | ManageVolume | Impersonate | CreateGlobal | TrustedCredentialManagerAccess | ReserveProcessor | TrustedAppContainer | ReserveAll | AccessSystemSecurity | ProfileSystemPerformance | ProfileSingleProcessRestricted | IncBasePriorityPrivilege | CreateSymbolicLink | IncreaseWorkingSet | ManageAppContainer | CreateAppContainer | AccessFilterSecurities | AccessSystemTime | AccessTimeZone | CreateSymbolicLinkPrivilege | DebugPrivilege | SystemEnvironmentPrivilege | SystemProfilePrivilege | ProfileSingleProcessPrivilege | IncreaseBasePriorityPrivilege | CreatePagefilePrivilege | CreatePermanentPrivilege | BackupPrivilege | RestorePrivilege | ShutdownPrivilege | DebugPrivilege | AuditPrivilege | SystemEnvironmentPrivilege | ChangeNotifyPrivilege | RemoteShutdownPrivilege | UndockPrivilege | SyncAgentPrivilege | EnableDelegationPrivilege | ManageVolumePrivilege | ImpersonatePrivilege | CreateGlobalPrivilege | TrustedCredentialManagerAccessPrivilege | ReserveProcessorPrivilege | TrustedAppContainerPrivilege | ReserveAllPrivilege | AccessSystemSecurityPrivilege | ProfileSystemPerformancePrivilege | ProfileSingleProcessRestrictedPrivilege | IncBasePriorityPrivilege | CreateSymbolicLinkPrivilege | IncreaseWorkingSetPrivilege | ManageAppContainerPrivilege | CreateAppContainerPrivilege | AccessFilterSecuritiesPrivilege | AccessSystemTimePrivilege | AccessTimeZonePrivilege | CreateSymbolicLinkPrivilege | DebugPrivilege | SystemEnvironmentPrivilege | SystemProfilePrivilege | ProfileSingleProcessPrivilege | IncreaseBasePriorityPrivilege | CreatePagefilePrivilege | CreatePermanentPrivilege | BackupPrivilege | RestorePrivilege | ShutdownPrivilege | DebugPrivilege | AuditPrivilege | SystemEnvironmentPrivilege | ChangeNotifyPrivilege | RemoteShutdownPrivilege | UndockPrivilege | SyncAgentPrivilege | EnableDelegationPrivilege | ManageVolumePrivilege | ImpersonatePrivilege | CreateGlobalPrivilege | TrustedCredentialManagerAccessPrivilege | ReserveProcessorPrivilege | TrustedAppContainerPrivilege | ReserveAllPrivilege | AccessSystemSecurityPrivilege
    


    

    Quick Reference of the ScheduledTask Cmdlets:

    NAME
        New-ScheduledTask

        SYNTAX

        New-ScheduledTask [[-Action] <CimInstance#MSFT_TaskAction[]>] [[-Trigger] <CimInstance#MSFT_TaskTrigger[]>] [[-Settings] <CimInstance#MSFT_TaskSettings>] [[-Principal]   
        <CimInstance#MSFT_TaskPrincipal>] [[-Description] <string>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob]  [<CommonParameters>]

    NAME
        New-ScheduledTaskAction

        SYNTAX

        New-ScheduledTaskAction [-Execute] <string> [[-Argument] <string>] [[-WorkingDirectory] <string>] [-Id <string>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>]      
        [-AsJob]  [<CommonParameters>]


    NAME
        New-ScheduledTaskTrigger
        
        SYNTAX

        New-ScheduledTaskTrigger [-Once] -At <datetime> [-RandomDelay <timespan>] [-RepetitionDuration    
        <timespan>] [-RepetitionInterval <timespan>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>]  
        [-AsJob]  [<CommonParameters>]

        New-ScheduledTaskTrigger [-Daily] -At <datetime> [-DaysInterval <uint32>] [-RandomDelay
        <timespan>] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob]  [<CommonParameters>]    

        New-ScheduledTaskTrigger [-Weekly] -At <datetime> [-RandomDelay <timespan>] [-DaysOfWeek {Sunday  
        | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday}] [-WeeksInterval <uint32>]
        [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob]  [<CommonParameters>]

        New-ScheduledTaskTrigger [-AtStartup] [-RandomDelay <timespan>] [-CimSession <CimSession[]>]      
        [-ThrottleLimit <int>] [-AsJob]  [<CommonParameters>]

        New-ScheduledTaskTrigger [-AtLogOn] [-RandomDelay <timespan>] [-User <string>] [-CimSession       
        <CimSession[]>] [-ThrottleLimit <int>] [-AsJob]  [<CommonParameters>]


    NAME
        New-ScheduledTaskSettingsSet

        SYNTAX

        New-ScheduledTaskSettingsSet [-DisallowDemandStart] [-DisallowHardTerminate] [-Compatibility {At | V1 | Vista | Win7 | Win8}] [-DeleteExpiredTaskAfter <timespan>]        
        [-AllowStartIfOnBatteries] [-Disable] [-MaintenanceExclusive] [-Hidden] [-RunOnlyIfIdle] [-IdleWaitTimeout <timespan>] [-NetworkId <string>] [-NetworkName <string>]      
        [-DisallowStartOnRemoteAppSession] [-MaintenancePeriod <timespan>] [-MaintenanceDeadline <timespan>] [-StartWhenAvailable] [-DontStopIfGoingOnBatteries] [-WakeToRun]     
        [-IdleDuration <timespan>] [-RestartOnIdle] [-DontStopOnIdleEnd] [-ExecutionTimeLimit <timespan>] [-MultipleInstances {Parallel | Queue | IgnoreNew}] [-Priority <int>]   
        [-RestartCount <int>] [-RestartInterval <timespan>] [-RunOnlyIfNetworkAvailable] [-CimSession <CimSession[]>] [-ThrottleLimit <int>] [-AsJob]  [<CommonParameters>]       

#>