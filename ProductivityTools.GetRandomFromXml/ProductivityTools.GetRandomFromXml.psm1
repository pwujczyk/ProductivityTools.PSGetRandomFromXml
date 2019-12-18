function GetXmlPath{
	return "D:\Peugeot206.txt"
}

function GetConfigurationList{
	$xmlPath=GetXmlPath
	[xml]$configuration=Get-Content $xmlPath
	$configurationList=$configuration.Configuration.ConfigurationGroup
	return $configurationList
}

function GetRandomForGroup{
	param($group)

	$id=Get-Random -Maximum  $group.ConfigurationItem.Length
	
	$result=$group.ConfigurationItem[$id]
	return $result;
	
}

function Get-QuestionFromGroup{

	param([string]$GroupName, [switch]$DisplayAttributes, [Switch]$DelayAttributes)
	
	$group=GetGroupItem $GroupName
	$random=GetRandomForGroup $group
	
	$text=$random.innerText
	Write-Output $text
	Read-Host
	Write-Output $random.Answer
	
	
}

Function Get-RandomFromXml{

	param([string]$RandomFromGroups, [switch]$PrintGroupName)
	
	$groupNames=$RandomFromGroups -split ","
	
	$configurationList=GetConfigurationList
	foreach($groupName in $groupNames)
	{
		$config=GetGroupItem $groupName
		$random=GetRandomForGroup $config 
		if ($PrintGroupName.IsPresent)
		{
			Write-Host $groupName -NoNewline
			Write-Host ": " -NoNewline
		}
		Write-Host $random
	}
}

function GetGroupItem{

	param([string]$groupName)
	
	$configurationList=GetConfigurationList
	foreach($config in $configurationList)
	{
		if ($groupName -eq $config.Name)
		{
			return $config
		}
	}
}


function WriteParts{
	param($parts)
	
	foreach($part in $parts.Keys)
	{
		Write-Host ""
		Write-Host "Part: $part"
		foreach($item in $parts[$part])
		{
			Write-Host $item
		}
	}
}

function Split-GroupIntoRandomParts{
	param([string]$GroupName, [int]$GroupsAmount)
	
	$groupConfig=GetGroupItem $groupName
	
	$list=@()
	$result=@{}
	
	for($j=0; $j -lt $GroupsAmount; $j++)
	{
		$result[$j]=@()
	}
	
	$resultGroupIndex=0;
	foreach($groupConfigItem in $groupConfig.ConfigurationItem)
	{
		$list+=$groupConfigItem
	}
	
	while ($list.Length -gt 0)
	{
		$tempList=@()
		$randomNumber=Get-Random -Maximum  $list.Length 
		for($i=0; $i -lt $list.Length; $i++)
		{
			if ($randomNumber -eq $i)
			{
				$result[$resultGroupIndex]+=$list[$i];
				$resultGroupIndex++
			}
			else
			{
				$tempList+=$list[$i];
			}
		}
		$list=$tempList
		if ($resultGroupIndex -eq $GroupsAmount)
		{
			$resultGroupIndex=0
		}
	}
	
	WriteParts $result	
}