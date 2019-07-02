Param([string]$namedValueId)
$functionName = $Env:SiteName;
$resourceGroup = $Env:APPRESOURCEGROUP;
$apimServiceName = $Env:APIM_SERVICENAME;

$publishingCredentials = Invoke-AzureRmResourceAction -ResourceGroupName $resourceGroup -ResourceType "Microsoft.Web/sites/config" 
-ResourceName "$functionName/publishingcredentials" -Action list -ApiVersion 2015-08-01 -Force

$authorization = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" 
-f $publishingCredentials.Properties.PublishingUserName, $publishingCredentials.Properties.PublishingPassword)))

$accessToken = Invoke-RestMethod -Uri "https://$functionName.scm.azurewebsites.net/api/functions/admin/token" 
-Headers @{Authorization=("Basic {0}" -f $authorization)} -Method GET

$response = Invoke-RestMethod -Method GET -Headers @{Authorization = ("Bearer {0}" -f $accessToken)} 
-ContentType "application/json" -Uri "https://$functionName.azurewebsites.net/admin/host/keys/default"

$apimContext = New-AzureRMApiManagementContext -ResourceGroupName $resourceGroup -ServiceName $apimServiceName
Set-AzureRmApiManagementProperty -Context $apimContext -PropertyId $namedValueId -Value $response.value -PassThru 