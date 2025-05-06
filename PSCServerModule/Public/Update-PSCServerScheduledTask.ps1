Function Update-PSCServerScheduledTask {
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
        Write-Error "Config file not found at $ConfigFilePath" -ErrorAction Stop
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
            Action    = $objTaskAction
            Principal = $objTaskPrincipal
            Trigger   = $objTaskTrigger
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

             
        $setTaskParams = @{
            TaskName = $taskConfig.TaskName
            TaskPath = $taskConfig.TaskPath    
        }
        Foreach ( $key in $taskTask.Keys) {
            $setTaskParams.Add($key, $taskTask[$key])  
        }

        If ( $taskConfig.taskprincipal.LogonType -in @("InteractiveOrPassword", "Password")) {
            $setTaskParams.Add("User", $taskPrincipal.UserId)
            $setTaskParams.Add("Password", $($principalCredential.GetNetworkCredential().Password))
            $setTaskParams.Remove("Principal")
        }
    }
    Catch {
        Write-Information "Error creating task parameters" -Verbose
        Write-Error $_.Exception.Message -ErrorAction Stop
        
    }

    Write-Information "Updating Task: $($setTaskParams.TaskName)." -Verbose
    $safeTaskParams = $setTaskParams | Select-Object -ExcludeProperty Password

    
    Try {
        If ( $PSCmdlet.ShouldProcess("Updating an existing scheduled task $($safeTaskParams | Out-String)", "$($setTaskParams.TaskName)", "Updating an existing scheduled task")) {
            Set-ScheduledTask @setTaskParams -Verbose:$false
        }
    }
    Catch {
        Write-Information "Error updating task" -Verbose
        Write-Error $_.Exception.Message -ErrorAction Stop
        
    }
    Finally {
        #lucas look into where this should go!
        Remove-Variable -Name setTaskParams -ErrorAction SilentlyContinue
    }

}
