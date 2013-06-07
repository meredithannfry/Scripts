##################################################################################
#
#
#  Script name: 	List-All-Sites.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	16/01/2013
# 
#
##################################################################################

param([string]$url, [string]$ExportCSV, [switch]$help)

function GetHelp() {


$HelpText = @"

DESCRIPTION:
NAME: List Sites Script
Lists all sites in a given web app

PARAMETERS: 
-url		URL of web app
-exportcsv		exportcsv for output file

SYNTAX:

.\List-Sites.ps1 -url http://moss -exportcsv d:\DesiredLocation

Lists all sites in the http://moss Web App and outputs to d:\DesiredLocation

List-Sites.ps1 -help

Displays the help topic for the script

"@
$HelpText

}

function List-Sites([string]$url, [string]$exportcsv)
    {
         [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") > $null
         [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Administration") > $null
         $rootSite = new-object Microsoft.SharePoint.SPSite($url)
         $webApp= $rootSite.WebApplication
         $count = $webApp.Sites.Count
         write-output "Total Sites: ",  $count
		 write-output "URL,Title,Description,SiteOwnerName,SiteOwnerEmail,SiteOwnerLogin,SecondaryOwnerName,SecondaryOwnerEmail,Size,SiteQuota,SiteUsersCount,WebTemplate,TemplateName,RequestAccessEnabled,RequestAccessEmail,SiteLastContentModifiedDate,SiteCreatedDate,ContentDatabase" > $ExportCSV
        if($webApp.Sites.Count -gt 0)
        {
            foreach ($site in $webApp.Sites)
            {
                $rootweb = $site.RootWeb
                $allwebtemplates=$rootweb.GetAvailableWebTemplates(1033)
                
                foreach($template in $allwebtemplates)
                {
					if ($template.ID -eq $rootweb.WebTemplateId)
					{
						$templatename=$template.Title
					}
                }
                
                $SiteAdmin = new-object Microsoft.SharePoint.Administration.SPSiteAdministration($rootweb.URL)
				$size =  (($SiteAdmin.DiskUsed + 0x80000L) / 0x100000L)
				#Get the site quota to MB
				$quotamb = $site.quota.StorageMaximumLevel / 1048576
				$SiteUsersCount = $rootWeb.SiteUsers.count
				#Trim the extra characters from the ContentDB field
				$contentdb = $site.ContentDatabase | foreach-object {$_ -replace "SPContentDatabase Name=","" -replace "Parent=SPDatabaseServiceInstance",""}
				$description = $rootWeb.Description | foreach-object {$_ -replace "`r"," NewLine>" -replace "`n"," NewLine>"}
				
				"`"$($site.Url)`",`"$($rootWeb.Title)`",`"$($description)`",`"$($site.Owner.Name)`",`"$($site.Owner.Email)`",`"$($site.Owner.LoginName)`",`"$($site.SecondaryContact.Name)`",`"$($site.SecondaryContact.Email)`",`"$($size)`",`"$quotamb`",`"$($SiteUsersCount)`",`"$($rootWeb.WebTemplate)`",`"$($templatename)`",`"$($rootWeb.RequestAccessEnabled)`",`"$($rootWeb.RequestAccessEmail)`",`"$($site.LastContentModifiedDate)`",`"$($rootweb.created)`",`"$($contentdb)`"" >> $ExportCSV
                $count = $count - 1
                write-output "Sites Left: ",  $count
                $SiteAdmin.Dispose()
                $rootweb.Dispose()
            }
        }
        $rootSite.Dispose()
    }


if($help) { GetHelp; Continue }
if($url -AND $exportcsv) { List-Sites -url "$url" -exportcsv $exportcsv}