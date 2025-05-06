BeforeDiscovery{
}
Describe "File Structure"{
    $script:serverScriptsPath = "$env:GitRepos\PSConfigAsCodeFramework\ServerScripts"
    Context "The TaskConfigData directory"{
        It "Should exist"{
            Test-Path -Path $(Join-Path -Path $serverScriptsPath -ChildPath "TaskConfigData") | Should -Be $true
        }
        It "Should only contain .PSD1 files"{
            $dirs = Get-ChildItem -Path $serverScriptsPath -Recurse -Directory -Filter "TaskConfigData"
            $dirs | ForEach-Object {
                Get-ChildItem -Path $_ |
                    Foreach-Object {
                        $_.Extension | Should -Be ".psd1"
                    }
            }
        }
    }
}