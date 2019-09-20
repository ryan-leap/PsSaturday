<#
.Synopsis
   PowerShell wrapper of the SysInternals Disk Usage Utility
.DESCRIPTION
   PowerShell wrapper of the SysInternals Disk Usage Utility
.PARAMETER Path
   Specifies the path to a directory
.PARAMETER UtilityPath
   Specifies the path to the SysInternals Disk Usage command line utility
.EXAMPLE
   Get-SysInternalsDiskUsage -Path 'C:\AutoLab'
.EXAMPLE
   Get-ChildItem -Recurse -Directory -Path "$ENV:USERPROFILE\Downloads" | Get-SysInternalsDiskUsage
#>
function Get-SysInternalsDiskUsage
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string] $Path,

        [Parameter(Mandatory = $false)]
        [string] $UtilityPath = 'c:\tools\SysInternalsSuite\du.exe'

    )

    Begin {
    }

    Process {
         $splat = @($Path,'-nobanner')
         $result = & $UtilityPath @splat 2>$null
         Write-Verbose "Collecting disk size info from path [$Path]"
         [pscustomobject] [ordered]@{
             'Path'           = $Path
             'FileCount'      = ($result[0].Substring('Files:        '.Length))
             'DirectoryCount' = ($result[1].Substring('Directories:  '.Length))
             'SizeInMB'       = [int] ([math]::Round($result[2].Substring(0, $result[2].IndexOf(' bytes')).Substring('Size:         '.Length).Replace(',', '') / 1MB))
         }

    }

    End {
    }
}