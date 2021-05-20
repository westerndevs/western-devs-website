---
title:  Using Durable Entities
# Gotchas
authorId: simon_timms
date: 2021-05-20
originalurl: https://blog.simontimms.com/2021/05/20/durable-entities
mode: public
---



Durable entities are basically blobs of state that are stored somewhere (probably table storage). You can retrieve them and signal them with changes. They can be tied directly into standard Azure functions. 

You build one as pretty much a POCO that looks like 

```csharp
[JsonObject(MemberSerialization.OptIn)]
public class DuplicatePreventor
{
    [JsonProperty("value")]
    public int CurrentValue { get; set; };

    public void Add(int amount) => this.CurrentValue += amount;

    public void Reset() => this.CurrentValue = 0;

    public int Get() => this.CurrentValue;

    [FunctionName(nameof(DuplicatePreventor))]
    public static Task Run([EntityTrigger] IDurableEntityContext ctx)
        => ctx.DispatchAsync<DuplicatePreventor>();
} 
```

In this example there is one piece of state: the CurrentValue. You can retrieve it using the Get() function. Add and Reset are other signals you can send to the state. 

Using it in a function involves adding a client to the signature of the function like so 

```csharp
[FunctionName("ShopifyPurchaseWebhook")]
public static async Task<IActionResult> Run(
    [HttpTrigger(AuthorizationLevel.Function, "post", Route = null)] HttpRequest req,
    [DurableClient] IDurableEntityClient client,
    ILogger log)
{
        ...
}
```            

Once you have the client you can retrieve an existing state by specifying an entityId and then getting it from the client
```csharp
var entityId = new EntityId(nameof(DuplicatePreventer), webhook.order_number.ToString());
var duplicationPreventionEntity = await client.ReadEntityStateAsync<DuplicatePreventer>(entityId);
```

This gets you back a wrapper which includes properties like `EntityExists` and `EntityState`. 

You can signal changes in the entity through an unfortunate interface that looks like 

```
await client.SignalEntityAsync(entityId, "Add", 1);
```

That's right, strings are back in style. 

## Gotchas

If you create the durable entity in your function and then request it's value you at once you won't get the correct value - you just get null. I'd bet they are using some sort of outbox model that only sends data updates at the end of the function execution. 