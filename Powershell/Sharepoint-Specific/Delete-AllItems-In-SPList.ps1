##################################################################################
#
#
#  Script name:  Delete-AllItems-In-SPList.ps1
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
$url="http://xxxx:14000"
Write-Host $url
$web="/SE/SIs/"
$listname="MyList"

$site = New-Object Microsoft.SharePoint.SPSite($url)
$spweb = $site.OpenWeb($web)
$list = $spweb.Lists[$listname]
if($list -eq $null){
    Write-Error "The List cannot be found";return
}

Write-Warning "Deleting all list items from $($listName)"

$Items = $list.Items;

$Items | ForEach-Object{

$list.GetItemById($_.Id).Delete()

}

$list.Update()
$spweb.Dispose()

#--------------------
 
$dtEnd = Get-Date
 
RenderStats $dtStart $dtEnd
 
Write-Host
Write-Host
#Write-Host "Press enter to end..." -nonewline
#Read-Host
#--------------------