---
layout: grid
title: Authorize ASP.Net MVC controller actions with Azure AD group
date: 2017-11-04
---

To use Azure AD groups to secure an ASP.Net MVC app is relatively straight forward but needs a little bit of configuration setup. 

In the Azure Portal navigate to your App registration, open the Manifest and update the following setting.

`"groupMembershipClaims": "SecurityGroup"`

This will ensure that group claims are added to the claims object and make them available for use in your application.

Next, create a custom Authorize filter that checks to see if a group id exists in the claims object and denies access if it doesn't.

`public class AuthorizeADAttribute : AuthorizeAttribute
    {
        public string GroupId { get; set; }`
        
        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            if (base.AuthorizeCore(httpContext))
            {
                if (String.IsNullOrEmpty(GroupId))
                    return true;

                var identity = (ClaimsPrincipal)Thread.CurrentPrincipal;

                var claim = identity.Claims.Where(c => c.Value == GroupId).FirstOrDefault();
               
                if(claim != null)
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }
            return false;
        }

        protected override void HandleUnauthorizedRequest(System.Web.Mvc.AuthorizationContext filterContext)
        {
            if (!filterContext.HttpContext.User.Identity.IsAuthenticated)
            {
                base.HandleUnauthorizedRequest(filterContext);
            }
            else
            {
                filterContext.Result = new RedirectToRouteResult(
                new System.Web.Routing.RouteValueDictionary(new { controller = "Home", action = "FailedLogin" }));

                filterContext.Result.ExecuteResult(filterContext.Controller.ControllerContext);
            }
        }
    }

To use the attribute decorate a controller action as follows replacing the GroupId with the Id of your group:

![](/assets/images/AzureAD2.png)