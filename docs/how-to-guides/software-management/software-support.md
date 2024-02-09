# Software Support

This document provides information about the software support process. That is, how our development team goes about addressing these issues. Including scheduling, project management tools and practices, issue soliciation, issue selection, and prioritization.


!!! Note "How to Submit Issues" 
    Our code is managed [via GitHub](https://github.com/DOI-USGS)

    Any issues with our software portfolio should be tracked in our repos through [GitHub issues](https://docs.github.com/en/issues/tracking-your-work-with-issues/about-issues). Links for some our more active repos: 

    * [ISIS](https://github.com/DOI-USGS/ISIS3/issues)
    * [ALE](https://github.com/DOI-USGS/ale/issues)
    * [USGSCSM](https://github.com/DOI-USGS/usgscsm/issues)

## Support Sprint Process 

Support sprints are dedicated efforts, time-boxed to 3 weeks quarterly. We schedule these as part of our internal scheduling procedures. Support sprints are scheduled 3 to 6 weeks ahead of time. A public prioritization meeting is scheduled prior to starting a support sprint. A notification of this meeting will be made (see below for how to subscribe) to the support mailing list 3 to 6 weeks ahead of time.

??? Question "How do I get Notified of Support Sprints and prioritization meetings?" 
    We email anyone who has opted in to our software support newsletter which includes when the support sprint was scheduled, when the prioritization meetings are happening, and a link to the meeting. These are sent shortly after it's scheduled and again right before the meeting. 
    
    Sign up [here](https://public.govdelivery.com/accounts/USDOIGS/signup/39118). 

### Step 1: Scheduling the Support Sprint
While there is some leeway in the exact timing of each support sprint, the sprints must be scheduled quarterly and should be scheduled roughly 3 months apart. Project scheduling should be coordinated by the project/technical lead and the software lead during routine software scheduling meetings.

After setting up the sprint schedule, we create a software support board and communicate the schedule to contributors. The prioritization meeting should be scheduled some day the week before the support sprint. 

### Step 2: Setting up the Project Board
Immediately after scheduling the support sprint, the technical lead should create a project board to facilitate the tracking, prioritization, and assignment of issues.  This has traditionally taken the form of a GitHub [projects board](https://github.com/orgs/DOI-USGS/teams/astrogeology-developers/projects) or a GitHub [discussion post](https://github.com/DOI-USGS/ISIS3/discussions), both of which provide automated tracking for issues that are hosted on GitHub. 


### Step 3: Notifying the Community

The community is notified via an email sent to anyone [subscribed to the newsletter](https://public.govdelivery.com/accounts/USDOIGS/signup/39118). 

This email should include:

1. The time of the prioritization meeting
1. Link to the meeting, a new meeting should be created every time via MS Teams.
1. The purpose of the meeting
1. The start / end date of the sprint
1. A solicitation for issues that are significant to the community
1. Instructions on getting issues added to the board.

??? Tip "Optional Boilerplate Email for MS Teams Calendar Event"
    This meeting will be used to prioritize the issues found at < link to project board > for the upcoming support sprint scheduled < date range of support >.  The list of issues found on the project board is currently incomplete.  If the list doesn't contain work that you would like to see scheduled during this sprint, then feel free to add items to the list.  For contributors outside the ASC, please note that organizational policy does not currently allow read/write access to internal project boards.  If you'd like work to be scheduled during this sprint, please ensure that an issue has been created and email me at < your email > to get the work scheduled.

??? Danger "For USGS devs: What mechanism do we use to send these emails out?"

    We use GovDelivery to create bulletins. These bulletins are emails which are broadcasted to our subscribers who have signed up with the link mentioned above. If you do not know how to create these bulletins ask the software lead for details of how to sign up for and sign into GovDelivery.


### Step 4: Selecting Additional Issues
Despite community engagement, contributors do not generally produce enough issues to ensure that there is enough work to fill the sprint.  In this case, the technical lead should select additional issues.  While these issues are chosen at the discretion of the technical lead, the following generally make good candidates for support sprints:

- Bug fixes
- Issues with significant community engagement
- Issues tagged with "missions" or "products"
- Issues that have a proposed solution
- Issues that appear to have an easy fix
- Issues with an existing PR

!!! Note "While there is no correct number of issues for each support sprint, support sprints typically include 35 - 50 issues."

### Step 5: Prioritizing Issues
Prioritization meetings are typically a loosely guided discussion in which the technical lead acts as the facilitator.  Prioritization meetings generally follow a format such as:

1. Ask attendees if there are any last-minute issues that should be added.
1. Introduce and prioritize issues.  If the issue creator is in attendance, call on them for an issue summary and their perspective on relative importance.  If the creator is not in attendance, the technical lead should be prepared to offer a summary / context on the issue and ask the community about the importance of the issue.
1. When all issues are prioritized, revisit any issues that may need additional discussion.
1. Ask for any closing remarks

??? Note "Issue deferral"
    Deferring an issue generally means "this is a good, important issue, but it requires further discussion." This discussion should not interrupt the flow of prioritization. 


## Continuous Support 

Internal developers have time to perform basic support tasks throughout the week. We refer to this as continuous support, as it's support time between dedicated sprints. This is to stay on top of GitHub notifications. 

As a user, you should expect feedback on an issue within a week of posting. If urgent, you can ping `@DOI-USGS/astrogeology-developers`. If the GitHub issue is open with no activity for a long enough time it will become stale and eventually auto-closed. Often, issues are not ignored, but are saved for a support sprint. 

??? Danger "Continuous Support and internal Developers"

    See the [internal software support docs](https://code.chs.usgs.gov/asc/ASC_Software_Docs/-/blob/main/Software%20Management/Continuous%20Support.md) for more information on continuous support. 