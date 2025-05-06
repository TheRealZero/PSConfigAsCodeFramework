
Describe "CreateEditOrDisableTasksFromConfigs.ps1" {
    Context "Error Handling" {
        It "Should write an error when the PSCServerModule fails to import" {
            # Arrange
            $errorMessage = "Error importing module PSCServerModule"
            

            Mock -CommandName Import-Module -MockWith {
                Throw [System.Exception]::new($mockExceptionMessage)
            }

            

            # Act
            . "$PSScriptRoot/CreateEditOrDisableTasksFromConfigs.ps1"

            # Assert
            Assert-MockCalled -CommandName Write-Error -Exactly 1 -Scope It -ParametersMatch {
                $args[0] -eq $errorMessage
            }

        }
        It "Should write a verbose message when there is an error importing a config file" {
            #Arrange
            Mock Import-PowerShellDataFile -MockWith {
                Throw [System.Exception]::new("Error importing config file")
            }
            Mock Register-ScheduledTask -MockWith {
                [pscustomobject]@{
                    TaskName = "TestTask"
                    Action   = "TestAction"
                    Trigger  = "TestTrigger"
                }
            }

            #Act
            . "$PSScriptRoot/CreateEditOrDisableTasksFromConfigs.ps1"

            #Assert
            Assert-MockCalled -CommandName Write-Verbose -Exactly 1 -Scope It -ParametersMatch {
                $args[0] -eq "Error importing config file"
            }

        }
    
        
    }
    
}