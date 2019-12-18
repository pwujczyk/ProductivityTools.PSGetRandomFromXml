clear
cd $PSScriptRoot
Import-Module .\ProductivityTools.GetRandomFromXml.psm1 -Force
Get-RandomFromXml -RandomFromGroups "Names,PersonalInfo" -PrintGroupname
Split-GroupIntoRandomParts -GroupName Names -GroupsAmount 4

Get-QuestionFromGroup Knowledge