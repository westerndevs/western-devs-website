---
title:  Setting up SMTP for Keycloak Using Mailgun
authorId: simon_timms
date: 2023-10-30
originalurl: https://blog.simontimms.com/2023/10/30/smtp_setup_for_mailgun
mode: public
---



Quick entry here about setting up Mailgun as the email provider in Keycloak. To do this first you'll need to create SMTP credentials in Mailgun and note the generated password

![](/images/2023-10-30-smtp_setup_for_mailgun.md/2023-10-30-17-34-55.png))

Next in Keycloak set the credentials up in the realm settings under email. You'll want the host to be smtp.mailgun.org and the port to be 465. Enable all the encryptions and use the full email address as the username.
![](/images/2023-10-30-smtp_setup_for_mailgun.md/2023-10-30-17-34-24.png))

Check both the SSL boxes and give it port 465.