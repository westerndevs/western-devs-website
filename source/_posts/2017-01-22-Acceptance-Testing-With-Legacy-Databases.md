---
layout: post
title: Acceptance Testing With Legacy Databases
categories:
  - Testing
date: 2017-01-22 10:04:33
tags:
  - Acceptance Testing
  - Unit Testing
  - Legacy code
  - jackson
  - WireMock
authorId: amir_barylko
originalurl: http://orthocoders.com/blog/2017/01/01/acceptance-testing-with-legacy-databases/
---

One of the most common _pain points_ of implementing automated acceptance testing is the interaction with the database.

For greenfield projects you can plan from day one how to setup the test to easily include the database interaction but with legacy projects it is not always that easy.

<!--more-->

## Dealing with legacy code

Let’s face it: **Testing is hard**.

I do not mean it is hard to understand. The complexity is not inherently attached to the concept of testing but (I found in most cases) a by-product of `tooling + environment + database`.

That is the reason why I think adding testing to a legacy system can be quite challenging. We did not choose the tooling, nor the database nor did we set up the environment to be test friendly.

So where to start with testing?

One option is to start by adding _unit tests_ into the codebase, but that could be a paramount effort considering that quite often the legacy code was not written with testability in mind. A lot of change, a lot of risk.

On the other hand _acceptance testing_ is the perfect candidate.

Why? _Acceptance Testing_ puts the focus on testing end to end. Given a certain input, run it through the system and make sure the output is what we expect to see.

It works for web applications, web apis, libraries, desktop applications, you name it. And also, in many cases we will not need to modify the code behaviour at all.

All that is fine and dandy, but what about the database? We may be able to create a local copy of the database to test, but what are we going to do with data generation, logic stored in the database, etc?

## A perfect world

Let’s pause and imagine for just a few paragraphs that instead of using a database the _system under test_ uses an HTTP API to get all the information it needs.

If that was the case then we could implement acceptance testing very easily by doing something like the following pseudo algorithm:

- Launch a fake HTTP server listening on the URI expected by the system.
- Create some data that will work for my test case.
- When the application does the call, return that data.
- Validate the case worked as expected.
- Shutdown the server.

Neat right? This approach has many benefits.

_First_, we keep modifications of the system under test to the bare minimum.

_Second_, there are lots of tools in multiple languages that can help us with such a task. We can choose the same environment or one that is completely different. Whichever works better for our needs.

_Third_, these steps can be easily automated and ran when it is convenient and useful.

Ok, the break is over.

## Back to reality

To change all the database related code to start using some kind of web API could be a huge risk and effort.

Such amount of refactoring may cripple your project for a long time, and not even produce a positive result.

Having said that, what if we use the same idea but with a small twist?.

## Leave the database code alone

Well, not alone alone, but let’s hide it behind a very thin wrapper.

The goal is that instead of directly hitting the database (or whichever function or class is being used) we are going to call a proxy that is sole job is to forward the call to the same code we were using before.

The main difference is that the _Proxy_ talks about the domain. If we were fetching some `Customer` object from the database, then the proxy will have a way to do so and return a `Customer` collection.

So the database interaction, _ORM_ mapping, etc, stays hidden.

To illustrate the idea with a bit of code, let’s imagine a class in charge of finding customers in order to show them:

{% codeblock lang:csharp %}
public class CustomersController {

  public CustomerView index() {

    String query = "select NAME, ADDRESS, BIRTH_DATE from CUSTOMERS";

    ResultSet rs = dbConnection.createStatement().executeQuery(query);

    List<Customer> customers = new ArrayList<Customer>();

    while(rs.next()) { customers.add(loadCustomer(rs)); }

    return new CustomerView(customers);
  }

  private Customer loadCustomer(ResultSet rs) { ...... }
}
{% endcodeblock %}

The first step would be to create an _interface_ and abstract the query to the database:

{% codeblock lang:csharp %}
public interface CustomersQuery {
  List<Customer> getCustomers();
}
{% endcodeblock %}

