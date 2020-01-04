<#
.SYNOPSIS
    Gets files and folders (and folder size).
.DESCRIPTION
    Long description
.PARAMETER Path
    Specifies the path to an item
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Get-ItemPlus {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [String[]]
        $Path
    )
    
    begin {
        Write-Verbose "Begin Block"
    }
    
    process {
        Write-Verbose "Process Block"
        foreach ($item in $Path) {
            $itemInfo = Get-Item -Path $item
            $duResult = C:\Tools\SysInternalsSuite\du.exe $item -nobanner 2>$null
            $sizeInBytes = [int64] $duResult[2].Substring(0,$duResult[2].IndexOf(' bytes')).Substring('Size:         '.Length)
            Add-Member -InputObject $itemInfo -NotePropertyName 'SizeInBytes' -NotePropertyValue $sizeInBytes -PassThru
        }
    }
    
    end {
        Write-Verbose "End Block"
    }
}