#
# Mail settings
#

# SMTP server
[string]$sMailServer = "smtp"

# Sender
[string]$sMailFrom = "hannesd@private.dorn.local"

# Recipients, seperated by ","
[string]$sMailTo = "hannesd@private.dorn.local"


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
