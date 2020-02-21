#Set the domain to be used.
$Domain = "tass.domain.com"

#Sets the URL to post the body to.
$Url = "https://$($Domain)/tassweb/ScheduledTasks/process_update_student_class_absences.cfm"

#List of comma separated, quoted company codes.
$CompCodes = ("01","02","03")

#Sets the success reponse from TASS.
$SuccessResponse = @"


	Update process completed.

"@

#For each school, create the body needed and post to TASS.
foreach($Comp in $CompCodes){

#Builds the body to be posted.
$Body = @{
    cmpy_code = "$($Comp)"
    tt_id = ""
    password1 = "n0there"
    submit1 = "GO"
}

#Sets a debug message.
Write-Debug "Updating Absence Analytics for Company $($Comp)"

#Posts the $Body to the $URL.
$Response = Invoke-RestMethod -Method "Post" -Uri $url -Body $Body

#If successful sets a better debug message, if not returns the response.
if($Response -eq $SuccessResponse) {
   $Response = $Response.Replace($SuccessResponse,"")
Write-Debug "Update process completed for $($Comp)."
}else {
   Write-Debug $Response
}

#Sets a debug message.
Write-Debug "Completed Updating Absence Analytics for Company $($Comp)"

}
