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
# Disk settings
#

# Minimum diskspace in %
$iDiskspace = 20
#$aDiskspace += @(
#    [Eventfilter]@{Drive='C:'; FreePercent=20; FreeSpace=0}
#)


#
# Processes
#

# Number of top processes
$iProccesses = 10


#
# System events settings
#

# Display events for the last hours
$iSystemEventLastHours = 25
#$aSystemEventEventfilter += @(
#    [Eventfilter]@{Level=3; ProviderName='Disk'; Id=1}
#)


#
# Applicaton events settings
#

# Display events for the last hours
$iApplicationEventLastHours = 25
#$aApplicationEventEventfilter += @(
#    [Eventfilter]@{Level=3; ProviderName='Disk'; Id=1}
#)

#
# Service settings
#

#$aServicefilter += @(
#    [Servicefilter]@{Name='edgeupdate'}
#)
