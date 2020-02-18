## TASS
A collection of scripts that relate to [The Alpha School System (TASS)](https://www.tassweb.com.au/).
### Generate ICS
This script generates an ICS file for each School listed in Data.csv. It utilises the [School Calendar and Notices](https://github.com/TheAlphaSchoolSystemPTYLTD/school-calendar-and-notices) API via the getTeacherCalendar Method & [Public Calendar and Notices](https://github.com/TheAlphaSchoolSystemPTYLTD/public-calendar-and-notices) API via the getPublicCalendar Method. It could also be adapted to use the getTeacherEDiary, getStudentEDiary or getParentCalendar Methods.

#### Setup
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
