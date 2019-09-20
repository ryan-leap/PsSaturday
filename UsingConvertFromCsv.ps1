
# Making objects from Command Line Utilities the easy way...

$rawConversion = & C:\Tools\SysInternalsSuite\du.exe -nobanner -c c:\tools | ConvertFrom-Csv
$result = $rawConversion | Select-Object Path,
  @{Name='CurrentFileCount'; Expression={[int] $_.CurrentFileCount}},
  @{Name='CurrentFileSize'; Expression={[int] $_.CurrentFileSize}},
  @{Name='FileCount'; Expression={[int] $_.FileCount}},
  @{Name='DirectoryCount'; Expression={[int] $_.DirectoryCount}},
  @{Name='DirectorySize'; Expression={[int] $_.DirectorySize}},
  @{Name='DirectorySizeOnDisk'; Expression={[int] $_.DirectorySizeOnDisk}}