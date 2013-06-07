##################################################################################
#
#
#  Script name: 	WriteSPList.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	16/01/2013
# 
#
##################################################################################

param([string]$WriteUrl, [string]$WriteList, [string]$ExportCSV, [switch]$help)

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

function GetHelp() {


$HelpText = @"

DESCRIPTION:
NAME: Write-SPList
Uploads a Document to SharePoint

PARAMETERS: 
-WriteURL		Url of site where list resides
-WriteList		Name of target list
-ExportCSV		Filename and location of CSV file

SYNTAX:

Write-List -WriteURL http://moss/sites/site -WriteList "Test List" -ExportCSV "C:\Demo\Files\listofsites.CSV"

Writes the specified CSV to "Test List"

Write-List -help

Displays the help topic for the script

"@
$HelpText

}

$SPSite = New-Object Microsoft.SharePoint.SPSite("$WriteURL")
$OpenWeb = $SPSite.OpenWeb()
$csv_info = Import-Csv "$ExportCSV"
$list = $OpenWeb.Lists["$WriteList"]

#Get count and delete items
$collListItems = $List.Items;
$count = $collListItems.Count - 1
$count = 0
foreach ($line in $csv_info) {
$newitem = $list.items.Add()

		#convert date column to date formats
		#$stringstarttime = $($line."StartTime")
		#$datestarttime = [datetime]::ParseExact($stringstarttime, "dd/MM/yyyy HH:mm:ss", $null)
		#$stringendtime = $($line."EndTime")
		#$dateendtime = [datetime]::ParseExact($stringendtime, "dd/MM/yyyy HH:mm:ss", $null)
		
		#Write to list
		$count = $count + 1
		$newitem["Accompanied By"] = $($line."Accompanied By");
        $newitem["Archived Date"] = $($line."Archived Date");
        $newitem["Area"] = $($line."Area");
        $newitem["calCreatedMonth"] = $($line."calCreatedMonth");
		$newitem["calCreatedYear"] = $($line."calCreatedYear");
        $newitem["calThisMonthBool"] = $($line."calThisMonthBool");
        $newitem["calTodayMonth"] = $($line."calTodayMonth");
        $newitem["calTodayYear"] = $($line."calTodayYear");
        $newitem["Category"] = $($line."Category");
        $newitem["Comments"] = $($line."Comments");
        $newitem["Conditions Observed"] = $($line."Conditions Observed");
        $newitem["CreatedMonth"] = $($line."CreatedMonth");
        $newitem["Date of Observation"] = $($line."Date of Observation");
        $newitem["Delegate's Comments"] = $($line."Delegate's Comments");
        $newitem["Description"] = $($line."Description");
        $newitem["Due Date"] = $($line."Due Date");
        $newitem["Encouragement Given"] = $($line."Encouragement Given");
        $newitem["Final Preventative Action"] = $($line."Final Preventative Action");
        $newitem["Follow Up Actions"] = $($line."Follow Up Actions");
        $newitem["Follow Up Due Date"] = $($line."Follow Up Due Date");
        $newitem["Follow Up Status"] = $($line."Follow Up Status");
        $newitem["Follow-up Delegation"] = $($line."Follow-up Delegation");
        $newitem["Function"] = $($line."Function");
        $newitem["General Comments"] = $($line."General Comments");
        $newitem["Group"] = $($line."Group");
        $newitem["Immediate Corrective Actions"] = $($line."Immediate Corrective Actions");
        $newitem["Location"] = $($line."Location");
        $newitem["Month"] = $($line."Month");
        $newitem["No. of People"] = $($line."No. of People");
        $newitem["Number of Safe Acts observed"] = $($line."Number of Safe Acts observed");
        $newitem["Number of Unsafe Acts observed"] = $($line."Number of Unsafe Acts observed");
        $newitem["Observer ID"] = $($line."Observer ID");
        $newitem["Observer's Name"] = $($line."Observer's Name");
        $newitem["Operating Procedures"] = $($line."Operating Procedures");
        $newitem["Orderliness Standards"] = $($line."Orderliness Standards");
        $newitem["Personal Protective Equipment"] = $($line."Personal Protective Equipment");
        $newitem["Positions of People"] = $($line."Positions of People");
        $newitem["Print friendly"] = $($line."Print friendly");
        $newitem["Priority"] = $($line."Priority");
        $newitem["Process Status"] = $($line."Process Status");
        $newitem["Reactions of People"] = $($line."Reactions of People");
        $newitem["Related Issues"] = $($line."Related Issues");
        $newitem["Safe Acts Observed"] = $($line."Safe Acts Observed");
        $newitem["Section"] = $($line."Section");
        $newitem["Time Taken (Mins)"] = $($line."Time Taken (Mins)");
        $newitem["Tools & Equipment"] = $($line."Tools & Equipment");
        $newitem["Unsafe Actions Observed"] = $($line."Unsafe Actions Observed");
        $newitem["Created By"] = $($line."Created By");
        $newitem["Modified By"] = $($line."Modified By");
		$newitem.update()
		write-output "Number of items written to the list: " , $count
}
$SPSite.Dispose()
$OpenWeb.Dispose()

if($help) { GetHelp; Continue }


