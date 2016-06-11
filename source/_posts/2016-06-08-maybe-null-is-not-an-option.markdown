---
layout: post
title: "Maybe null is not an Option"
date: 2016-06-08 22:28:25
tags:
  - fsharp
  - functional
  - design
categories:
  - Fsharp
  - Functional programming
authorId: amir_barylko
originalurl: http://orthocoders.com/blog/2016/06/08/maybe-null-is-not-an-option/
---

[Tony Hoare](http://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare) calls _null references_ his **billion dollar mistake**. Using `null` values (`NULL`, `Null`, `nil`, etc) makes code harder to maintain and to understand. 

But what can we do about it? To start let's review the meaning of `null` values ...

<!-- more -->

## Modeling optional results

### Finding Customers

Finding operations are very common. Given a `Customer` class, a `Find` method could look like this:

``` csharp
public Customer Find(Query query) ;
```

Now what happens when the customer can not be found? Possible options are:

* Throw an exception: Why though? Where is the exceptional case? Trying to find a `Customer` has the possible scenario of not beign found.

* Return `null` to mean nothing was found. But are we positive we are getting a `null` for that reason and not other? And what can we do with the `null` value after?

* Return a `NullObject` that represents `Customer` null value. That could work to show some of the customer's data, if we expect strings or something similar. But for most cases this won't be enough.

### Parsing Integers

In _C#_ you can use `Int32.parse` or `Int32.tryParse` to do the job. The former throws an `Exception` when the string can not be parsed into an int and the later returns a `Bool` indicating if the operation succeeded using an `out` parameter for the value.

The first approach is not that intuitive. I want to get a result, not to catch an exception. 

The second one with the boolean result seems to go in the right direction but having an `out` parameter complicates things, and makes it hard to understand and hard to pass to another function, etc.

### Optional values

_F#_ has a very simple way to deal with this by creating a [Discriminated Union](https://fsharpforfunandprofit.com/posts/discriminated-unions/) with only two values:

``` fsharp
type Option<'T> = 
  | Some of 'T 
  | None
```

Now finding customers has a very clear interface:

``` fsharp
let tryFindCustomer (q: query) : Option<Customer>
```

Parse clearly can succeed giving the parsed result or fail, therefore the result is `Optional`.

``` fsharp
let tryParseInt (s:string) =
  match Int32.TryParse(s) with
  | true, result -> Some result
  | false, _     -> None

```

NOTE: out parameters are converted tuples in F#.

As a convention is common to call functions `trySomeAction` when the action can fail and return an _optional_ value.

## Working with optional values

Modeling optional values is a great start. Using an optional value makes very clear the fact that the caller has the _responsibility_ to handle the possiblity of having `None` as a result.

Having clear meaning improves clarity, intent, error handling, and there is no `null` that can cause problems.

However, in terms of handling the result, are we that much better than before?

Of course we could check always for `Some` or `None` and handle the result, but where is the `fun` in that?

The key to create a great abstraction is _usage_. After seeing the same bit of code used again and again we could be confident that _abstracting_ the behaviour is going to be really useful.

To avoid doing a `match` on `Option` types luckily we have a series of helper functions that address most common scenarios.

Many of these functions live in the [FSharpx](https://github.com/fsprojects/FSharpx.Extras) library.

### Using defaults

To obtain the value from an `Option` we can use `Option.get`:

``` fsharp
let get = 
  function
  | Some a -> a
  | None   -> failwith "Nothing to get!"

```

(what's that `function`? Here is an [explanation about pattern maching function](http://fsharpforfunandprofit.com/posts/match-expression/))

Notice that `get` throws an exception when there is nothing to get.

Throwing exception (and catching it) is ok, but makes hard to compose the result or transform it.

Instead why not use a default value when there is `None`? (Taken from [FSharpx](https://github.com/fsprojects/FSharpx.Extras/blob/master/src/FSharpx.Extras/ComputationExpressions/Monad.fs)):

``` fsharp
let getOrElse v = 
  function
  | Some a -> a
  | None   -> v
```

Knowing that it can fail, and having a default value help us write code that can use a default value and keep going:

``` fsharp
let doWebRequest countStr =
  countStr
  |> tryParse
  |> Option.getOrElse 10
  |> processRequest
```

### Applying functions

Another common scenario is to apply a function when we get a result or just do nothing otherwise:

For exmple, the following code will only print the message when `tryParse` returns `Some`:

``` fsharp
let doWebRequest param =
  param
  |> tryParse
  |> Option.iter (printf "The result is %d")
```

And the implementation:

``` fsharp
let iter f = 
  function
  | Some a -> f a
  | None   -> unit
```


### Shortcircuit `None`

`iter` is useful to execute a function when there is `Some` value returned, but is common to use the value somehow and transform it into something else.

For that we can use the `map` function:

``` fsharp
let map f = 
  function
  | Some a -> f a |> Some
  | None   -> None
```

This is a bit different. Not only the function passed as parameter is applied after _unboxing_ the value, but the result is _boxed_ back into an `Option`. Once an `Option` always an `Option`.

Imagine a [railway](http://fsharpforfunandprofit.com/rop/) and a train that once hits the value `None` switches to a `None` railway and bypasses any operation that comes after. Thus the _shortcircuit_.

``` fsharp
let queryCustomers quantity = [] // silly implementation

let doWebRequest req =
  req.tryGetParam "customers"
  |> Option.map queryCustomers         // Shortcircuit with None
  |> Option.getOrElse invalidRequest   // uses the default
```

### Mapping to `Option`

Another common case, very similar to `map`, is to use a function that transforms the boxed value and returns an `Option`.

``` fsharp
let bind f = 
  function
  | Some a -> f a 
  | None   -> None
```

For example the parameter that represents the _customer id_ is a string, and we need to parse it into an int. Getting the parameter can return a `None` and the parse function could return a `None` as well.

``` fsharp
let doWebRequest req =
  req.tryGetParam "customerId"
  |> Option.bind Int32.tryParse       // Shortcircuit if None
  |> Option.map  findCUstomer         // Shortcircuit if None
  |> Option.getOrElse invalidRequest
```

## Multiple optional values

So far so good with one parameter. But what happens with more than one parameter? The goal is to _shortcircuit_ and if one of the parameters is `None` then abort and just return `None`.

One option is to use _FSharpx_ and the `MaybeBuilder`. I'm not going to discuss the details of how builders work but I will show you the practical usage to illustrate the point.

``` fsharp
  type Result<'TData> = 
    | Success of 'TData
    | Error of string

  let findCustomers count country city = ... // implement query

  let invalidRequest = "Boooo! Not all parameters are present!"

  let doWebRequest (req:Request) =
    maybe {
      let! strCount = req.tryGetParam "count"
      let! city     = req.tryGetParam "city"
      let! country  = req.tryGetParam "country"
      let! count    = Int32.tryParse strCount
      return findCustomers count country city
    }
    |> Option.map Success
    |> Option.getOrElse (invalidRequest |> Error)
```

In this scenario we have a happy path:

* All parameters are present, then the result is `Success` with the output of `findCustomers`.

And four _unhappy_ paths:

* `count` is not present, then the `maybe` builder does shortcircuit to `None` and `getOrElse` returns an `Error`.
* `city` is not present, then the `maybe` builder does shortcircuit to `None` and `getOrElse` returns an `Error`.
* `country` is not present, then the `maybe` builder does shortcircuit to `None` and `getOrElse` returns an `Error`.
* `count` is present, but can not be parsed then ... shortcircuit ... and `Error`.

The `let!` is doing the _unboxing_ from `Option` to the actual type, and when any of the expressions has the value `None` then the builder does the _shortcircuit_ and returns `None` as result.

## Applicative Style

Another way to write the same concept (sometimes a bit more clear) is to use the _Applicative_ style by using operators that represent the operations that we already are using that also apply shortcircuit when possible. 

For the functions we have used in the `Option` type the operators are:

``` fsharp
<!> // is an alias for map
>>= // is an alias for bind
```

_(Find all the definitions [here](https://github.com/fsprojects/FSharpx.Extras/blob/master/src/FSharpx.Extras/ComputationExpressions/Monad.fs))_.

To use them let's try to read the parameters from the request.

``` fsharp
  let city    = req.tryGetParam "city"
  let country = req.tryGetParam "country"
```

Good, now `count` needs to be parsed as well, so we can use `tryParse` that returns an `Option`. What can we use when we need to apply a function that returns also an `Option`? `Bind` of course, or `>>=`.

``` fsharp
  let count = req.tryGetParam "count" >>= Int32.tryParse 
```

All the parameters are parsed into `Option` and `findCustomers` can be invoked.

``` fsharp
  findCustomers <!> count ???? city ??? country
```

To apply a function over an `Option` we can use the operator `<!>` (`map`), but what about the other two parameters?

Let me rephrase, what happens when we apply a function that takes three parameters to just one parameter? Exactly! A partial application!

Same happens when applying the operator `<!>` to a function that takes three parameters, the difference is that the partially applied function gets _boxed_ in an `Option`.

``` fsharp
  let count = req.tryGetParam "count" >>= Int32.tryParse 

  findCustomers <!> count ... // returns an Option<int -> int -> Customer list>
```

Now we need to apply the boxed function to a boxed value, and for that we can use the operator `<*>` that takes a boxed function and a boxed value and returns the boxed version of applying the function to the value.

``` fsharp
  findCustomers <!> count <*> city  ... // partial application of the function to city
```

In this case we have two more parameters so the full version would be:

``` fsharp
  let findCustomers count city country = [] 

  let doWebRequest (req:Request) =
    let city    = req.tryGetParam "city"
    let country = req.tryGetParam "country"
    let count   = req.tryGetParam "count" >>= Int32.tryParse 

    findCustomers <!> count <*> city <*> country
    |> Option.map Success
    |> Option.getOrElse (invalidRequest |> Error)
```

## Summary

Using an `Option` to represent when a value may not be present has many advantages. 

Not only is easier to deal with cases that produce no results, but also the code is clear an easy to follow.

Though here the code is in F# you could implement similar features in your favourite language. 

(_Check out Java 8 [Optional class](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html) or this [C# implementation of Maybe](https://github.com/adamkrieger/FSBetter/blob/master/functions/0.2_Maybe.csx) by [Adam Krieger](https://twitter.com/AdamKrieger)_).

All the code can be found [here](https://github.com/amirci/option-sample). I included a series of tests that show how the builder and applicative style apply a shortcircuit when one of the parameters is missing.

Thanks to my good friend [Shane](https://twitter.com/Dead_Stroke) for helping me to test the code in all platforms.

