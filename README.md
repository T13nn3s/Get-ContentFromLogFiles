# Get-ContentFromLogFiles
Check multiple log files for specific words or sentences and creates a new entry in the Event Viewer. After running the script it will start recursively for LogFiles with a .log extension. After finding the SearchString it will log a warning in the Application log(EventID 10998). When the script does not find the specified search word/sentence it will create an Information Entry in the Event Viewer(EventID 10999).

# How to use
First, you need to import this function into your Powershell session.
```powershell
Import-Module .\Get-ContentFromLogFiles
```
Now you're ready to use this function.
```powershell
Get-ContentFromLogFiles -LogFolderPath C:\Folder -SearchString failed
```

With this script, you do not have to monitor the logfiles by yourself for an error. When this script finds an error in the logfiles it will create a warning in the Event Viewer.

When the specified word/sentence is found:

EventID: 10998
Logname: Application
EntryType: Warning
Source: CheckLogFiles
Message: The word/sentence '$SearchString' found in the LogFiles in $LogFolderPath.`n`nLogFiles: $results.

When the script cannot found the word/sentence specified:

EventID: 10999
Logname: Application
EntryType: Information
Source: CheckLogFiles
Message: The word/sentence '$SearchString' not found in the LogFiles in $LogFolderPath.

# Changelog

## [1.0] 3 April 2018
Initial creation
