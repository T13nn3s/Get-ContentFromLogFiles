<#
.SYNOPSIS
    Check multiple log files for specific words or sentences and creates a new entry in the Event Viewer.
.DESCRIPTION
    After running the script it will start recursively for LogFiles with a .log extension. After finding the SearchString it will log a warning in the Application log(EventID 10998). When the script does not find the specified search word/sentence it will create an Information Entry in the Event Viewer(EventID 10999).
.EXAMPLE
    Get-ContentFromLogFiles -LogFolderPath C:\Folder -SearchString failed
.NOTES
    Created by  : T13nn3s
    Version     : 1.0 (3 april 2018)
#>
function Get-ContentFromLogFiles {
    [cmdletbinding()]

    param(
        #Specify folder wich recursively been searched for .log files
        [parameter(Mandatory = $true, Position = 1,
            HelpMessage = "Specify top folder for recursively check for specific string in logfiles."
        )][alias("folder")]
        [string]
        $LogFolderPath,

        #Specifies the search word/sentence
        [parameter(
            Mandatory = $True, Position = 2,
            HelpMessage = "Specify search string"
        )][alias("Search")]
        [string]
        $SearchString
    ) 

    $source = "CheckLogFiles"

    #EventLog settings
    $parameters = @{
        'LogName' = 'Application'
        'Source'  = "$source"
    }
    try {
        Get-Eventlog -LogName Application -source $source -ErrorAction Ignore | Out-Null
    }
    catch {
        New-EventLog -LogName Application -Source $source 
    }

    #search for word/sentence
    if ($results = Get-ChildItem C:\folder\*.log -Recurse | Select-String -Pattern "$Searchstring" | Out-String) {
        
        $parameters += @{
            'EventId'   = 10998
            'EntryType' = 'Warning'
            'Message'   = "The word/sentence '$SearchString' found in the LogFiles in $LogFolderPath.`n`nLogFiles: $results"
        }
        Write-EventLog @parameters
    }
    Else {
        $parameters += @{
            'eventid'   = 10999
            'entrytype' = 'Information'
            'Message'   = "The word/sentence '$SearchString' not found in the LogFiles in $LogFolderPath."
        }
        Write-EventLog @parameters
    } 
} 
