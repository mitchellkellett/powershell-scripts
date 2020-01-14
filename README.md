# PowerShell Scripts
This is a collection of PowerShell scripts I've made public. Often they are part of a larger project so may contain references to arguments or other variables.

## TASS
A collection of scripts that relate to [The Alpha School System (TASS)](https://www.tassweb.com.au/).
### Generate ICS
This script generates an ICS file for each School listed in Data.csv. It utilises the [School Calendar and Notices](https://github.com/TheAlphaSchoolSystemPTYLTD/school-calendar-and-notices) API via the getTeacherCalendar Method & [Public Calendar and Notices](https://github.com/TheAlphaSchoolSystemPTYLTD/public-calendar-and-notices) API via the getPublicCalendar Method. It could also be adapted to use the getTeacherEDiary, getStudentEDiary or getParentCalendar Methods.

1.  Update Data.csv to contain your school name, company code, API URL and state.
2.  Update $Folder to where the script is contained, this is on line 4 of Generate.ps1
3.  Update $Destination to where the script is contained, this is on line 36 of Generate.ps1
4.  Update TASS Domain on line 234 of Generate.ps1
