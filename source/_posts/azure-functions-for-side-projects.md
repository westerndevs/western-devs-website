---
title: An exploration of Azure Functions for a side project
authorId: kyle_baley
date: 2024-06-23
mode: public
---

This is a short PSA for people (or, more likely, just future me) to describe two issues I ran into while migrating a bash file to Azure Functions. Namely:

- How do I see the exceptions that happened?
- How do I configure an Azure Function app to save a PDF to a Google Drive folder

This is from the perspective of someone who doesn't need their app to be highly available/scalable/reliable/tenable/affable/inscrutable/explicable, which the documentation for all cloud products seems to assume (and, it must be said, rightfully so).

<!-- more -->

I like crossword puzzles. And I like doing them on paper. I subscribe to a few services, including the New York Times, [AVCX](https://avxwords.com/), [Matt Gaffney](https://xwordcontest.com/), the [Muller Monthly Music Meta](https://pmxwords.com/), and a couple of others, both free and paid. For years, I've maintained a [bash file](https://github.com/kbaley/xword-downloader) that downloads PDFs from various services that allow it (and some that likely don't) and merges them into a single document for printing. It works fine but I wanted to try my hand at moving it to an Azure Function app that ran on a timer rather than on demand like I do with the bash file.

So the app in question is pretty simple and the code itself isn't super interesting. Here are the logistics:

- Runs nightly
- Downloads PDFs from various crossword providers (three so far)
- Saves the PDF to Google Drive

The last one is only because that's where I keep them after they're printed. I have an archive of the puzzles I've downloaded going back a number of years. I've no idea why except that I have the storage available. Maybe I'll run through them again in retirement but the more likely scenario is that my children will mass delete them in a housecleaning exercise after I die.

With that in mind, let's get to the two areas where I struggled.

## App Insights

By most accounts, App Insights on Azure is a powerful tool and telemetry in general is a big business. But I've always shied away from the Diagnose/Investigate/Metrics tabs because they're just plain overwhelming for an aging hillbilly who's used to scrolling through IIS log files. So when I wake up in the morning and the latest Times puzzle isn't there, I need to figure out where to go.

My solution (which may not align with _the_ solution) is pretty simple in the end:

- Navigate to the Function app in Azure
- Go to Monitoring | Logs
- Query the `exceptions` table with no other qualifers and with an appropriate time range

This shows the exceptions and the stack traces within the time period. Given this runs nightly, there likely won't be more than a couple in the last 24 hours.

## Connect to a Google Drive folder

Ugh...

I've said this on more than one occasion: I hate all things security-related including, but not limited to: certificates, OAuth, face ID, fingerprint scanners, digital signatures, encryption, authentication providers, 2FA, MFA, SSL, VPN, CVE, IAM, JWT, SSO, AES, TSA, passkeys, passwords, passports, key fobs, car alarms, and bike locks.

Setting up an Azure Function App to connect to Google Drive touches on several of these pet peeves and adds a few more. Here's what I eventually did to get this to work:

- Create a project in my Google Developer Console
- Enable the Google Drive API (it wasn't enabled by default)
- Create a [service account](https://cloud.google.com/iam/docs/service-account-overview) credential
- Under the new service account, create a _key_. This downloads a file to your computer.
- Upload the file to the Azure Storage account for the Azure Functions app in a File Share folder called `secrets`
- Create two environment variables for the Azure Function:
  - GoogleApiSecretsFileName: the name of the file (include the .json extension) I downloaded for the key
  - GoogleDriveFolderId: The ID of the folder where the puzzles should be saved. (Navigate to the folder in a browser. The ID is everything after `folder/` in the URL.)
- Share the Google drive folder with the Google API service account (with Editor access). The email address is on the Credentials page in the Google Developer Console.

Oh, and also write the actual code.

The [Azure documentation](https://learn.microsoft.com/en-us/azure/app-service/configure-authentication-provider-google) and ChatGPT suggest strongly that OAuth2 credentials (instead of a service account) should work if you set up Google as an authenticator on the Azure Functions app. I ran into problems with this and I _think_ it's because I was running locally. I have the app set up to do everything through a console app instead of through the Azure Functions host when running in DEBUG mode and I suspect the problems are because my local app hasn't gone through the necessary authentication process. Either way, a service account explicitly says it's for unattended server-to-server scenarios, which this is, so I've justified it in my head, even if the Azure documentation suggests something else.

