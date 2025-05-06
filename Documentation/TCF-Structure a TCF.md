# Task Configuration File (TCF) Structure

The data in the TCF should consist of the following:
- `TaskName`: The name of the task to be scheduled.
- `TaskPath`: The path to the script that will be executed by the task.
- `Description`: A description of the task.
- `TaskAction`: The action to be performed by the task.
    - Execute (example: 'powershell', 'cmd', 'notepad')
    - Argument (example: '-WindowStyle hidden -file "C:\GitHub\Git-Automation-Repo.ps1')
    - WorkingDirectory (example: 'D:\Manual Scripts')
    - Id <string>

- `TaskTrigger`: The trigger for the task.

    - Once <bool>
    - Daily <bool>
    - Weekly <bool>
    - AtStartup <bool>
    - AtLogOn <bool>
    - At <datetime>
    - RepetitionInterval <timespan>
    - RepetitionDuration <timespan>
    - DaysInterval <uint32>
    - WeeksInterval <uint32>
    - DaysOfWeek {Sunday | Monday | Tuesday | Wednesday | Thursday | Friday | Saturday}
    - RandomDelay <timespan>
    - User <string>

- `TaskSettingSet`: The settings for the task.

    - AllowStartIfOnBatteries <bool>
    - AsJob <bool>
    - CimSession <CimSession[]>
    - Compatibility {At | V1 | Vista | Win7 | Win8}
    - DeleteExpiredTaskAfter <timespan>
    - Disable <bool>
    - DisallowDemandStart <bool>
    - DisallowHardTerminate <bool>
    - DisallowStartOnRemoteAppSession <bool>
    - DontStopIfGoingOnBatteries <bool>
    - DontStopOnIdleEnd <bool>
    - ExecutionTimeLimit <timespan>
    - Hidden <bool>
    - IdleDuration <timespan>
    - IdleWaitTimeout <timespan>
    - MaintenanceDeadline <timespan>
    - MaintenanceExclusive <bool>
    - MaintenancePeriod <timespan>
    - MultipleInstances {Parallel | Queue | IgnoreNew}
    - NetworkId <string>
    - NetworkName <string>
    - Priority <int>
    - RestartCount <int>
    - RestartInterval <timespan>
    - RestartOnIdle <bool>
    - RunOnlyIfIdle <bool>
    - RunOnlyIfNetworkAvailable <bool>
    - StartWhenAvailable <bool>
    - WakeToRun <bool>
        
- `TaskPrincipal`: The principal for the task.

    - UserId <string>
    - LogonType {None | Password | S4U | InteractiveToken | Group | Service | Batch | Interactive | Network | Cleartext}
    - RunLevel {LeastPrivilege | HighestAvailable}
    - GroupId <string>
    - ProcessTokenSidType {Default | Unrestricted | Restricted | AppContainer}
    - RequiredPrivilege None | CreateToken | AssignPrimaryToken | LockMemory | IncreaseQuota | MachineAccount | TrustedComputingBase | Security | TakeOwnership | LoadDriver | SystemProfile | ProfileSingleProcess | IncreaseBasePriority | CreatePagefile | CreatePermanent | Backup | Restore | Shutdown | Debug | Audit | SystemEnvironment | ChangeNotify | RemoteShutdown | Undock | SyncAgent | EnableDelegation | ManageVolume | Impersonate | CreateGlobal | TrustedCredentialManagerAccess | ReserveProcessor | TrustedAppContainer | ReserveAll | AccessSystemSecurity | ProfileSystemPerformance | ProfileSingleProcessRestricted | IncBasePriorityPrivilege | CreateSymbolicLink | IncreaseWorkingSet | ManageAppContainer | CreateAppContainer | AccessFilterSecurities | AccessSystemTime | AccessTimeZone | CreateSymbolicLinkPrivilege | DebugPrivilege | SystemEnvironmentPrivilege | SystemProfilePrivilege | ProfileSingleProcessPrivilege | IncreaseBasePriorityPrivilege | CreatePagefilePrivilege | CreatePermanentPrivilege | BackupPrivilege | RestorePrivilege | ShutdownPrivilege | DebugPrivilege | AuditPrivilege | SystemEnvironmentPrivilege | ChangeNotifyPrivilege | RemoteShutdownPrivilege | UndockPrivilege | SyncAgentPrivilege | EnableDelegationPrivilege | ManageVolumePrivilege | ImpersonatePrivilege | CreateGlobalPrivilege | TrustedCredentialManagerAccessPrivilege | ReserveProcessorPrivilege | TrustedAppContainerPrivilege | ReserveAllPrivilege | AccessSystemSecurityPrivilege | ProfileSystemPerformancePrivilege | ProfileSingleProcessRestrictedPrivilege | IncBasePriorityPrivilege | CreateSymbolicLinkPrivilege | IncreaseWorkingSetPrivilege | ManageAppContainerPrivilege | CreateAppContainerPrivilege | AccessFilterSecuritiesPrivilege | AccessSystemTimePrivilege | AccessTimeZonePrivilege | CreateSymbolicLinkPrivilege | DebugPrivilege | SystemEnvironmentPrivilege | SystemProfilePrivilege | ProfileSingleProcessPrivilege | IncreaseBasePriorityPrivilege | CreatePagefilePrivilege | CreatePermanentPrivilege | BackupPrivilege | RestorePrivilege | ShutdownPrivilege | DebugPrivilege | AuditPrivilege | SystemEnvironmentPrivilege | ChangeNotifyPrivilege | RemoteShutdownPrivilege | UndockPrivilege | SyncAgentPrivilege | EnableDelegationPrivilege | ManageVolumePrivilege | ImpersonatePrivilege | CreateGlobalPrivilege | TrustedCredentialManagerAccessPrivilege | ReserveProcessorPrivilege | TrustedAppContainerPrivilege | ReserveAllPrivilege | AccessSystemSecurityPrivilege