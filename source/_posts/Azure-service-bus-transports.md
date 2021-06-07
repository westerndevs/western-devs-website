---
title:  Transport for Azure Service Bus
# .NET Code
# Azure Functions
authorId: simon_timms
date: 2021-06-07
originalurl: https://blog.simontimms.com/2021/06/07/Azure-service-bus-transports
mode: public
---



There are two transport mechanisms for service bus 
* AQMP
* AQMP over web sockets

The default is to use plain AQMP but this uses port 5671. Often times this port may be blocked by firewalls. You can switch over to using the websocket based version which uses port 443 - much more commonly open already on firewalls. 

## .NET Code

You just need to update the `TransportType` in the service bus set up

```
var client = new ServiceBusClient(Configuration["ServiceBusConnection"], new ServiceBusClientOptions
{
    TransportType = ServiceBusTransportType.AmqpWebSockets
});
```

## Azure Functions

The simplest way of getting websockets to work on functions is to update the connection string to mention it

```
Endpoint=sb://someendpoint.servicebus.windows.net/;SharedAccessKeyName=SenderPolicy;SharedAccessKey=asecretkey;TransportType=AmqpWebSockets
```