---
layout: post
title:  "Continuous Integration With Xamarin.iOS, Visual Studio Team Services, and MacinCloud: Part 1"
date: 2015-12-10T15:38:11-05:00
comments: true
authorId: lori_lalonde
originalurl: http://solola.ca/xamarin-macincloud-vsts-part1/
alias: /continuous-integration-with-xamarin-ios-visual-studio-team-services-and-macincloud-part-1/
---

Recently, Microsoft and MacinCloud announced a partnership in which they have enabled Visual Studio Team Services (VSTS) to support continuous integration (CI) builds for Xamarin.iOS and XCode projects using&nbsp;a Mac build agent&nbsp;in the cloud. This is great news as more companies are looking to move&nbsp;towards cloud-hosted solutions for their build and deployment pipeline.

<!--more-->

Although MacinCloud indicates that the [VSTS Agent Plan setup][1] only takes a few minutes, the process is not fully automated and requires some manual steps in order to get your CI Builds working as expected. The initial setup is fairly quick, but your Xamarin.iOS CI builds will fail until you install a [Xamarin ][2]license on the MacinCloud CI Build Server. The catch? Unlike the other MacinCloud plans, the CI Build Agent Plan does not allow you to directly interact with the Build Server. Instead, you are required to contact both MacinCloud Support and Xamarin Support to complete the process. Set your expectations that it may take anywhere from&nbsp;2 – 4 days before you can start using the CI Build Agent.

Let's take a look at what is involved, from start to finish, to successfully configure a CI Build&nbsp;Agent for your Xamarin.iOS projects.

### Step 1: Register for MacinCloud plan

In order to integrate&nbsp;Macincloud with Visual Studio Team Services, you need to register for a [CI Build Agent plan][3] at [MacinCloud.com][4]. The CI Build Agent cost is $29 US per month per build agent.

### Step 2: Create a new VSTS Agent

Once you are registered, you must setup your build agent through the Dashboard, as shown below.

![][5]

_MacinCloud Dashboard_

Select the Edit button to configure your MacinCloud VSTS Agent.

### Step 3: Associate the MacinCloud Build Agent to your VSTS Account

In the Edit VSTS Agent dialog, enter a unique agent name and a pool name. Note that the pool name must match the name of an Agent Pool in Visual Studio Team Services.

![][6]

_MacinCloud Edit VSTS Agent Dialog_

Enter your&nbsp;VSTS URL to associate this build agent with your Team Services account.

### Step 4: Generate a Microsoft Access Token in VSTS for the Build Agent

Next, you will need to provide&nbsp;the&nbsp;MacinCloud Build Agent access to your VSTS account, which requires that you&nbsp;generate a Microsoft Access Token from your VSTS profile.

To do this, open a new browser tab, log into your VSTS account and navigate to the security tab for your account profile. Alternatively you can click the "?" button situated to the right of&nbsp;the Microsoft Access Token entry field in the Edit VSTS Agent dialog, which will launch the "Create a personal access token" page in your VSTS Dashboard. Provide a&nbsp;Description, and then select an Expiry term&nbsp;as well as&nbsp;the desired&nbsp;VSTS Account. Ensure **All scopes** is selected for Authorized Scopes then click the _Create Token_ button.

![][7]

_VSTS Dashboard – Create a personal access token_

### Step 5: Enter&nbsp;the&nbsp;Microsoft Access Token in the&nbsp;MacinCloud Edit VSTS Agent dialog

Copy the generated access token to the clipboard and paste it in the MacinCloud Microsoft Access Token field in the Edit VSTS Agent dialog.

**Important Note:** Be sure to save a copy of the generated access token in a safe location. You will not be able to retrieve the generated access token again once you navigate away from the Security page after it has been created.

If you wish, you can add your signing&nbsp;certificate&nbsp;and provisioning profile at this time, but it's not required in the initial setup.

Click _Save_ to create your MacinCloud CI Build&nbsp;Agent.

### Step 6: Confirm that the MacinCloud Agent appears in the&nbsp;VSTS Agent Pool

