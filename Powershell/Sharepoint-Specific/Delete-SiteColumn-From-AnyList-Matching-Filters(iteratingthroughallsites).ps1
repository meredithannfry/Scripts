##################################################################################
#
#
#  Script name: 	Delete-SiteColumn-from-any-list-matching-filters.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	20/01/2013
# 
#
##################################################################################

#Function to render statistics on how long the powershell script takes to run.
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
#End of function to render statistics on how long the powershell script takes to run.
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")
set-variable -option constant -name url  -value "http://xxxx:20000/" # Specify your Site collection URL
$siteColumnsList = "Project Structure" # Specify a list of Site Column Names (you can specify multiple, separated by ;" to be deleted
$baseSite = new-object Microsoft.SharePoint.SPSite($url)
#Write-Host $baseSite
$spWebApp = $baseSite.WebApplication
$array = $siteColumnsList.Split(";")
#Loop through each of the Site Collections in the WebApplication
foreach($spSite in $spWebApp.Sites)
{
    Write-Host "Checking Site Collection: $($spSite.RootWeb.Title) ($($spSite.RootWeb.Url))" #-nonewline
    
    #Iterate through each list in the web and filter for fields that meet the condition.
    foreach($spWeb in $spSite.AllWebs) {
    
        Write-Host "." #-nonewline
        
        #Filter each list by field where fields contain a site column with that site column of interest. 
        $column = $spWeb.Lists | % { $_.Fields } | Where { $array -contains $_.DisplayName -or $array -contains $_.InternalName }
        
        #Check to see if the column was found in the lists (ie. it will not be null)
        if($column -ne $null) {
        
            #It was found, so obtain the list that it was found in and proceed to update that list by deleting the column.
            $list = $column.ParentList
            
            Write-Host "Deleting $($column.DisplayName) from $($list.Title) ($($list.Url))"
            
            $column.Delete()
            
            $list.Update()
        }
    }
    
    Write-Host
    #proceed to delete the site column from the root web if it is defined there too.
    $column = $spSite.RootWeb.Fields | Where { $array -contains $_.DisplayName -or $array -contains $_.InternalName }    
    
    if($column -ne $null) {   
        Write-Host "Deleting $($column.DisplayName) from Site Columns in $($spSite.RootWeb.Title) ($($spSite.RootWeb.Url))"
        
        $column.Delete()
        
        $spSite.RootWeb.Update()
    }
}
$dtEnd = Get-Date
 
#Invoke the function to publish the statistics on how long the script took to run.
RenderStats $dtStart $dtEnd
 
Write-Host
Write-Host
Write-Host "Press enter to end..." -nonewline
Read-Host
