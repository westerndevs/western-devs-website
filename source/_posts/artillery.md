---
title:  Load Testing with Artillery
# Scenario 
# Getting started 
authorId: simon_timms
date: 2023-10-14
originalurl: https://blog.simontimms.com/2023/10/14/artillery
mode: public
---



Load testing a site or an API can be a bit involved. There are lots of things to consider like what the traffic on your site typically looks like, what peaks look like and so forth. That's mostly outside the scope of this article which is just about load testing with artillery.

## Scenario 

We have an API that we call which is super slow and super fragile. We were recently told by the team that maintains it that they'd made improvements and increased our rate limit from something like 200 requests per minute to 300 and could we test it. So sure, I guess we can do your job for you. For this we're going to use the load testing tool [artillery](https://www.artillery.io/).

## Getting started 

Artillery is a node based tool so you'll need to have node installed.  You can install artillery with `npm install -g artillery`.

You then write a configuration file to tell artillery what to do. Here's the one I used for this test (with the names of the guilty redacted):

```yaml
config: 
  target: https://some.company.com
  phases:
    - duration: 1
      arrivalRate: 1
  http:
    timeout: 100
scenarios:
 - flow:
    - log: "Adding new user
    - post:
        url: /2020-04/graphql
        body: |
          {"query":"query readAllEmployees($limit: Int!, $cursor: String, $statusFilter: [String!]!) {\n company {\n employees(filter: {status: {in: $statusFilter}}, pagination: {first: $limit, after: $cursor}) {\n pageInfo {\n hasNextPage\n startCursor\n endCursor\n hasPreviousPage\n }\n nodes {\n id\n firstName\n lastName\n\t\tmiddleName\n birthDate\n displayName\n employmentDetail {\n employmentStatus\n hireDate\n terminationDate\n }\n taxIdentifiers {\n taxIdentifierType\n value\n }\n payrollProfile {\n preferredAddress {\n streetAddress1\n streetAddress2\n city\n zipCode\n county\n state\n country\n }\n preferredEmail\n preferredPhone\n compensations {\n id\n timeWorked {\n unit\n value\n }\n active\n amount\n multiplier\n employerCompensation {\n id\n name\n active\n amount\n timeWorked {\n unit\n value\n }\n multiplier\n }\n }\n }\n }\n }\n }\n}\n","variables":{
          "limit": 100,
          "cursor": null,
          "statusFilter": [
          "ACTIVE",
          "TERMINATED",
          "NOTONPAYROLL",
          "UNPAIDLEAVE",
          "PAIDLEAVE"
          ]
          }}
        headers:
          Content-Type: application/json
          Authorization: Bearer <redacted>
```

As you can see this is graphql and it is a private API so we need to pass in a bearer token. The body I just stole from our postman collection so it isn't well formatted. 

Running this is as simple as running `artillery run <filename>`.

At the top you can see arrival rates and duration. This is saying that we want to ramp up to 1 requests per second over the course of 1 second. So basically this is just proving that our request works. The first time I ran this I only got back 400 errors. To get the body of the response to allow me to see why I was getting a 400 I set 
```
export DEBUG=http,http:capture,http:response
```

Once I had the simple case working I was able to increase the rates to higher levels. To do this I ended up adjusting the phases to look like 
```yaml
  phases:
    - duration: 30
      arrivalRate: 30
      maxVusers: 150
```

This provisions 30 users a second up to a maximum of 150 users - so that takes about 5 seconds to saturate. I left the duration higher because I'm lazy and artillery is smart enough to not provision more. Then to ensure that I was pretty constantly hitting the API with the maximum number of users I added a loop to the scenario like so:

```yaml
scenarios:
 - flow:
    - log: "New virtual user running"
    - loop:
      - post:
          url: /2020-04/graphql
          body: |
            {"query":"query readAllEmployeePensions($limit: Int!, $cursor: String, $statusFilter: [String!]!) {\n company {\n employees(filter: {status: { in: $statusFilter }}, pagination: {first: $limit, after: $cursor}) {\n pageInfo {\n hasNextPage\n startCursor\n endCursor\n hasPreviousPage\n }\n nodes {\n id\n displayName\n payrollProfile {\n pensions {\n id\n active\n employeeSetup {\n amount {\n percentage\n value\n }\n cappings {\n amount\n timeInterval\n }\n }\n employerSetup {\n amount {\n percentage\n value\n }\n cappings {\n amount\n timeInterval\n }\n }\n employerPension {\n id\n name\n statutoryPensionPolicy\n }\n customFields {\n name\n value\n }\n }\n }\n }\n }\n }\n}\n","variables":{
            "limit": 100,
            "statusFilter": [
            "ACTIVE"
            ]
            }}
          headers:
            Content-Type: application/json
            Authorization: Bearer <redacted>
      count: 100
```

Pay attention to that count at the bottom. 

I was able to use this to fire thousands of requests at the service and prove out that our rate limit was indeed higher than it was before and we could raise our concurrency.