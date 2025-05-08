param(
    [string]$ManifestFilePath = $(Join-Path -Path $env:PSCWorkloadRepoPath -ChildPath 'PSConfigAsCodeFramework\PSCServerModule\PSCServerModule.psd1')
)
Try { Test-Path -Path $ManifestFilePath -ErrorAction Stop | Out-Null }
Catch { Write-Error "Manifest file not found at $ManifestFilePath" -ErrorAction Stop }

$manifest           = Get-Item      -Path $ManifestFilePath
$manifestFolder     = Split-Path    -Path $ManifestFilePath -Parent
$moduleName         = Get-ChildItem -Path $ManifestFilePath | Select-Object -ExpandProperty BaseName
$moduleScript       = Get-ChildItem -Path $manifestFolder\$moduleName.psm1
$publicFunctions    = Get-ChildItem -Path $manifestFolder\Public\*.ps1
$moduleManifest     = Import-PowerShellDataFile -Path $manifest

$currentModuleVersion   = [System.Version]$($moduleManifest.ModuleVersion)
$newModuleVersion       = [System.Version]::new($currentModuleVersion.major, $currentModuleVersion.minor, $currentModuleVersion.build + 1)
$updateManifestParams   = @{
    Path                    = $manifest
    ModuleVersion           = $newModuleVersion
    FunctionsToExport       = $publicFunctions.BaseName
}

Write-Verbose "Backing up manifest file: $manifest" -Verbose
Copy-Item -Path $manifest -Destination $(Join-Path $manifestFolder -ChildPath "$moduleName.psd1.bak")

Write-Verbose "Updating manifest file: $manifest" -Verbose
Update-ModuleManifest @updateManifestParams

Write-Verbose "Backing up module script: $moduleScript" -Verbose
Copy-Item -Path "$manifestFolder\$moduleName.psm1" -Destination $(Join-Path $manifestFolder -ChildPath "$moduleName.psm1.bak")

Write-Verbose "Updating module script: $moduleScript" -Verbose
$publicFunctions | Get-Content | Set-Content "$manifestFolder\$moduleName.psm1"


Write-Verbose "Removing then re-creating existing module output folder: $manifestFolder\BuildOutput\$moduleName" -Verbose
Remove-Item -Path $(Join-Path -Path $manifestFolder -ChildPath "\BuildOutput\$moduleName") -Recurse -Force -ErrorAction SilentlyContinue
New-Item    -Path $(Join-Path -Path $manifestFolder -ChildPath "\BuildOutput\$moduleName") -ItemType Directory

Write-Verbose "Copying manifest and module script to output folder: $manifestFolder\BuildOutput\$moduleName" -Verbose
Copy-Item -Path $manifest       -Destination $(Join-Path -Path $manifestFolder -ChildPath "\BuildOutput\$moduleName\$moduleName.psd1")
Copy-Item -Path $moduleScript   -Destination $(Join-Path -Path $manifestFolder -ChildPath "\BuildOutput\$moduleName\$moduleName.psm1")

Write-Verbose "Publishing module to Automation repository" -Verbose
Publish-Module -Repository AutomationPowerShellGallery -Path "$manifestFolder\BuildOutput\$moduleName" -Verbose