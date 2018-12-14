---
layout: post
title:  Validating Client Certificate Auth
date: 2018-13-21T00:00:00-06:00
categories: certificates azurefunctions
comments: true
authorId: justin_self
---

Do you need to validate a client certificate is being passed to a server correctly but don't want to muck with local TLS and webserver configs? I got you.

<!-- more -->

[1]: https://imgur.com/ehuVZqx.png
[2]: https://imgur.com/knx5FJd.png

This can be done two ways.

1 - Check for the X-ARR-ClientCert request header and, if present, base64 decode the value and load it into a X509Certificate2. From there, you can check the thumprint to validate the client is correctly sending the certificate with the request.

2 - Get the request context and check to see if the ClientCertificate is null. If it's not then check the thumprint.

I chose the second way for one single reason - I did not know about the first way. So, if you choose the second way you'll need to make a setting change to allow the certificate to be passed in with the request (instead of as part of the request header).

Go to the SSL settings of the function app.

![1]

Enable the `Incoming client certificates` flag.

![2]

Here's some code:

        [FunctionName("Function1")]
        public static async Task<HttpResponseMessage> Run([HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)]HttpRequestMessage req, TraceWriter log)
        {
            var clientCert = req.GetRequestContext().ClientCertificate;
            if (clientCert == null)
            {
                return req.CreateResponse(HttpStatusCode.BadRequest, "There's no client certificate");
            }

            log.Info($"Client Thumbprint: {req.GetRequestContext().ClientCertificate?.Thumbprint ?? "No cert found."}");
            return req.CreateResponse(HttpStatusCode.OK, $"Thumbprint: {clientCert.Thumbprint}", new JsonMediaTypeFormatter());
        }


Boom. Done. All in all, this took about 8 minutes to do (including creating the function app) and it saved me from mucking around with my machine, generating a cert, configuring the web server etc., and now others on my team can use it.

Using the second way gives an added benefit of forcing all requests to include a client cert. So, if your app immediately gets rejected, you know the cert isn't even being loaded.
