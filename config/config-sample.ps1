#
# Mail settings
#

# SMTP server
$sMailServer = "host.domain.loc"
$sMailServerPort = "25"
$sMailUsername = ""
$sMailPassword = ""
$fMailServerSSL = $false

# Sender
$sMailFrom = "administrator@domain.loc"

# Recipients, seperated by ","
$sMailTo = "it@domain.loc"
$sMailToMonitor = "it@domain.loc"


#
# Telegram Settings
#

$sTelegramToken = ""
$sTelegramChatId = ""


#
# Modules
#

$fSystem = $true
$fDisk = $true
$fWindowsUpdate = $true
$fSystemEvents = $true
$fApplicationEvents = $true
$fKerioConnect = $false
$fService = $true
$fProcess = $true


#
# Disk settings
#

# Minimum diskspace in %
$iDiskspace = 20
# $aDiskspace += @(
#     [Diskspace]@{Drive='C:'; FreePercent=0; FreeSpace=10}
#     [Diskspace]@{Drive='D:'; FreePercent=0; FreeSpace=10}
# )


#
# System events settings
#

# Display events for the last hours
$iSystemEventLastHours = 25
# $aSystemEventEventfilter += @(
#     [Eventfilter]@{Level=3; ProviderName='Disk'; Id=1; Message='.*'}
# )


#
# Applicaton events settings
#

# Display events for the last hours
$iApplicationEventLastHours = 25
# $aApplicationEventEventfilter += @(
#     [Eventfilter]@{Level=3; ProviderName='Disk'; Id=1; Message='.*'}
# )


#
# KerioConnect settings
#

# $aKerioConnectLogfile += @(
#     [KerioConnectLogfile]@{
#         Title = 'error.log'
#         Path = 'C:\Program Files\Kerio\MailServer\store\logs\error.log'
#         LastHours = 25
#         Include = @(
#             '.*{smtps}.*',
#             '.*{spam}.*'
#         )
#     }
# )


#
# Processes
#

# Number of top processes
$iProccesses = 10


#
# Service settings
#

# $aServicefilter += @(
#     [Servicefilter]@{Name='edgeupdate'}
# )
