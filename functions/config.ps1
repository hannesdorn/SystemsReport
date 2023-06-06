# List disk
# 20 %/10 GB: if free space is lower than 20 % or is lower then 10 GB
# 0 %/10 GB: if free space is lower then 10 GB
# 20 %/0 GB: if free space is lower then 20 %
# 100 %/10 GB: disk is always listed
class Diskspace {
    [string]$Drive      # C:
    [int]$FreePercent   # 20 -> 20 %
    [float]$FreeSpace   # 10 -> 10 GB
}

class Eventfilter {
    [string]$Level      # 1 = Critical, 2 = Error, 3 = Warning,
    [string]$ProviderName
    [int]$Id
}

class Servicefilter {
    [string]$Name
}

# Default settings
[string]$sMailServer = "host.domain.loc"
[string]$sMailServerPort = "25"
[string]$sMailUsername = ""
[string]$sMailPassword = ""
[bool]$fMailServerSSL = $false
[string]$sMailFrom = "administrator@domain.loc"
[string]$sMailTo = "it@domain.loc"
[int]$iDiskspace = 20
[array]$aDiskspace = @()
[int]$iProccesses = 10
[int]$iSystemEventLastHours = 25
[array]$aSystemEventEventfilter = @()
[int]$iApplicationEventLastHours = 25
[array]$aApplicationEventEventfilter = @()
[array]$aServicefilter = @()
