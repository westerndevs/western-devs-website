---
title:  Consuming SOAP Services in .NET Core
# Core WCF
authorId: simon_timms
date: 2022-05-30
originalurl: https://blog.simontimms.com/2022/05/30/consuming-wsdl
mode: public
---



Today I ran into the need to consume an older SOAP web service in .NET Core. I was really fortunate in my timing because Core WCF was just released and it makes the whole process much easier. 

Taking a step back for you youngsters out there SOAP was the service communication technology that existed before REST showed up with its JSON and ate everybody's lunch. SOAP is really just the name for the transport mechanism but I think most of us would refer to the whole method of invoking remote procedures over the web as `SOAP Web Services`. SOAP, or Simple Object Access Protocol, is an XML-based standard for serializing objects from various different languages in a way that Java could talk to .NET could talk to Python. Unlike JSON it was a pretty well thought out protocol and had standard representations of things like dates which JSON just kind of ignores. 

Web services were closer to a remote method invocation in that you would call something like `GetUserId` rather than the RESTful approach of hitting an endpoint like `/Users/7` to get a user with Id 7. The endpoints which were provided by a Web Service were usually written down in a big long XML document called a WSDL which stands for Web Service Definition Language. 

Web services gained a reputation for being very enterprisy and complex. There were a large number of additional standards defined around it which are commonly known as ws-*. These include such things as WS-Discovery, WS-Security, WS-Policy and, my personal favorite, the memorably named Web Single Sign-On Metadata Exchange Protocol. 

## Core WCF

In the last month we've seen the 1.0 release of [Core WCF]( https://devblogs.microsoft.com/dotnet/corewcf-v1-released/) which I'm pretty certain I mocked at being a silly thing in which to invest resources. Tables have turned now I'm the one who needs it so thank to [Scott Hunter](https://twitter.com/coolcsh) or whoever it was that allocated resources to developing this. 

To get started I needed to find the WSDLs for the services I wanted. This required a call to the support department of the company providing the services. The had a .NET library they pointed me to but it was compiled against .NET 4.5 so I wanted to refresh it. Fortunately the Core WCF release includes an updated `svcutil`. This tool will read a WSDL and generate service stubs in .NET for you. 

I started with a new console project 

```bash
dotnet new console
```

Then installed the dotnet-svcutil tool globally (you only need to do this once) and generated a service reference

```bash
dotnet tool install --global dotnet-svcutil
dotnet-svcutil --roll-forward LatestMajor https://energydataservices.ihsenergy.com/services/v2/searchservice.svc
```

This updated my project's csproj file to include a whole whack of new library references 

```xml
<?xml version="1.0" encoding="utf-8"?>
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net6.0</TargetFramework>
    <RootNamespace>wsdl_test</RootNamespace>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>
  <ItemGroup>
    <DotNetCliToolReference Include="dotnet-svcutil" Version="1.0.*" />
  </ItemGroup>
  <ItemGroup>
    <PackageReference Include="CoreWCF.Http" Version="1.0.0" />
    <PackageReference Include="CoreWCF.Primitives" Version="1.0.0" />
    <Reference Include="System.ServiceModel">
      <HintPath>System.ServiceModel</HintPath>
    </Reference>
  </ItemGroup>
  <ItemGroup>
    <PackageReference Include="System.ServiceModel.Duplex" Version="4.8.*" />
    <PackageReference Include="System.ServiceModel.Http" Version="4.8.*" />
    <PackageReference Include="System.ServiceModel.NetTcp" Version="4.8.*" />
    <PackageReference Include="System.ServiceModel.Security" Version="4.8.*" />
  </ItemGroup>
</Project>
```

It also generated a 13 000 line long service reference file in the project. Wowzers. I'm glad I don't have to write that fellow myself. 

With that all generated I'm now able to call methods in that service by just doing 

```csharp
using ServiceReference;
var client = new SearchServiceClient();
var result = await client.SomeMethodAsync();
```

This example really only scratches the surface of what the new Core WCF brings to .NET Core. I certainly wouldn't want to develop new WCF services but for consuming existing ones or even updating existing ones then this library is going to be a great boost to productivity. 