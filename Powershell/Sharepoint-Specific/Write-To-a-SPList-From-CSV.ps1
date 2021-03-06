##################################################################################
#
#
#  Script name:  WriteToaSPListFromCSV.ps1
#
#  Author:       Meredith Fry
#  Last Modified: 17/01/2013
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
$url="http://xxxxx:14000"
$web="/My Web/Safety/"
$listname="My List"
$path = "D:\Backup\portal\SI\ExtractedFile.csv"

$site = New-Object Microsoft.SharePoint.SPSite($url)
$spweb = $site.OpenWeb($web)
$csv_info = Import-Csv $path
$list = $spweb.Lists[$listname]

#Get count and delete items
$collListItems = $list.Items;
$count = $collListItems.Count - 1
$count = 0

while ($count -le 4999)
{
    foreach ($line in $csv_info) 
    {
            if ($count -le 4999)
            {
                $newitem = $list.items.Add()
        		
                $stringArchivedDate = $($line."Archived Date")
                #The ParseExact method is not working for me
                #$dateArchivedDate =[datetime]::ParseExact($stringArchivedDate, "dd/MM/yyyy HH:mm:ss tt", [System.Globalization.CultureInfo]::CurrentCulture)
                    
                $stringDateOfObservation = $($line."Date Of Observation")
                #The ParseExact method is not working for me
                #$dateDateOfObservation =[datetime]::ParseExact($stringDateOfObservation, "dd/MM/yyyy HH:mm:ss tt", [System.Globalization.CultureInfo]::CurrentCulture)
                
                $stringDueDate = $($line."Due Date")
                #The ParseExact method is not working for me
                #$dateDueDate =[datetime]::ParseExact($stringDueDate, "dd/MM/yyyy HH:mm:ss tt", [System.Globalization.CultureInfo]::CurrentCulture)
                
                $stringFollowUpDueDate = $($line."Follow Up Due Date")
                #The ParseExact method is not working for me
                #$dateFollowUpDueDate =[datetime]::ParseExact($stringFollowUpDueDate, "dd/MM/yyyy HH:mm:ss tt", [System.Globalization.CultureInfo]::CurrentCulture)
                
                
        		#Write to list
                
        		$count = $count + 1
                $newitem["Accompanied By"] = $($line."Accompanied By");
                
                if (![string]::IsNullorEmpty($stringArchivedDate))
                {
                    $newitem["Archived Date"] = Get-Date($stringArchivedDate);
                }
                
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
                
                if (![string]::IsNullorEmpty($stringDateOfObservation))
                {
                    $newitem["Date of Observation"] = Get-Date($stringDateOfObservation);
                }
                
                $newitem["Delegate's Comments"] = $($line."Delegate's Comments");
                $newitem["Description"] = $($line."Description");
                
                if (![string]::IsNullorEmpty($stringDueDate))
                {
                    $newitem["Due Date"] = Get-Date($stringDueDate);
                }
                
                $newitem["Encouragement Given"] = $($line."Encouragement Given");
                $newitem["Final Preventative Action"] = $($line."Final Preventative Action");
                $newitem["Follow Up Actions"] = $($line."Follow Up Actions");
                
                if (![string]::IsNullorEmpty($stringFollowUpDueDate))
                {
                    $newitem["Follow Up Due Date"] = Get-Date($stringFollowUpDueDate);
                }
                
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
                
                write-output "Successfully written item no. " $count "to " $listname    
        		write-output "Number of items written to the list: " , $count
            }
            else 
            {
                break
            }
        }

}
$list.update()
$spweb.Dispose()


#--------------------
 
$dtEnd = Get-Date
 
RenderStats $dtStart $dtEnd
 
Write-Host
Write-Host
#Write-Host "Press enter to end..." -nonewline
#Read-Host
#--------------------