Navigate to the Admin section within your VSTS Dashboard and select the Agent Pools tab. Select the Agent Pool that matches the Pool Name you entered in the&nbsp;MacinCloud&nbsp;Edit&nbsp;VSTS Agent dialog. If everything is configured properly, then the MacinCloud agent will appear in the Agents list, as shown below.

![][8]

_MacinCloud VSTS Agent associated&nbsp;with Default Agent Pool in VSTS_

### Step 7: Install Xamarin License on the Mac&nbsp;Server&nbsp;

Last but not least, you will need to install a Xamarin license on the Mac server where your CI Build Agent is hosted. Unfortunately, MacinCloud does not provide you with interactive access to the server. This requires&nbsp;some back and forth correspondence with MacinCloud Support and Xamarin Support in order to finish the setup process.

### Step 7a: Request System Profile Information from MacinCloud Support

First, you will need to submit a support request to MacinCloud to obtain the server information and system file that Xamarin will require in order to generate a license file for your CI Build Server.

Send an email to [support@macincloud.com][9] with the following request:

"I am setting up a CI Build Agent to configure continuous integration&nbsp;builds in&nbsp;Visual Studio Team Services for Xamarin.iOS applications. Please send me the system profile of my CI Build Agent, which I will need to forward to Xamarin support so they can generate a License file. To retrieve the system profile, perform the following steps:

– Go to: Macintosh HD -&gt; Applications -&gt; Utilities -&gt; System Information.app

– Choose File &gt; Save

– Select a location to save the file, such as the desktop, or Documents folder.

– Name and save the file.

– Please email the file to me when this is completed."

This initial email will generate a support ticket within the [MacinCloud Support Portal][10]. You will receive an email containing a link to the support request so you can view its status at any time.

Note that response time from MacinCloud Support will vary, with the expectation that it can take anywhere from a couple of hours to 1 full business day to receive a response depending on the time of day that you submit the request.

The generated system profile information file will simply be an xml file with a _.spx_ extension.

### Step 7b: Request a license from Xamarin Support

Once you receive the system profile information file from MacinCloud Support, you will need to send it to Xamarin Support. Log into your [Xamarin account][11], go to your Dashboard and select [Xamarin.iOS][12] to locate the support email address for your subscription.

Send an email to the Xamarin Support using the specified email address, requesting a _**License.V2**_ file to be generated for your MacinCloud CI Build Agent. Be sure to attach the _spx_ file that you received from MacinCloud to this request.

Xamarin Support will provide you with the license file and instructions on where the file should be placed on the server. The Xamarin.iOS license file must be copied to the ~/Library/MonoTouch folder on the build server.

I found the turnaround time on this request to be relatively quick.

### Step 7c: Forward the license to MacinCloud Support

Forward the license file and relevant instructions to MacinCloud Support, and wait until they send a confirmation that the license has been installed on the server.

**_To Be Continued..._**

Now that you have the MacinCloud CI Build Agent properly&nbsp;configured, you will be able to setup&nbsp;continuous integration builds for your Xamarin.iOS projects! In the next post, we will walk through the necessary steps to create a Xamarin.iOS build definition in Visual Studio Team Services.

&nbsp;

&nbsp;

[1]: http://www.macincloud.com/pricing/build-agent-plans/vso-build-agent-plan
[2]: http://xamarin.com
[3]: http://www.macincloud.com/pricing/compare
[4]: http://www.macincloud.com/
[5]: http://solola.ca/wp-content/uploads/2015/12/1-MIC_Dashboard-1024x219.png
[6]: http://solola.ca/wp-content/uploads/2015/12/2-MIC_EditVSTSAgent-1024x931.png
[7]: http://solola.ca/wp-content/uploads/2015/12/3-VSTS_Security_AccessToken-1024x617.png
[8]: http://solola.ca/wp-content/uploads/2015/12/4-VSTS_AgentPools-1024x368.png
[9]: mailto:support@macincloud.com
[10]: http://support.macincloud.com/support/home
[11]: https://xamarin.com/account/login
[12]: https://store.xamarin.com/account/my/subscription?product=Xamarin.iOS
  