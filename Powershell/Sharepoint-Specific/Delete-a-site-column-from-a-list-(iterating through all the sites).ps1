##################################################################################
#
#
#  Script name: 	Delete-sitecolumn-fromlist-iterating-through-sites.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	18/01/2013
# 
#
##################################################################################
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

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

set-variable -option constant -name url  -value "http://xxxx:20000/" # Specify your Site collection URL
$siteColumnsList = "Project Structure" # Specify a list of Site Column Names to be deleted

$baseSite = new-object Microsoft.SharePoint.SPSite($url)

#Write-Host $baseSite

$spWebApp = $baseSite.WebApplication

$array = $siteColumnsList.Split(";")

#Loop through each of the Site Collections in the WebApplication
foreach($spSite in $spWebApp.Sites)
{
    Write-Host "Checking Site Collection: $($spSite.RootWeb.Title) ($($spSite.RootWeb.Url))" #-nonewline

    foreach($spWeb in $spSite.AllWebs) {
    # Iterate through each list in the web and filter for fields that meet the condition.
        Write-Host "." #-nonewline
    
        $column = $spWeb.Lists | % { $_.Fields } | Where { $array -contains $_.DisplayName -or $array -contains $_.InternalName }
        
        if($column -ne $null) {
            $list = $column.ParentList
            
            Write-Host "Deleting $($column.DisplayName) from $($list.Title) ($($list.Url))"
            
            $column.Delete()
            
            $list.Update()
        }
        #Read-Host 
    }
    
    Write-Host

    $column = $spSite.RootWeb.Fields | Where { $array -contains $_.DisplayName -or $array -contains $_.InternalName }    
    
    if($column -ne $null) {   
        Write-Host "Deleting $($column.DisplayName) from Site Columns in $($spSite.RootWeb.Title) ($($spSite.RootWeb.Url))"
        
        $column.Delete()
        
        $spSite.RootWeb.Update()
    }
}

$dtEnd = Get-Date
 
RenderStats $dtStart $dtEnd
 
Write-Host
Write-Host
Write-Host "Press enter to end..." -nonewline
Read-Host