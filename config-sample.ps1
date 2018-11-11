#
# Mail settings
#

# SMTP server
[string]$sMailServer = "host.domain.loc"

# Sender
[string]$sMailFrom = "administrator@domain.loc"

# Recipients, seperated by ","
[string]$sMailTo = "it@domain.loc"


#
# Disk settings
#

# Minimum diskspace in %
[int]$iDiskspace = 20


#
# Processes
#

# Number of top processes
[int]$iProccesses = 10


#
# System events settings
#

# Display events for the last hours
[int]$iSystemEventLastHours = 25


#
# Applicaton events settings
#

# Display events for the last hours
[int]$iApplicationEventLastHours = 25
