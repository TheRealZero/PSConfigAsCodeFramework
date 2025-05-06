Function New-PSCServerScheduledTask {
    <#
    .SYNOPSIS
    Creates a new scheduled task on a server
    .DESCRIPTION
    This script creates a new scheduled task on a server using the parameters in a config file
    .PARAMETER ConfigFilePath
    The path to the config file containing the parameters for the scheduled task
    .EXAMPLE
    New-PSCServerScheduledTask -ConfigFilePath "C:\Scripts\TaskConfig.psd1"
#>
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param (
        [Parameter(Mandatory = $true, HelpMessage = "The path to the config file containing the parameters for the scheduled task")]
        [string]$ConfigFilePath
    )
    
    
    Try {
        Test-Path $ConfigFilePath -ErrorAction Stop | Out-Null
    }
    Catch {
        Write-Error "Config file not found at $ConfigFilePath"
    }

    Try {
        Import-PowerShellDataFile -Path $ConfigFilePath -OutVariable taskconfig -ErrorAction STOP | Out-Null
        Write-Information "Imported config file: $($ConfigFilePath)" -Verbose
    }
    Catch {
        Write-Information "Error importing config file" -Verbose
        Write-Error $_.Exception.Message -ErrorAction Stop

    }

    Try {
           
        $taskAction = $taskConfig.TaskAction
        $objTaskAction = New-ScheduledTaskAction @taskAction -ErrorAction STOP
        
        $taskTrigger = $taskConfig.TaskTrigger
        $objTaskTrigger = New-ScheduledTaskTrigger @tasktrigger -ErrorAction STOP
        
        $taskPrincipal = $taskConfig.TaskPrincipal
        $objTaskPrincipal = New-ScheduledTaskPrincipal @taskPrincipal -ErrorAction STOP
        
        $taskTask = @{
            Description = $taskConfig.Description
            Action      = $objTaskAction
            Principal   = $objTaskPrincipal
            Trigger     = $objTaskTrigger
        }
        If ( $null -ne $taskConfig.TaskSettingSet ) {
            $taskSettingSet = $taskConfig.TaskSettingSet
            $objTaskSettingSet = New-ScheduledTaskSettingsSet @taskSettingSet -ErrorAction STOP
            $taskTask.Add("Settings", $objTaskSettingSet)
        }
        
        If ( $taskConfig.PrincipalSecretName ) {
            Try {
                $principalCredential = Get-Secret -Name $taskConfig.PrincipalSecretName -ErrorAction STOP
            }
            Catch {
                Write-Information "Error getting principal secret: $($TaskConfig.PrincipalSecretName)" -Verbose
                Write-Error $_.Exception.Message -Verbose -ErrorAction Stop

            }
        }

        
        $objTask = New-ScheduledTask @taskTask -ErrorAction STOP

        $registerTaskParams = @{
            TaskName    = $taskConfig.TaskName
            TaskPath    = $taskConfig.TaskPath
            InputObject = $objTask

        }

        If ( $taskConfig.taskprincipal.LogonType -in @("InteractiveOrPassword", "Password")) {
            $registerTaskParams.Add("User", $taskPrincipal.UserId)
            $registerTaskParams.Add("Password", $($principalCredential.GetNetworkCredential().Password))
        }
    }
    Catch {
        Write-Information "Error creating task parameters" -Verbose
        Write-Information $_.Exception.Message -Verbose
    }

    Write-Information "Registering Task: $($registerTaskParams.TaskName)." -Verbose
    $safeTaskParams = $registerTaskParams | Select-Object -ExcludeProperty Password
    Write-Verbose "$($safeTaskParams | Out-String)"
    Try {
        If ( $PSCmdlet.ShouldProcess("Registering a new scheduled task $($safeTaskParams | Out-String)", "$($registerTaskParams.TaskName)", "Registering scheduled task")) {
            Register-ScheduledTask @registerTaskParams -Verbose:$false -ErrorAction Stop
        }
    }
    Catch {
        Write-Information "Error registering task: $($registerTaskParams.TaskName)." -Verbose
        Write-Information $_.Exception.Message -Verbose
    }
    Finally {
        #lucas look into where this should go!
        Remove-Variable -Name registerTaskParams -ErrorAction SilentlyContinue
    }
}
