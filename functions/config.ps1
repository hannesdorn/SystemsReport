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
    [string]$Level = 0          # 1 = Critical, 2 = Error, 3 = Warning, 0 -> ignore
    [string]$ProviderName = ''  # '' -> ignore
    [int]$Id = 0                # 0 -> ignore
    [string]$Message = ''       # '' -> ignore, use regular expression
}

class Servicefilter {
    [string]$Name
}

class KerioConnectLogfile {
    [string]$Title = ''
    [string]$Path = ''          # C:\Program Files\Kerio\MailServer\store\logs\error.log
    [int]$LastHours = 25         # Only entries of the last 25 hours
    [string[]]$Filter = @()     # Display only entries containing one of the filter entries (regexp)
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
[Diskspace[]]$aDiskspace = @()
[KerioConnectLogfile[]]$aKerioConnectLogfile = @()
[int]$iProccesses = 10
[int]$iSystemEventLastHours = 25
[Eventfilter[]]$aSystemEventEventfilter = @()
[int]$iApplicationEventLastHours = 25
[Eventfilter[]]$aApplicationEventEventfilter = @()
[Servicefilter[]]$aServicefilter = @()
