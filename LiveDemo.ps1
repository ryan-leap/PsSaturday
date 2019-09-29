<#
.Synopsis
   Obtain disk usage reporter (uses du.exe from Sysinternals)
   https://docs.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite 
.DESCRIPTION
   Demo wrapper code using Sysinternals Disk Usage Tool.  Demonstrates PowerShell's powers of amplification:

   Predictablitiy - Verb-Noun naming
   Discoverability - Built-in help w/Examples
   Composability - Pipeline support
.PARAMETER Path
   Specifies path to be checked for disk usage
.EXAMPLE
   Get-ChildItem C:\scripts\ -Directory | Get-SysInternalsDiskUsage
.EXAMPLE
   Get-ChildItem -Path (Join-Path -Path $env:USERPROFILE -ChildPath Downloads) -Directory -Recurse | Get-SysInternalsDiskUsage | Sort-Object -Property DirectorySize
.NOTES
   Written during (and tweaked after) PowerShell Saturday RTPSUG (https://rtpsug.com/pssaturday) talk
   'Why Can't We Be Friends: PowerShell & Command Line Utilities'
   
   Author/Speaker:
   - Ryan Leap
   - GitHub: https://github.com/ryan-leap
   - Twitter: @leap_ryan
#>
function Get-SysInternalsDiskUsage
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([pscustomobject])]
    Param
    (
        # Path to directory
        [ValidateScript({Test-path -Path $_ -PathType Container})]
        [Alias('FullName')]
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string] $Path

    )

    Begin
    {
        Write-Verbose "Begin block"
    }
    Process
    {
        Write-Verbose "Process block"
        $result = & C:\Tools\SysInternalsSuite\du.exe -nobanner $Path 2>$null
        [pscustomobject] @{
            'Path'                = $Path
            'FileCount'           = [int64] $result[0].Substring('Files:        '.Length)
            'DirectoryCount'      = [int64] $result[1].Substring('Directories:  '.Length)
            'DirectorySize'       = [int64] $result[2].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','').Substring('Size:         '.Length)
            'DirectorySizeOnDisk' = [int64] $result[3].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','').Substring('Size on disk: '.Length)
         }
         
    }
    End
    {
        Write-Verbose "End block"
    }
}