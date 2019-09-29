
<#
   Predictable (Verb-Noun)
#>

Get-Verb
(Get-Verb).Count
Get-Command -Verb Stop
# Not Kill, Not Abort, not End, Stop.
# Stop a Service, Stop a Process.  Predictable
Get-Command | Group-Object -Property Verb
Get-Command -CommandType Cmdlet | Group-Object -Property Verb | Sort-Object -Property Count

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
import-csv C:\scripts.PsSaturday\flavors | Where-Object -Property Flavor -Like '*berry*' |
Group-Object -Property flavors | Sort-Object -Property Count


<#

   Parsing Output - The Easy Way (because the utility provides CSV)

#>

& C:\Tools\SysInternalsSuite\du.exe /?
& C:\Tools\SysInternalsSuite\du.exe -nobanner C:\AutoLab\
$result = & C:\Tools\SysInternalsSuite\du.exe -c C:\AutoLab\ -nobanner | ConvertFrom-Csv

<#

    Parsing Output - the hard way (Screen scraping)

#>
$result = & C:\Tools\SysInternalsSuite\du.exe C:\AutoLab\ -nobanner 2>$null
get-help about_Redirection
$result[2].IndexOf(' bytes')
$result[2].Substring(0,$result[2].IndexOf(' bytes'))
$result[2].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','')
$result[2].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','').Substring('Size:         '.Length)
[int] $result[2].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','').Substring('Size:         '.Length)+ 7


<#

    HashTable

    HashTable --> PS Custom Object

#>
$result = & C:\Tools\SysInternalsSuite\du.exe -nobanner $Path 2>$null
[pscustomobject] @{
   'FileCount'           = [int64] $result[0].Substring('Files:        '.Length)
   'DirectoryCount'      = [int64] $result[1].Substring('Directories:  '.Length)
   'DirectorySize'       = [int64] $result[2].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','').Substring('Size:         '.Length)
   'DirectorySizeOnDisk' = [int64] $result[3].Substring(0,$result[2].IndexOf(' bytes')).Replace(',','').Substring('Size on disk: '.Length)
}

# Advanced Function

# Cut & Paste from ISE snippet