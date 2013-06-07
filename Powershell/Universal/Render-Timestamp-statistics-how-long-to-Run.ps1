##################################################################################
#
#
#  Script name: 	Render-mystats-timetaken-to-run-ps-script.ps1
#
#  Author:      	Meredith Fry
#  Last Modified:	16/01/2013
# 
#
##################################################################################
#Put this at the VERY TOP of your script:
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
#Put this at the VERY BOTTOM of your script
#--------------------
 
$dtEnd = Get-Date
 
RenderStats $dtStart $dtEnd
 
Write-Host
Write-Host
Write-Host "Press enter to end..." -nonewline
Read-Host
