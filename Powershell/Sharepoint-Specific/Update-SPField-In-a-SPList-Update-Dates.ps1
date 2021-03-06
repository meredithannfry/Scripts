##################################################################################
#
#
#  Script name: 	Update-SPField-In-a-SPList-Update_Dates.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	16/01/2013
# 
#
##################################################################################

param([string]$csvfile, [switch]$help)
#Load Assembly
[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

function GetHelp() {


$HelpText = @"

DESCRIPTION:
NAME: FixSIArchiveItemsDates

PARAMETERS: 
-csvfile: csv file to process.

SYNTAX:

FixSIArchiveItemsDates -csvfile "SIItemsToUpdate.20130124-1445.csv"

Processes the items of interest to a specified CSV from "SIItemsToUpdate"

FixSIArchiveItemsDates -help

Displays the help topic for the script

"@
$HelpText

}

#Load Assembly
[system.reflection.assembly]::LoadWithPartialName("microsoft.sharepoint")
$env:path = $env:path +";D:\Scripts\Collection"
Write-Host $env:path

#URL of Site Collection
$url = "http://xxxx:14000"
Write-host $url

#Other Variables
#$csvfile = ".\SIItemsToUpdate.csv" #This is for the log file
$csvDate = Get-Date -format yyyyMMdd-HHmm
$csvOutput = ".\SIItemsUpdated." + $csvDate + ".csv"
$web = "/SE/SI/" #The subsite you are working on
$listname = "My Safety Interactions" 

#Load SP Objects
$spsite = New-Object microsoft.sharepoint.spsite($url)
$spweb = $spsite.Openweb($web)
$splist = $spweb.Lists[$listName]
$changeditems = @()

$csvItemsToUpdate = Import-Csv $csvfile

#Disable alerts for that list
$changedalerts =  New-Object System.Collections.ArrayList
foreach ($spalert in $spweb.alerts)
{
	if (($spalert.listurl -eq $splist.Rootfolder.Url) -and ($spalert.status -eq "On"))
	{
		$changedalerts.add($spalert.id.ToString())
		$spalert.status = "Off"
		write-host -foreground red "Alert disabled: "$spalert.id.ToString()
	}
}

#Start counters
$count = 0
$limit = 0
$ElapsedTime = [System.Diagnostics.Stopwatch]::StartNew()
write-host "Script Started:`t$(get-date)"

$numberToProcess = 5000

#Perform updates
foreach ($itemToUpdate in $csvItemsToUpdate)
{
	if($itemToUpdate.Processed -eq $false) {
		$item = $splist.GetItemById($itemToUpdate.ID);
        Write-Host $item
	
		$dateOfObservation = $null
		$followUpDate = $null
		$dueDate = $null
		$created = $null
		$modified = $null
	
		if ($item["Date of Observation"] -ne $NULL)
		{
		    $item["Date of Observation"] = $item["Date of Observation"].AddHours(10);
			$dateOfObservation = $item["Date of Observation"];
		}
		if ($item["Follow Up Due Date"] -ne $NULL)
		{
		    $item["Follow Up Due Date"] = $item["Follow Up Due Date"].AddHours(10);
			$followUpDate = $item["Follow Up Due Date"];
		}
		if ($item["Due Date"] -ne $NULL)
		{
		    $item["Due Date"] = $item["Due Date"].AddHours(10);
			$dueDate = $item["Due Date"];
		}
		if ($item["Created"] -ne $NULL)
		{
		    $item["Created"] = $item["Created"].AddHours(10);
			$created = $item["Created"];			
		}
		if ($item["Modified"] -ne $NULL)
		{
		    $item["Modified"] = $item["Modified"].AddHours(10);
			$modified = $item["Modified"];
		}
		
		$item.Update()

		$itemToUpdate.Processed = $true
		
		$changeditems += @{
			ID = $itemToUpdate.ID
			Location = $item["Location"]
			Group = $item["Group"]
			Division = $item["Division"]
			Section = $item["Section"]
			CreatedBy = $item["Created By"]
			DateOfObservation = $dateOfObservation
			FollowUpDate = $followUpDate
			DueDate = $dueDate
			Created = $created
			Modified = $modified
		};
		
		$count ++
		$limit ++

		write-host -nonewline "."
		if ($limit -eq 5000){
			write-host -foreground darkcyan "$count"
			$limit = 0
		}
	}
	
	if($count -eq $numberToProcess) {
		break;
	}
}

#Stop timer / display output
$ElapsedTime.Stop()
$Seconds = $ElapsedTime.ElapsedMilliseconds / 1000
$averagespeed = $count / $Seconds
write-host "`n`nScript Ended:`t$(get-date)`nTotal records:`t$count`nTotal Time:`t$($ElapsedTime.Elapsed.ToString())`nRecords/Second:`t$averagespeed`n`n"
$changeditems | select @{label='ID';expression={$_["ID"];}},@{label='Location';expression={$_["Location"];}},@{label='Group';expression={$_["Group"];}},@{label='Division';expression={$_["Division"];}},@{label='Section';expression={$_["Section"];}},@{label='Date of Observation';expression={$_["DateOfObservation"];}},@{label='Created By';expression={$_["CreatedBy"];}},@{label='Created';expression={$_["Created"];}},@{label='Follow Up Due Date';expression={$_["FollowUpDate"];}},@{label='Due Date';expression={$_["DueDate"];}} | Export-Csv -Path $csvOutput -NoTypeInformation
$csvItemsToUpdate | Export-Csv -Path $csvfile -NoTypeInformation
write-host "File output to $csvOutput`n`n"

#Re-enable alerts for the list
foreach ($spalert in $spweb.alerts)
{
	
		if ($spalert.id.ToString() -match $changedalerts)
		{
			$spalert.status = "On"
			$spalert.update()
			write-host -foreground red "Alert re-enabled: "$spalert.id.ToString()
		}
		$changedalerts.remove($spalert.id.ToString())
}

