Write-Debug "Starting ICS file creation."

# Sets file containing School Name, Company Code, API URL & State.
$Folder = $args[0]
$File = "$Folder\Data.csv"

# Imports CSV with School Name, Company Code, API URL & State, now sorted alphabetically.
$Data = Import-CSV $File
Write-Debug "Importing CSV."

foreach ($School in $Data) {
# Set School Calendar TASS API URL to get data from.
$URI = $School.URL
# Set School Company Code to be used in filename.
$CompanyCode = $School.Comp_Code
# Set School Name to be used in Calendar Name.
$SchoolName = $School.Name

Write-Debug "Starting ICS file creation for $SchoolName."

# Required format for ICS file.
$ICS_DateFormat = "yyyyMMddTHHmmss"

# Sets the creation date of the event to ICS file generation date & time.
$CreateDate = Get-Date -Format $ICS_DateFormat
# Sets the date stamp of the event to ICS file generation date & time.
$DateStamp = Get-Date -Format $ICS_DateFormat
# Sets the last modified date of the event to ICS file generation date & time.
$LastModified = Get-Date -Format $ICS_DateFormat

# Sets temporary filename to build ICS.
$TempFile = "$Folder\TEMP\$CompanyCode.temp"
# Sets final filename for ICS.
$FinalFileName = "$Folder\TEMP\$CompanyCode.ics"
# Sets the final destination to move ICS and index.html files to.
$Destination = $args[1]

# This section sets the ICS header information.
$ICS_Header = @"
BEGIN:VCALENDAR
PRODID:-//Mitchell Kellett//$CompanyCode@TASS.web//EN
VERSION:2.0
METHOD:PUBLISH
X-WR-CALNAME:$SchoolName Calendar
X-PUBLISHED-TTL:PT15M
"@

# Determines what Time Zone School is in for ICS header.
Switch -Exact ($School.State)
{
    "QLD" {$TimeZone_Header = @"
BEGIN:VTIMEZONE
TZID:E. Australia Standard Time
BEGIN:STANDARD
DTSTART:16010101T000000
TZOFFSETFROM:+1000
TZOFFSETTO:+1000
END:STANDARD
END:VTIMEZONE
"@}
    "NSW" {$TimeZone_Header = @"
BEGIN:VTIMEZONE
TZID:AUS Eastern Standard Time
BEGIN:STANDARD
DTSTART:16010401T030000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=4
TZOFFSETFROM:+1100
TZOFFSETTO:+1000
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:16011007T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=10
TZOFFSETFROM:+1000
TZOFFSETTO:+1100
END:DAYLIGHT
END:VTIMEZONE
"@}
    "VIC" {$TimeZone_Header = @"
BEGIN:VTIMEZONE
TZID:AUS Eastern Standard Time
BEGIN:STANDARD
DTSTART:16010401T030000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=4
TZOFFSETFROM:+1100
TZOFFSETTO:+1000
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:16011007T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=10
TZOFFSETFROM:+1000
TZOFFSETTO:+1100
END:DAYLIGHT
END:VTIMEZONE
BEGIN:VEVENT
"@}
    "ACT" {$TimeZone_Header = @"
BEGIN:VTIMEZONE
TZID:AUS Eastern Standard Time
BEGIN:STANDARD
DTSTART:16010401T030000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=4
TZOFFSETFROM:+1100
TZOFFSETTO:+1000
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:16011007T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=10
TZOFFSETFROM:+1000
TZOFFSETTO:+1100
END:DAYLIGHT
END:VTIMEZONE
BEGIN:VEVENT
"@}
    "TAS" {$TimeZone_Header = @"
BEGIN:VTIMEZONE
TZID:Tasmania Standard Time
BEGIN:STANDARD
DTSTART:16010401T030000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=4
TZOFFSETFROM:+1100
TZOFFSETTO:+1000
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:16011007T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=10
TZOFFSETFROM:+1000
TZOFFSETTO:+1100
END:DAYLIGHT
END:VTIMEZONE
"@}
    "SA" {$TimeZone_Header = @"
BEGIN:VTIMEZONE
TZID:Cen. Australia Standard Time
BEGIN:STANDARD
DTSTART:16010401T030000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=4
TZOFFSETFROM:+1030
TZOFFSETTO:+0930
END:STANDARD
BEGIN:DAYLIGHT
DTSTART:16011007T020000
RRULE:FREQ=YEARLY;BYDAY=1SU;BYMONTH=10
TZOFFSETFROM:+0930
TZOFFSETTO:+1030
END:DAYLIGHT
END:VTIMEZONE
"@}
    "WA" {$TimeZone_Header = @"
BEGIN:VTIMEZONE
TZID:W. Australia Standard Time
BEGIN:STANDARD
DTSTART:16010101T000000
TZOFFSETFROM:+0800
TZOFFSETTO:+0800
END:STANDARD
END:VTIMEZONE
"@}
    "NT" {$TimeZone_Header = @"
BEGIN:VTIMEZONE
TZID:AUS Central Standard Time
BEGIN:STANDARD
DTSTART:16010101T000000
TZOFFSETFROM:+0930
TZOFFSETTO:+0930
END:STANDARD
END:VTIMEZONE
"@}

}

# Determines what Time Zone School is in for event.
Switch -Exact ($School.State)
{
    "QLD" {$tzid = "E. Australia Standard Time"}
    "NSW" {$tzid = "AUS Eastern Standard Time"}
    "VIC" {$tzid = "AUS Eastern Standard Time"}
    "ACT" {$tzid = "AUS Eastern Standard Time"}
    "TAS" {$tzid = "Tasmania Standard Time"}
    "SA" {$tzid = "Cen. Australia Standard Time"}
    "WA" {$tzid = "W. Australia Standard Time"}
    "NT" {$tzid = "AUS Central Standard Time"}

}


# This section sets the ICS file footer information.
$ICS_Footer = @"
END:VCALENDAR
"@

# Add header information to ICS file.
Add-Content $TempFile $ICS_Header
Write-Debug "Added Header to ICS for $SchoolName."

# Add Time Zone information to ICS file.
Add-Content $TempFile $TimeZone_Header
Write-Debug "Added TimeZone Information to ICS for $SchoolName."

# Poll TASS for calendar data
$Response = Invoke-RestMethod -Uri $URI
Write-Debug "Polled TASS for $SchoolName."

# This section cleans up retrieved data.
$Response = $Response.Replace('events: [','[')
$Response = $Response.Replace('-1: "PK"','00: "PK"')

# Convert from JSON to PowerShell Object.
$Response = ConvertFrom-Json $Response

# This section creates an event for each event in the JSON and cleans up the variable names.
foreach ($event in $Response) {
$id = $event.id
$location = $event.location
$description = $event.description
$title = $event.title
$start = $event.start
$end = $event.end
$eurl = $event.url_link

# This section parses TASS JSON date to PowerShell date format.
$start = [datetime]::parseexact($start, 'yyyy-MM-dd HH:mm:ss', $null)
$end = [datetime]::parseexact($end, 'yyyy-MM-dd HH:mm:ss', $null)

# This section parses PowerShell date to ICS date format.
$start = Get-Date $start -Format $ICS_DateFormat
$end = Get-Date $end -Format $ICS_DateFormat

# This section creates the body of the event for each event in the JSON.
$body = @"
BEGIN:VEVENT
DTSTART;TZID=$($tzid):$start
DTEND;TZID=$($tzid):$end
DTSTAMP:$($DateStamp)Z
UID:$id@$CompanyCode.tass.domain.com
URL:$eurl
CREATED:$start
DESCRIPTION:$description
LAST-MODIFIED:$($start)Z
LOCATION:$location
SEQUENCE:0
STATUS:CONFIRMED
SUMMARY:$title
TRANSP:TRANSPARENT
END:VEVENT
"@

# Add Events to ICS file
Add-Content $TempFile $body
Write-Debug "Added Event to ICS for $SchoolName."
}

#Add Footer to ICS file
Add-Content $TempFile $ICS_Footer
Write-Debug "Added Footer to ICS for $SchoolName."

#Rename Temp ICS File
Rename-Item $TempFile -NewName $FinalFileName
Write-Debug "Renamed ICS for $SchoolName."

#Move ICS to webhost
Move-Item $FinalFileName -Destination $Destination -Force
Write-Debug "Moved ICS for $SchoolName."

Write-Debug "Finished ICS file creation for $SchoolName."
}
Write-Debug "Completed ICS file creation."
