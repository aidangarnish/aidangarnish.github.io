---
layout: grid
title: Using Application Insights to assess general health of Azure Functions
date: 2019-07-15
---

To enable monitoring of an Azure Function follow this [guide](https://docs.microsoft.com/en-us/azure/azure-functions/functions-monitoring).

Now that monitoring is setup we are able to create queries that allow for some general health monitoring of our Azure Functions.

To get a count of each type of http result code for the last 30 days:

<script src="https://gist.github.com/aidangarnish/4dbe82513b9ebcc4d14698d5a4164561.js"></script>

To get the average duration of each function for the last 7 days:

<script src="https://gist.github.com/aidangarnish/c8924e2b30e683fa78ef191e62c83e34.js"></script>

To get the average duration per day of a specific function:

<script src="https://gist.github.com/aidangarnish/f8c9d53cbe932289157a13e11394e018.js"></script>