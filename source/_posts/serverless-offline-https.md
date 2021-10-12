---
title:  Running Serverless Offline with a Self-Signed SSL Certificate
# Generate a Cert Using OpenSSL
# Running with the Certificate
# Gotchas
authorId: simon_timms
date: 2021-10-12
originalurl: https://blog.simontimms.com/2021/10/12/serverless-offline-https
mode: public
---



If you find yourself in need of running serverless locally using [serverless offline](https://www.serverless.com/plugins/serverless-offline/) and you want an SSL certificate then fear not, it's not all that difficult. First you'll need an SSL certificate. For our purposes you we're going to use a self-signed certificate. This will cause browsers to complain but for local testing it isn't typically a big problem. 

## Generate a Cert Using OpenSSL

You should install OpenSSL (or one of the more secure alternatives like [LibreSSL](https://www.libressl.org/)) and then run 

```
openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out cert.pem
```

This will prompt you for a bunch of information about your organization. You can put anything you want in most of those fields but do pay attention to the `Common Name` field which needs to hold the value of `localhost`. 

These are the answers I gave
```
Country Name (2 letter code) [AU]:US
State or Province Name (full name) [Some-State]:TX
Locality Name (eg, city) []:Austin
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Inventive
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:localhost
Email Address []:
```

You should now have a `cert.perm` and a `key.pem` in your local directory. Copy these into a `cert` folder at the root of your serverless project. 

## Running with the Certificate

Now you need to tell serverless where to find your certificate. You can either run with the flag

```
--httpsProtocol cert
``` 

or update your `serverless.yml` to include the cert directory 

```
custom:
  serverless-offline:
    httpsProtocol: "cert"
    ...
```

## Gotchas

If you're seeing a warning about an invalid certificate then check that you're accessing serverless via `localhost` and not `127.0.0.1` or `0.0.0.0`. SSL works with domain names so you need to use one, even if it is just `localhost`.