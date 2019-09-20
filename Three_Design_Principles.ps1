
<#
   Predictable (Verb-Noun)
#>

Get-Verb
(Get-Verb).Count
Get-Command -Verb Stop
# Not Kill, Not Abort, not End, Stop.
# Stop a Service, Stop a Process.  Predictable
Get-Command | Group-Object -Property Verb

# Parameter names are also predictable
Get-Command -ParameterName Credential























<#
   Discoverable
#>

Get-Help Import-Csv
Get-Help Import-Csv -Parameter Encoding
Get-Help Import-Csv -Examples
Get-Help Import-Csv -ShowWindow
Get-Help about_*










<#

   Composable

#>
import-csv C:\scripts\PsSaturday\flavors.csv
import-csv C:\scripts.PsSaturday\flavors | Group-Object -Property flavors
# where name like berry
# select name and count
# sort by count
# Why composability is possible?  Because in PowerShell results are
# objects and object properties can be mapped into the next cmdlet and so on







<#

   Parsing Output - The Easy Way (because the utility provides CSV)

#>
ConvertFrom-Csv

& C:\Tools\SysInternalsSuite\du.exe /?
& C:\Tools\SysInternalsSuite\du.exe -c C:\AutoLab\
& C:\Tools\SysInternalsSuite\du.exe -c C:\AutoLab\ -nobanner
& C:\Tools\SysInternalsSuite\du.exe -c C:\AutoLab\ -nobanner | ConvertFrom-Csv
& C:\Tools\SysInternalsSuite\du.exe -c C:\AutoLab\ -nobanner | ConvertFrom-Csv | get-member
$result = & C:\Tools\SysInternalsSuite\du.exe -c C:\AutoLab\ -nobanner | ConvertFrom-Csv
$result
$result.CurrentFileCount + 10
$result.CurrentFileCount.GetType().Name
$result.DirectorySize -is [string]
([int] $result.FileCount) + 3
$result | Select-Object -Property Path,@{Name='FileCount'; Expression={[int]$_.FileCount}}
$modifiedResult = $result | Select-Object -Property Path,@{Name='FileCount'; Expression={$_.FileCount}}
$modifiedResult.FileCount + 3
$modifiedResult = $result | Select-Object -Property Path,@{Name='FileCount'; Expression={[int]$_.FileCount}}
$modifiedResult.FileCount.GetType().Name
$modifiedResult.FileCount + 3
$modifiedResult = $result | Select-Object -Property Path,@{Name='FileCount'; Expression={[int]$_.FileCount}},@{Name='DirectoryCount'; Expression={[int]$_.DirectoryCount}}

$modifiedResult = $result | Select-Object -Property Path,
    @{Name='CurrentFileCount'; Expression={[int]$_.CurrentFileCount}},
    @{Name='CurrentFileSize'; Expression={[int]$_.CurrentFileSize}},
    @{Name='FileCount'; Expression={[int]$_.FileCount}},
    @{Name='DirectoryCount'; Expression={[int]$_.DirectoryCount}},
    @{Name='DirectorySize'; Expression={[int]$_.DirectorySize}},
    @{Name='DirectorySizeOnDisk'; Expression={[int]$_.DirectorySizeOnDisk}}
# Or...
$result.CurrentFileCount = [int] $result.CurrentFileCount
$result.CurrentFileSize = [int] $result.CurrentFileSize

<#

    Parsing Output - the hard way (Screen scraping)

#>

& C:\Tools\SysInternalsSuite\du.exe /?
& C:\Tools\SysInternalsSuite\du.exe C:\AutoLab\
& C:\Tools\SysInternalsSuite\du.exe C:\AutoLab\ -nobanner
$result = & C:\Tools\SysInternalsSuite\du.exe C:\AutoLab\ -nobanner
$result = & C:\Tools\SysInternalsSuite\du.exe C:\AutoLab\ -nobanner 2>$null
get-help about_Redirection
$result = & C:\Tools\SysInternalsSuite\du.exe -nobanner C:\AutoLab\ 2>$null
$result[0]
$result[0] | get-member
$result[0]
$result[1]
$result[2]
$result
$result[-1]
$result[-2]
$result[0].Substring(5)
$result[0].Substring('Files:        '.Length)
$result[1].Substring('Directories:  '.Length)
$result[2].Substring('Size:         '.Length)
$result
$result[2].IndexOf(' bytes')
$result[2].Substring(0,$result[2].IndexOf(' bytes'))
$result[2].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','')
$result[2].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','').Substring('Size:         '.Length)
[int] $result[2].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','').Substring('Size:         '.Length)+ 7

<#

    HashTable

    HashTable --> PS Custom Object

#>
$result = & C:\Tools\SysInternalsSuite\du.exe -nobanner $Path
[pscustomobject] @{
   'FileCount'           = [int64] $result[0].Substring('Files:        '.Length)
   'DirectoryCount'      = [int64] $result[1].Substring('Directories:  '.Length)
   'DirectorySize'       = [int64] $result[2].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','').Substring('Size:         '.Length)
   'DirectorySizeOnDisk' = [int64] $result[3].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','').Substring('Size on disk: '.Length)
}
