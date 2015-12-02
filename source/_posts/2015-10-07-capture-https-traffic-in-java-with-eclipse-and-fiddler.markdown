---
layout: post
title:  Capturing HTTPS Traffic in Java with Eclipse and Fiddler
date: 2015-10-07 09:41:35
categories:
comments: true
author: david_wesst
originalurl: http://blog.davidwesst.com/2015/10/Capturing-HTTPS-Traffic-in-Java-with-Eclipse-and-Fiddler/
---
I've been struggling with a JSON parsing error where my application is using the [Spring](https://spring.io/guides/gs/consuming-rest/) to send and receive messages from a RESTful Web Service. It's pretty straight forward: I've annotated my object properties to match up with the appropriate JSON keys, Spring takes my POJO and turns it into a JSON string sends the request along with the JSON as the body to the HTTPS endpoint, et voilà!  

## The Problem

The problem comes in when something goes wrong with the request/response. Because the Spring obfuscates the actual request/response content, debugging it means you need to take a look at the traffic being sent over the wire. Since we're using a good RESTful service, the connection is done through HTTPS, meaning it's encrypted with a certificate that we don't have.

On top of that, it appears that Fiddler doesn't automatically capture Java HTTP traffic automatically, so that's a thing too.

After some internet sleuthing, I put together a solution that I wanted to share with you all, and so that I don't forget how to do it myself.

### Setup

1. Downlaod and Install [Fiddler](http://www.telerik.com/fiddler). I used Fiddler4, because I'm awesome.
2. Run it and make sure it's capturing HTTP traffic
3. Open *Tools --> Fiddler Options --> Connections Tab* and take note of the "Fiddler listens on port" value. It's likely 8888, but best to be sure.
4. In the same window select *HTTPS Tab* and make sure sure that the following options **are checked**:
	+ Capture HTTPS CONNECTS
	+ Decrypt HTTPS traffic (...from all processes)

![http://blog.davidwesst.com/2015/10/Capturing-HTTPS-Traffic-in-Java-with-Eclipse-and-Fiddler/certificate-warning.png](http://blog.davidwesst.com/2015/10/Capturing-HTTPS-Traffic-in-Java-with-Eclipse-and-Fiddler/certificate-warning.png)
		
6. Read, and if you're alright with it, install the certificate.
5. On the HTTPS tab, click the *Export Root Certificate to Desktop* and click OK.

![http://blog.davidwesst.com/2015/10/Capturing-HTTPS-Traffic-in-Java-with-Eclipse-and-Fiddler/fiddler-options.png](http://blog.davidwesst.com/2015/10/Capturing-HTTPS-Traffic-in-Java-with-Eclipse-and-Fiddler/fiddler-options.png)

### Generating a Keystore

1. Open a command line terminal as an administrator
2. Run the keytool for the JDK your application is using:

{% codeblock lang:powershell %}

<JDK_Home>\bin\keytool.exe -import -file C:\Users\<Username>\Desktop\FiddlerRoot.cer^
 -keystore FiddlerKeystore -alias Fiddler

{% endcodeblock %}

3. Enter a password and remember it
4. Your keystore is created as a file named "FiddlerKeystore*. Take note of where it is located on your machine.

### Configuring Eclipse

**NOTE:** You are not required to use Eclipse for this, but it seems to be the popular way of writing Java code.

1. Open your project and go to *Run --> Run Configurations*
2. Select the Run Configuration you want to use where you'll capture the HTTPS traffic.
3. Select the *Arguments* tab
4. Add the following to the *VMargs* textbox:

{% codeblock lang:java %}

-DproxySet=true
-DproxyHost=127.0.0.1
-DproxyPort=8888
-Djavax.net.ssl.trustStore="path\to\keystore\FiddlerKeystore"
-Djavax.net.ssl.trustStorePassword=yourpassword

{% endcodeblock %}

5. Click the *Apply* button
6. Click the *Run* button to try it out

![http://blog.davidwesst.com/2015/10/Capturing-HTTPS-Traffic-in-Java-with-Eclipse-and-Fiddler/eclipse-settings.png](http://blog.davidwesst.com/2015/10/Capturing-HTTPS-Traffic-in-Java-with-Eclipse-and-Fiddler/eclipse-settings.png)

Tada! You're done, and you should now be able to run your code and see the HTTP request and response, completely.

![http://blog.davidwesst.com/2015/10/Capturing-HTTPS-Traffic-in-Java-with-Eclipse-and-Fiddler/fiddler-success.png](http://blog.davidwesst.com/2015/10/Capturing-HTTPS-Traffic-in-Java-with-Eclipse-and-Fiddler/fiddler-success.png)
	
### Alternative Solution --- Configuring Your Code

Add the following lines to the application that you want to capture the HTTPS traffic.

{% codeblock lang:java %}

// for capturing HTTP traffic
System.setProperty("http.proxyHost", "127.0.0.1");
System.setProperty("http.proxyPort", "8888");
// for capturing HTTPS traffic
System.setProperty("https.proxyHost", "127.0.0.1");
System.setProperty("https.proxyPort", "8888");

{% endcodeblock %}

--
Thanks for playing. ~ DW

###### References

1. [Stack Overflow - How to Capture HTTPS with Fiddler in Java](http://stackoverflow.com/questions/8549749/how-to-capture-https-with-fiddler-in-java)
2. [How to Use Eclipse with Fiddler](http://codeketchup.blogspot.ca/2014/03/how-to-use-eclipse-with-fiddler-step-by.html)
