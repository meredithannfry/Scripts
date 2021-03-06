##################################################################################
#
#
#  Script name: 	ExtractSpListToCSV.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	20/01/2013
# 
#
##################################################################################

#-------------------
 
$dtStart = Get-Date

Function RenderStats($start, $end) {
 Write-Host
    Write-Host "--------------------------"
    Write-Host "Started: $start"
 Write-Host "Finished: $end"
    Write-Host "--------------------------"
 
 $ts = New-TimeSpan -Start $start -End $end
 [string] $tsOut = "{0:00}:{1:00}:{2:00}:{3:00}" -f ($ts | % { $_.Hours, $_.Minutes, $_.Seconds, $_.Milliseconds })
 
 Write-Host "Time taken: $tsOut"
}

#--------------------


[Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") | out-null
$url = "https://xxxx"
$web = "/SafetyEnvironment"
$listname = "My List"
$path = "d:\data\Extracted.csv"

$site = new-object Microsoft.SharePoint.SPSite($url)
$spweb = $site.OpenWeb($web)

#Obtain the list to work with it.
$list = $spweb.Lists[$listname]

#if you want to filter to only items listed in a view
#$view = $list.Views["My View"] 
#$items = $list.GetItems($view)
Write-Host
Write-Host "Number of items in the whole list: " $list.Items.Count

$initialise = 0

$startid = $initialise
$upperbound = $startid + 4999
$limit = 5000

#Review the 5000 items at a time in the list and select any item that has been archived. At best this will be 5000 records, that is if they were all archived.
$archivedItems = $list.Items[$startid..$upperbound]| where {$_["Archived Date"] -ne $null} 

#Verify how many items there are in the List.
Write-Host
Write-Host "Number of archived items in the 5000 items in the list that we will process in this round: "  $archivedItems.Count

#Iterate through a range of the archived items and copy them into a CSV file. 
#Note: A processed flag will be appended to the end so that in our next script we can then confirm how many have been processed (in the event failure).
$archivedItems | %{select-object -input $_ -prop @{Name='ID';expression={$_["ID"];}},
@{Name='Accompanied By';expression={$_["Accompanied By"];}},
@{Name='Archived Date';expression={$_["Archived Date"];}},
@{Name='Area';expression={$_["Area"];}},
@{Name='calCreatedMonth';expression={$_["calCreatedMonth"];}},
@{Name='calCreatedYear';expression={$_["calCreatedYear"];}},
@{Name='calThisMonthBool';expression={$_["calThisMonthBool"];}},
@{Name='calTodayMonth';expression={$_["calTodayMonth"];}},
@{Name='calTodayYear';expression={$_["calTodayYear"];}},
@{Name='Category';expression={$_["Category"];}},
@{Name='Comments';expression={$_["Comments"];}},
@{Name='Conditions Observed';expression={$_["Conditions Observed"];}},
@{Name='CreatedMonth';expression={$_["CreatedMonth"];}},
@{Name='Date of Observation';expression={$_["Date of Observation"];}},
@{Name="Delegate's Comments";expression={$_["Delegate's Comments"];}},
@{Name='Description';expression={$_["Description"];}},
@{Name='Due Date';expression={$_["Due Date"];}},
@{Name='Encouragement Given';expression={$_["Encouragement Given"];}},
@{Name='Final Preventative Action';expression={$_["Final Preventative Action"];}},
@{Name='Follow Up Actions';expression={$_["Follow Up Actions"];}},
@{Name='Follow Up Due Date';expression={$_["Follow Up Due Date"];}},
@{Name='Follow Up Status';expression={$_["Follow Up Status"];}},
@{Name='Follow-up Delegation';expression={$_["Follow-up Delegation"];}},
@{Name='Function';expression={$_["Function"];}},
@{Name='General Comments';expression={$_["General Comments"];}},
@{Name='Group';expression={$_["Group"];}},
@{Name='Immediate Corrective Actions';expression={$_["Immediate Corrective Actions"];}},
@{Name='Location';expression={$_["Location"];}},
@{Name='Month';expression={$_["Month"];}},
@{Name='No. of People';expression={$_["No. of People"];}},
@{Name='Number of Safe Acts observed';expression={$_["Number of Safe Acts observed"];}},
@{Name='Number of Unsafe Acts observed';expression={$_["Number of Unsafe Acts observed"];}},
@{Name='Observer ID';expression={$_["Observer ID"];}},
@{Name="Observer's Name";expression={$_["Observer's Name"];}},
@{Name='Operating Procedures';expression={$_["Operating Procedures"];}},
@{Name='Orderliness Standards';expression={$_["Orderliness Standards"];}},
@{Name='Personal Protective Equipment';expression={$_["Personal Protective Equipment"];}},
@{Name='Positions of People';expression={$_["Positions of People"];}},
@{Name='Print friendly';expression={$_["Print friendly"];}},
@{Name='Priority';expression={$_["Priority"];}},
@{Name='Process Status';expression={$_["Process Status"];}},
@{Name='Reactions of People';expression={$_["Reactions of People"];}},
@{Name='Related Issues';expression={$_["Related Issues"];}},
@{Name='Safe Acts Observed';expression={$_["Safe Acts Observed"];}},
@{Name='Section';expression={$_["Section"];}},
@{Name='Time Taken (Mins)';expression={$_["Time Taken (Mins)"];}},
@{Name='Tools & Equipment';expression={$_["Tools & Equipment"];}},
@{Name='Unsafe Actions Observed';expression={$_["Unsafe Actions Observed"];}},
@{Name='Created By';expression={$_["Created By"];}},
@{Name='Modified By';expression={$_["Modified By"];}},
@{label="Processed";Expression={$false}}} | Export-Csv -Path $path -NoTypeInformation



Write-Host
Write-Host "ExtractListToCSV powershell script has successfully completed."
Write-Host
Write-Host "Please review the extracted data located at" $path

#--------------------
 
$dtEnd = Get-Date
 
RenderStats $dtStart $dtEnd
 
Write-Host
Write-Host
#Write-Host "Press enter to end..." -nonewline
#Read-Host
#--------------------