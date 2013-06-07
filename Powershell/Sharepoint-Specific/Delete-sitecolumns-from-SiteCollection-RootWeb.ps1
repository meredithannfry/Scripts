##################################################################################
#
#
#  Script name: 	Delete-site-columns-from-sitecollection-atRootweb.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	16/01/2013
# 
#
##################################################################################
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

set-variable -option constant -name url  -value "http://xxxx:20000/" # Specify your Site collection URL
$siteColumnsList = "Project Structure" # Specify a list of Site Column Names to be deleted

$site = new-object Microsoft.SharePoint.SPSite($url)
$array = $siteColumnsList.Split(";")

foreach($colms in $array)
{
 try
 {
  $column = $site.rootweb.Fields[$colms]
  $site.rootweb.Fields.Delete($column)
  Write-Host $column.Title "deleted successfully."
 }
 catch [System.Exception]
 {
  Write-Host $column.Title "deleted failed."
  #Best Attempt to Remove Site Columns
 }
}

$site.Dispose()

