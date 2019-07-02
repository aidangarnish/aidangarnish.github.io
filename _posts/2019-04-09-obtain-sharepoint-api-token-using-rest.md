---
layout: grid
title: Obtain Sharepoint API token using REST
date: 2019-04-09
---

1. Find your SharePoint tenant id using https://login.microsoftonline.com/{yourTenantName}/.well-known/openid-configuration. 
YourTenantName is usually something like yourCompanyName.onmicrosoft.com. The tenant Id will be returned in the JSON response just after "https://login.microsoftonline.com/".

2. If you have an Azure subscription set up an Azure AD App Registration - 
[https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RegisteredApps](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RegisteredApps). 
If you don't have an Azure subscription then you can set up a SharePoint App Registration. I prefer to use Azure AD as it is easier to go back and generate new client secrets or expire unused ones.

3. Grant access permissions to SharePoint for the App Registration by going to https://[yourSharePointTenantName]-admin.sharepoint.com/_layouts/15/appinv.aspx. Lookup the app you created in step 2 using the clientId and add the following Permission Request XML

![](/assets/images/SharePointToken1-1.PNG)

    <AppPermissionRequests AllowAppOnlyPolicy="true">
    <AppPermissionRequest Scope="http://sharepoint/content/tenant" Right="FullControl" />
    </AppPermissionRequests>
4. Get a client secret from the Azure AD app registration -> Settings -> Keys blade
5. Use Postman to call https://accounts.accesscontrol.windows.net/[yourSharePointTenantId(see step 1)]/tokens/OAuth/2?Content-Type=application/x-www-form-urlencoded. The body requires the following form-data:

    grant_type: client_credentials
    client_id: [App reg id]
    client_secret: [App reg secret]
    resource: 00000003-0000-0ff1-ce00-000000000000/[yourSharePointTenantUrl]@[yourTenantId]

![](/assets/images/SharePointToken2.PNG)6. You now have a token that can be used to call SharePoint API endpoints.