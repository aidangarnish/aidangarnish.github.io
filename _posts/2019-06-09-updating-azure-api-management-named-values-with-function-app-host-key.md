---
layout: grid
title: Updating Azure API Management named values with function app host key
date: 2019-06-09
---

When using Azure APIM with Azure Functions it is necessary for APIM to be aware of the function key to be able to call the function. Typically the function key will be stored as a secret in the named values section of APIM and referenced in the back-end template. This could be manually copied across from the function but it is much better to use release tasks within Azure DevOps pipelines to automate this for us.

To do this I have written an Azure Powershell script that gets the function host key and then writes it to the APIM named value. The script looks like this:

`Param([string]$namedValueId)
$functionName = $Env:SiteName;
$resourceGroup = $Env:APPRESOURCEGROUP;
$apimServiceName = $Env:APIM_SERVICENAME;`

`$publishingCredentials = Invoke-AzureRmResourceAction -ResourceGroupName $resourceGroup -ResourceType "Microsoft.Web/sites/config" -ResourceName "$functionName/publishingcredentials" -Action list -ApiVersion 2015-08-01 -Force
$authorization = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $publishingCredentials.Properties.PublishingUserName, $publishingCredentials.Properties.PublishingPassword)))
$accessToken = Invoke-RestMethod -Uri "https://$functionName.scm.azurewebsites.net/api/functions/admin/token" -Headers @{Authorization=("Basic {0}" -f $authorization)} -Method GET
$response = Invoke-RestMethod -Method GET -Headers @{Authorization = ("Bearer {0}" -f $accessToken)} -ContentType "application/json" -Uri "https://$functionName.azurewebsites.net/admin/host/keys/default"`

`$apimContext = New-AzureRMApiManagementContext -ResourceGroupName $resourceGroup -ServiceName $apimServiceName
Set-AzureRmApiManagementProperty -Context $apimContext -PropertyId $namedValueId -Value $response.value -PassThru`

This script is stored in an Azure DevOps repo and referenced in the Azure Powershell task:

![](/assets/images/devops.PNG)