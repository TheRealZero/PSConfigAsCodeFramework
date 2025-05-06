BeforeDiscovery{
    $null = Import-Module -Name PSCServerModule
}
Describe 'New-PSCServerScheduledTask' {
    Context 'When the config file is missing' {
        It 'Should return an error' {
            $ConfigFilePath = New-TemporaryFile
            Remove-Item -Path $ConfigFilePath
            $Result = New-PSCScheduledTask -ConfigFilePath $ConfigFilePath
            $Result | Should -BeNullOrEmpty
        }
    }
    Context 'When the config file is present' {
        It 'Should create a new scheduled task' {
            Get-ScheduledTask -TaskName 'TestTask' -ErrorAction SilentlyContinue | Unregister-ScheduledTask -ErrorAction SilentlyContinue
            
            $ConfigFilePath = "$PSScriptRoot\PSCServerModule\TestTaskConfig.psd1"
            New-PSCScheduledTask -ConfigFilePath $ConfigFilePath
            Get-ScheduledTask -TaskName 'TestTask' | Should -Not -BeNullOrEmpty
            Get-ScheduledTask -TaskName 'TestTask' | Start-ScheduledTask
            
        }
    }
}


