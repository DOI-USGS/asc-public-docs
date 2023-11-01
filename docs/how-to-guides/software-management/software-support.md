# Software Support
This document provides information about the software support process, including scheduling, project management tools and practices, issue soliciation, issue selection, and prioritization.


## Step 1: Scheduling the Support Sprint
While there is some leeway in the exact timing of each support sprint, the sprints must be scheduled quarterly and should be scheduled roughly 3 months apart. Project scheduling should be coordinated by the project/technical lead and the software lead during routine software scheduling meetings.

After setting up the sprint schedule, the technical lead should create a software support board and communicate the schedule to contributors.

## Step 2: Setting up the Project Board
Immediately after scheduling the support sprint, the technical lead should create a project board to facilitate the tracking, prioritization, and assignment of issues.  This has traditionally taken the form of a GitHub [projects board](https://github.com/orgs/DOI-USGS/teams/astrogeology-developers/projects) or a GitHub [discussion post](https://github.com/DOI-USGS/ISIS3/discussions), both of which provide automated tracking for issues that are hosted on GitHub. 

!!! Note "Due to recent changes in permissions and organizational boundaries, project boards can only be created as private (within-organization), which precludes external contributors from viewing or editing the board."

## Step 3: Notifying the Community
With a project board in place, there is now a mechanism to store incoming issues, and the technical lead can notify the community of the upcoming sprint.  There is no "correct" way to notify community members, but the recommended method is via an MS Teams calendar event, which allows the host to send an email with an associated meeting invitation.

This email should include:

1. The time of the prioritization meeting
1. The purpose of the meeting
1. The start / end date of the sprint
1. A solicitation for issues that are significant to the community
1. Instructions on getting issues added to the board.


??? Tip "Optional Boilerplate Email for MS Teams Calendar Event"
    This meeting will be used to prioritize the issues found at < link to project board > for the upcoming support sprint scheduled < date range of support >.  The list of issues found on the project board is currently incomplete.  If the list doesn't contain work that you would like to see scheduled during this sprint, then feel free to add items to the list.  For contributors outside the ASC, please note that organizational policy does not currently allow read/write access to internal project boards.  If you'd like work to be scheduled during this sprint, please ensure that an issue has been created and email me at < your email > to get the work scheduled.


## Step 4: Selecting Additional Issues
Despite community engagement, contributors do not generally produce enough issues to ensure that there is enough work to fill the sprint.  In this case, the technical lead should select additional issues.  While these issues are chosen at the discretion of the technical lead, the following generally make good candidates for support sprints:

- Bug fixes
- Issues with significant community engagement
- Issues tagged with "missions" or "products"
- Issues that have a proposed solution
- Issues that appear to have an easy fix
- Issues with an existing PR

!!! Note "While there is no correct number of issues for each support sprint, support sprints typically include 35 - 50 issues."

## Step 5: Prioritizing Issues
Prioritization meetings are typically a loosely guided discussion in which the technical lead acts as the facilitator.  Prioritization meetings generally follow a format such as:

1. Ask attendees if there are any last-minute issues that should be added.
1. Introduce and prioritize issues.  If the issue creator is in attendance, call on them for an issue summary and their perspective on relative importance.  If the creator is not in attendance, the technical lead should be prepared to offer a summary / context on the issue and ask the community about the importance of the issue.
1. When all issues are prioritized, revisit any issues that may need additional discussion.
1. Ask for any closing remarks

??? Note "Issue deferral"
    Deferring an issue generally means "this is a good, important issue, but it requires further discussion." This discussion should not interrupt the flow of prioritization, and discussing deferred issues is usually a good final topic.