And a default implementation that does the database query:

{% codeblock lang:csharp %}
public class DatabaseCustomerQuery implements CustomersQuery {

  public List<Customer> getCustomers() {

    String query = "select NAME, ADDRESS, BIRTH_DATE from CUSTOMERS";

    ResultSet rs = dbConnection.createStatement().executeQuery(query);

    List<Customer> customers = new ArrayList<Customer>();

    while(rs.next()) { customers.add(loadCustomer(rs)); }

    return customers;
  }

  private Customer loadCustomer(ResultSet rs) { ...... }
}

{% endcodeblock %}
And the original class now it uses the interface:

{% codeblock lang:csharp %}
public class CustomersController {

  public CustomerView index() {
    return new CustomerView(this.customersQuery.getCustomers());
  }
}

{% endcodeblock %}

## Mock the proxy

When testing the system, the library in charge of _proxying_ the interaction to the database could be switched to a different one that does an HTTP call to a URI and returns the result based on the response.

By using an HTTP call, then the test will pose as the expected source of data and respond based on the needs of each case.

Following the previous example, we could implement a class that gets the customers data using an HTTP call to the test URI.

The example uses [Jackson](https://github.com/FasterXML/jackson) to load the json content.

{% codeblock lang:csharp %}
public class HttpCustomersQuery implements CustomerQuery {

  public List<Customer> getCustomers() {
    HttpGet httpGet = new HttpGet(testUrl + "/customers");
    HttpResponse response = httpclient.execute(httpGet);

    ObjectMapper mapper = new ObjectMapper();
    List<Customer> customers = mapper.readValue(response.getEntity().getContent(), new TypeReference<List<Customer>>(){});

    return customers;
  }
}
{% endcodeblock %}

The last step, when running the tests we will launch the HTTP server to serve the JSON customers:

Here I am using [WireMock](http://wiremock.org/) to set up the response.

{% codeblock lang:csharp %}
@Test
public void testCustomersView()  {

  List<Customer> expected = createSomeFakeCustomers();

  String serializedCustomers = JSON.write(expeted);

  stubFor(get(urlEqualTo("/customers"))
            .willReturn(aResponse()
                .withStatus(200)
                .withHeader("Content-Type", "application/json")
                .withBody(serializedCustomers)));

  // run the system under test here
  runSystem();

  List<Customer> actual = getCustomersShown() ; // get the customers that are being shown

  assertThat(expected, is(actual));
}
{% endcodeblock %}

### Why bother with HTTP?

We could implement the “fake” version of the library as:

{% codeblock lang:csharp %}
public class HttpCustomersQuery implements CustomerQuery {

  public List<Customer> getCustomers() {
    String jsonContent = loadResourceFrom("/resources/customers.json");

    ObjectMapper mapper = new ObjectMapper();
    List<Customer> customers = mapper.readValue(jsonContent, new TypeReference<List<Customer>>(){});

    return customers;
  }
}
{% endcodeblock %}

However this approach may limit our ability to separate completely the acceptance test implementation from the system we want to test.

Having an external server to pose as data source provides flexibility and could simplify quite a bit the test implementation because it gives us the freedom to choose any tool that we may see fit to do the actual implementation.

This technique could simplify manual testing as well. The test scenario data could be setup, then the system launched and wait for manual confirmation to ensure it works as expected.

{% codeblock lang:gherkin %}
Given the customers are loaded             # All the customers in the JSON file are loaded
When listing the customers                 # Launch the system to show the customers
Then every customer name shows in the list # Ensure all customers are shown
{% endcodeblock %}

## Change impact

The change will be localized. Modifying a particular functionality of the system does not affect how other parts of the system work nor major refactoring effort is required.

Of course there will be some code change, but hopefully very small and just to hide the database related code behind a very thin wrapper.

Once the acceptance tests start to roll, each new test will be easier and easier.

Not only the system will have a new safety net that becomes larger and larger with every test, but the quality will grow as well.
