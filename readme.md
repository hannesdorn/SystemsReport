## Synopsis

Small Powershell-Script to generate a systems report and send it as an email.
Small Powershell-Script to monitor free disk space

## How to start

see SystemsReport.cmd and SystemsMonitor.cmd

## Installation

Copy all files into a directory. Edit config/config.ps1.

Add a scheduled task once a day for SystemsReport.cmd
Add a scheduled task onec every 5 minutes for SystemsMonitor.cmd

### Creating a Telegram Bot

Telegram bots are created via an automated account called BotFather.

Open the Telegram app, click the search button and search for BotFather.
Click BotFather to open a chat. Or open the link https://telegram.me/botfather

- Next enter the command /newbot
- When prompted, enter the friendly name of your bot. In the example below I setup a bot called PowerShell Alerts. You can call your bot whatever you like
- Enter a username for the bot
- Take note of the API token. We will need this later. Note: it is case sensitive
- Finally click the link to open a chat with the newly created bot

Next you need to find your Telegram Chat ID.

- From the Telegram home screen, search for chatid_echo_bot. Click Chat ID Echo to open a chat
- Enter /start to get the bot to send you your Telegram Chat ID
- Take note of the Telegram Chat ID returned


## Contributors

This program is based on the works of Sean Duffy. See https://www.red-gate.com/simple-talk/sysadmin/powershell/building-a-daily-systems-report-email-with-powershell/

Hannes Dorn
hannes@dorn.cc

## License

GNU General Public License 3
https://www.gnu.org/licenses/gpl.html
