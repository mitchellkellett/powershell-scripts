# TASS
A collection of scripts that relate to [The Alpha School System (TASS)](https://www.tassweb.com.au/).
## Generate ICS
This script generates an ICS file for each School listed in Data.csv. It utilises the [School Calendar and Notices](https://github.com/TheAlphaSchoolSystemPTYLTD/school-calendar-and-notices) API via the getTeacherCalendar Method & [Public Calendar and Notices](https://github.com/TheAlphaSchoolSystemPTYLTD/public-calendar-and-notices) API via the getPublicCalendar Method. It could also be adapted to use the getTeacherEDiary, getStudentEDiary or getParentCalendar Methods.

### Setup
1. Update Data.CSV with School Name, Company Code, Calendar Type, API URL & State.
    - Valid Calendar Types are:
        - Staff
        - Student
        - Public
    - Valid States are:
        - ACT
        - NSW
        - NT
        - QLD
        - SA
        - TAS
        - VIC
        - WA
2.  Update $Folder to where the script is contained, this is on line 4 of Generate.ps1
3.  Update $Destination to where the script is contained, this is on line 40 of Generate.ps1
4.  Update TASS Domain on line 238 & 265 of Generate.ps1

# Update Attendance Analytics
This script makes a post request to the TASS Update Student Class Absences Endpoint in the scheduled tasks workflow. It does this for all schools listed in the $Schools variable.

## Setup
1. Update the $Domain variable to the correct URL for your TASS instance.
2. Update the $CompCodes variable with the company codes of the schools that you wish to update.
    - Ensure that you comma separate the list and enclose each company code in double quotes (eg. "01","02")
4. Set up scheduled task to run Update.ps1 on a regular basis.
    - Depending how many companies/timetables/classes/students you have will affect how often you should schedule this task for.
