param(
    [Parameter(Mandatory = $false, Position = 0, HelpMessage = "The path to the directory containing subdirectories to search for config files.")]
    [string]$ConfigDirectoryPath = "$env:PSCWorkloadRepoPath",
    [string[]]$TaskPath = @("\PSCAutomation\","\Github Core\")
)

Start-Transcript -Path $(Join-Path -Path $env:PSCLogOutputPath -ChildPath "CreateEditOrDisableTasksFromConfigs.log") -Append
Try {
    Import-Module "$PSScriptROOT\..\PSCServerModule" -ErrorAction Stop
}
Catch {
    Write-Error $_.Exception.Message
    Write-Error "Error importing module PSCServerModule" -ErrorAction Stop
    Break
}

$ConfigDirectoryPath = Resolve-Path $ConfigDirectoryPath
$TaskConfigDirs      = Get-ChildItem -Path $ConfigDirectoryPath -Recurse -Directory -Include "TaskConfigData"
$ConfigFiles         = $TaskConfigDirs.Fullname | Foreach-Object { Get-Childitem -Recurse -Path $_ -Include *.psd1 }
$currentTasks        = Get-ScheduledTask -TaskPath $TaskPath -ErrorAction SilentlyContinue
$configDataObjs      = Foreach ($configFile in $ConfigFiles) { 
    Try {
        
        $obj = Import-PowerShellDataFile -Path $configFile.FullName -ErrorAction STOP
        $obj | Add-Member -MemberType NoteProperty -Name ConfigFilePath -Value $configFile.FullName -Force
        Write-Output $obj
    }
    Catch {
        Write-Verbose "Error importing config file: $($configFile.FullName)." -Verbose
        Write-Verbose $_.Exception.Message -Verbose
    }
}
$orphanTasks         = Compare-Object -ReferenceObject $currentTasks -DifferenceObject $configDataObjs -Property TaskName, TaskPath -PassThru | Where-Object { $_.SideIndicator -eq "<=" }

Write-Verbose "Found $($ConfigFiles.FullName|Measure-Object | Select-Object -ExpandProperty Count) config files."      -Verbose
Write-Verbose "Found $($orphanTasks | Measure-Object | Select-Object -ExpandProperty Count) orphan tasks: " -Verbose
Write-Verbose "$($orphanTasks | Select-Object TaskName, TaskPath | Out-String)" -Verbose

Foreach ( $orphanTask in $orphanTasks ) { 
    Try {
        $orphanTask| Disable-ScheduledTask -Verbose -ErrorAction Stop
        Write-Verbose "Disabled task $($orphanTask.TaskName) in path $($orphanTask.TaskPath)" -Verbose
    }
    Catch {
        Write-Verbose "Error disabling task $($orphanTask.TaskName) in path $($orphanTask.TaskPath)" -Verbose
        Write-Verbose $_.Exception.Message -Verbose
    }
}

Foreach ($ConfigData in $configDataObjs) {

    If ( $null -ne $($currenttasks| Where-Object {$_.TaskName -eq $ConfigData.TaskName -AND $_.TaskPath -eq $ConfigData.TaskPath})) {
        Write-Verbose "Task $($ConfigData.TaskName) already exists. Editing task." -Verbose
        
        Try {
            Update-PSCServerScheduledTask -ConfigFilePath $ConfigData.ConfigFilePath -InformationAction Continue
            Write-Verbose "Task $($ConfigData.TaskName) updated." -Verbose
        }
        Catch {
            Write-Verbose "Error creating task from config file: $($ConfigData.ConfigFilePath)" -Verbose
            Write-Verbose $_.Exception.Message -Verbose
        }
    }


    Else {
        Write-Verbose "Task $($ConfigData.TaskName) does not exist. Creating task." -Verbose

        Try {
            New-PSCServerScheduledTask -ConfigFilePath $ConfigData.ConfigFilePath -InformationAction Continue
            Write-Verbose "Task $($ConfigData.TaskName) created" -Verbose
        }
        Catch {
            Write-Verbose "Error creating task from config file $($ConfigData.ConfigFilePath)" -Verbose
            Write-Verbose $_.Exception.Message -Verbose
        }
    }
}

Stop-Transcript