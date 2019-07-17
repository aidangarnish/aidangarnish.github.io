---
layout: grid
title: Add Azure App to role assignment
date: 2019-07-17
---

One way to add a role assigment to a an App registered in Azure AD is to use the Azure Cli. To add the role assigment to a resource group you can use:

az role assignment create --role contributor --assignee-object-id [object id] --resource-group [MyResourceGroup]

However, using the Object Id that is displayed on the overview page of the app registration results in the following error:

"Principals of type Application cannot validly be used in role assignments."

The solution is to first call the following:

az ad sp show --id [Application (client) Id]

This returns an objectId for the service principal that can then be successfully used in the call to "az role assignment create"