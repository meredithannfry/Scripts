##################################################################################
#
#
#  Script name: 	Display-all-SP-SiteCollections-Administrators-inWebApp.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	16/01/2013
# 
#
##################################################################################
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

set-variable -option constant -name siteCollectionUrl  -value "http://xxxx:20000/" # Specify your Site collection URL

# Get the WebApplication for the Site Collection.
$rootSite = New-Object Microsoft.SharePoint.SPSite($siteCollectionUrl)
$spWebApp = $rootSite.WebApplication
 
#Loop through each of the Site Collections in the WebApplication
foreach($site in $spWebApp.Sites)
{
    #For each of the Site Collections, iterate over the SiteAdministrators property for the RootWeb.  Then write out the site url and admin display names.  
    foreach($siteAdmin in $site.RootWeb.SiteAdministrators)
    {
        #Write out the site url and admin display names.
        Write-Host "$($siteAdmin.ParentWeb.Url) - $($siteAdmin.Name)"
    }
    $site.Dispose()
}
$rootSite.Dispose()