##################################################################################
#
#
#  Script name: 	Query-all-sites-with-lists-that-have-a-field-matching-the-filter.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	16/01/2013
# 
#
##################################################################################

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

set-variable -option constant -name url  -value "http://xxxx:20000/" # Specify your Site collection URL
$siteColumnsList = "Project Structure" # Specify a list of Site Column Names to be deleted

$baseSite = new-object Microsoft.SharePoint.SPSite($url)

Write-Host $baseSite

$spWebApp = $baseSite.WebApplication

Write-Host $spWebApp

  #Loop through each of the Site Collections in the WebApplication
  foreach($spSite in $spWebApp.Sites)
   {
            Write-Host "Site Collection in the Web Application"
            Write-Host $spSite.Url
            
            #Iterate through the sites within the collection to find a field in the list field collection matching the filters applied. 
            foreach($spWeb in $spSite.AllWebs) {
                $column = $spWeb.Lists | % { $_.Fields } | Where { $_.DisplayName -eq "ProjectStructure" -or $_.InternalName -eq "ProjectStructure" } | % { $_.Scope }
            
                Write-Host $spWeb.Url
                             
                Write-Host $column       
                
            }

   }
   