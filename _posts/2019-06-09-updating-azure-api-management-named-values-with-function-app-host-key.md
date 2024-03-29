---
layout: grid
title: Updating Azure API Management named values with function app host key
date: 2019-06-09
---

When using Azure APIM with Azure Functions it is necessary for APIM to be aware of the function key to be able to call the function. Typically the function key will be stored as a secret in the named values section of APIM and referenced in the back-end template. This could be manually copied across from the function but it is much better to use release tasks within Azure DevOps pipelines to automate this for us.

To do this I have written an Azure Powershell script that gets the function host key and then writes it to the APIM named value. The script looks like this:

<script src="https://gist.github.com/aidangarnish/921b33817167b4d77d3c41e687c0fd19.js"></script>

This script is stored in an Azure DevOps repo and referenced in the Azure Powershell task:

![](/assets/images/devops.png)