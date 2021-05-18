---
title:  Transforms
# Testing
authorId: simon_timms
date: 2021-05-08
originalurl: https://blog.simontimms.com/2021/05/08/xdt-transforms
mode: public
---



You can apply little transforms by just writing XML transformation on configuration files. For instance here is one for adding a section to the `system.web` section of the configuration file

```xml
<?xml version="1.0"?>
<configuration xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
  <system.web>
    <machineKey xdt:Transform="Insert" decryptionKey="abc" validationKey="def" />
  </system.web>
</configuration>
```

Here is one for removing an attribute

```xml
<?xml version="1.0"?>
<configuration xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
  <system.web>
    <compilation xdt:Transform="RemoveAttributes(debug)" />
  </system.web>
</configuration>
```

How about changing an attribute based on matching the key?

```xml
<?xml version="1.0"?>
<configuration xmlns:xdt="http://schemas.microsoft.com/XML-Document-Transform">
  <appSettings>
    <add key"MaxUsers" value="3" xdt:Transform="SetAttributes" xdt:Locator="Match(key)" />
  </appSettings>
</configuration>
```

If you happen to be using Octopus Deploy they have a feature you can add to your IIS deployment task to run these transformations

![](/images/2021-05-06-xdt-transforms.md/2021-05-06-13-34-59.png))

## Testing

There is a great little online testing tool at https://elmah.io/tools/webconfig-transformation-tester/ where you can plug in random things until you get them working.