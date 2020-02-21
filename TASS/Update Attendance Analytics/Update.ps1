$Domain = "tass.domain.com"

$Url = "https://$($Domain)/tassweb/ScheduledTasks/process_update_student_class_absences.cfm"

$CompCodes = ("01","02","03")

$SuccessResponse = @"


	Update process completed.

"@

foreach($Comp in $CompCodes){

$Body = @{
    cmpy_code = "$($Comp)"
    tt_id = ""
    password1 = "n0there"
    submit1 = "GO"
}

Write-Debug "Updating Absence Analytics for Company $($Comp)"

$Response = Invoke-RestMethod -Method "Post" -Uri $url -Body $Body

if($Response -eq $SuccessResponse) {
   $Response = $Response.Replace($SuccessResponse,"")
Write-Debug "Update process completed for $($Comp)."
}else {
   $Response
}

Write-Debug "Completed Updating Absence Analytics for Company $($Comp)"

}
