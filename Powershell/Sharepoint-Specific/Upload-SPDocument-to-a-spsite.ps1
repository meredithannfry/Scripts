##################################################################################
#
#
#  Script name: 	Upload-SPDocument-to-a-spsite.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	16/01/2013
# 
#
##################################################################################

param([string]$UploadSite, [string]$UploadFolder, [string]$ExportCSV, [switch]$help)

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint")

function GetHelp() {


$HelpText = @"

DESCRIPTION:
NAME: Upload-SPDocument
Uploads a Document to SharePoint

PARAMETERS: 
-UploadSite		UploadSite to SharePoint Site
-UploadFolder		Name of Document UploadFolder
-ExportCSV	Path to Document

SYNTAX:

Upload-SPDocument -UploadSite http://moss -UploadFolder "Shared Documents" -Document "C:\Demo\Files\Excel SpreadSheet.xlsx"

Uploads the Excel Document to The "Shared Folders"

Upload-SPDocument -help

Displays the help topic for the script

"@
$HelpText

}

function Get-SPSite([string]$UploadSite) {

	New-Object Microsoft.SharePoint.SPSite($UploadSite)
}

function Get-SPWeb([string]$UploadSite) {

	$SPSite = Get-SPSite $UploadSite
	return $SPSite.OpenWeb()
	$SPSite.Dispose()
}

function Upload-SPDocument([string]$UploadSite, [string]$UploadFolder, [string]$ExportCSV) {
	"Uploading file to folder"
	$OpenWeb = Get-SPWeb $UploadSite

	$DocumentName = Split-Path $ExportCSV -Leaf
	$GetFolder = $OpenWeb.GetFolder($UploadFolder)

	[void]$GetFolder.Files.Add("$UploadFolder/$DocumentName",$((gci $ExportCSV).OpenRead()),"")
	[void]$((gci c:\)),""
	$OpenWeb.Dispose()
}

if($help) { GetHelp; Continue }
if($UploadSite -AND $UploadFolder -AND $ExportCSV) { Upload-SPDocument -UploadSite $UploadSite -UploadFolder $UploadFolder -ExportCSV $ExportCSV }