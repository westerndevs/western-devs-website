---
title:  Open API Generator for C#
authorId: simon_timms
date: 2025-03-30
originalurl: https://blog.simontimms.com/2025/03/30/open-api-generator
mode: public
---



Every once in a while I run into the need to generate a C# client for some API which has been nice enough to provide me with OpenAPI specifications. But it's one of those things that I do so infrequently that I always forget how to do it. So I thought I would document it here.

The first thing to do is to install the OpenAPI generator. It's written in Java which is obviously a decision I'm solidly against. As I run a Mac most of the time I prefer to use brew since it's easier that trying to figure out how to build stuff with Maven. 

```bash
brew install openapi-generator
```

Now comes the fun part: figuring out the options to use. There are bunch of different generators for different languages and on top of that each generator has options. The C# generator is called `csharp` and the options are described in some detail here https://openapi-generator.tech/docs/generators/csharp. In my case I was looking to generator a client for a US Government API that they seem to be really snippy about people getting their hands on documentation about it without going through a heap of hoops so we'll just call it `USGovAPI` because this administration is not one I want to be on the wrong side of. 

In addition I wanted to generate one for .NET 8 because the project is still running on the long term support version of .NET. So the command ended up being 


```bash
openapi-generator generate -i swagger.json -g csharp -o out/usgoveapi --additional-properties=packageName=USGovAPI,targetFramework=net8.0
```

And with that we get a nice little C# client that we can use to call the USGovAPI. It even includes some unit tests to go along with it. 