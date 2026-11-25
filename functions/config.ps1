#
# Mail settings
#

# SMTP server
[string]$sMailServer = "host.domain.loc"
[string]$sMailServerPort = "25"
[string]$sMailUsername = ""
[string]$sMailPassword = ""
[bool]$fMailServerSSL = $false

# Sender
[string]$sMailFrom = "administrator@domain.loc"

# Recipients, seperated by ","
[string]$sMailTo = "it@domain.loc"
[string]$sMailToMonitor = ""


#
# Telegram Settings
#

[string]$sTelegramToken = ""
[string]$sTelegramChatId = ""


#
# Modules
#

[bool]$fSystem = $true
[bool]$fDisk = $true
[bool]$fWindowsUpdate = $true
[bool]$fSystemEvents = $true
[bool]$fApplicationEvents = $true
[bool]$fKerioConnect = $false
[bool]$fService = $true
[bool]$fProcess = $true


#
# Disk settings
#

# 20 %/10 GB: if free space is lower than 20 % or is lower then 10 GB
# 0 %/10 GB: if free space is lower then 10 GB
# 20 %/0 GB: if free space is lower then 20 %
# 100 %/10 GB: disk is always listed
class Diskspace {
    [string]$Drive      # C:
    [int]$FreePercent   # 20 -> 20 %
    [float]$FreeSpace   # 10 -> 10 GB
}

[int]$iDiskspace = 20
[Diskspace[]]$aDiskspace = @()


#
# System events settings
#

class Eventfilter {
    [string]$Level = 0          # 1 = Critical, 2 = Error, 3 = Warning, 0 -> ignore
    [string]$ProviderName = ''  # '' -> ignore
    [int]$Id = 0                # 0 -> ignore
    [string]$Message = ''       # '' -> ignore, use regular expression
}

[int]$iSystemEventLastHours = 25
[Eventfilter[]]$aSystemEventEventfilter = @()


#
# Applicaton events settings
#

[int]$iApplicationEventLastHours = 25
[Eventfilter[]]$aApplicationEventEventfilter = @()

#
# KerioConnect settings
#

class KerioConnectLogfile {
    [string]$Title = ''
    [string]$Path = ''          # C:\Program Files\Kerio\MailServer\store\logs\error.log
    [int]$LastHours = 25         # Only entries of the last 25 hours
    [string[]]$Filter = @()     # Display only entries containing one of the filter entries (regexp)
}

[KerioConnectLogfile[]]$aKerioConnectLogfile = @()


#
# Processes
#

# Number of top processes
[int]$iProccesses = 10


#
# Service settings
#

class Servicefilter {
    [string]$Name
}

# Default settings
[Servicefilter[]]$aServicefilter = @()
