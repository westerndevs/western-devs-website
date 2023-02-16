---
title:  Allow Comments in JSON Payload in ExpressJS
authorId: simon_timms
date: 2023-02-16
originalurl: https://blog.simontimms.com/2023/02/16/express-json-comments
mode: public
---



Officially comments are not supported in the JSON format. In fact this lack of ability to comment is one of the reasons that lead to the downfall of the JSON based project system during the rewrite of the .NET some years back. However they sure can be useful to support. In my case I wanted to add some comments to the body of a request to explain a parameter in Postman. I like to keep comments as close to the thing they describe as possible so I didn't want this on a wiki somewhere nobody would ever find. 

The content looked something like 

```json
{
    "data": {
        "form_data": {
            "effective_date": "2023-02-23",
            "match_on_per_pay_period_basis": 0, /* 0 if yes, 1 if no */
            "simple_or_tiered": 1, /* 0 if simple 1 if tiered */
        }
    }
}
```

This was going to an ExpressJS application which was parsing the body using `body-parser`. These days we can just use `express.json()` and avoid taking on that additional dependency. The JSON parsing in both these is too strict to allow for comments. Fortunately, we can use middleware to resolve the issue. There is a swell package called `strip-json-comments` which does the surprisingly difficult task of stripping comments. We can use that. 

The typical json paring middleware looks like

```javascript
app.use(express.json())

or 

app.use(bodyParser.json())
```

Instead we can do 

```javascript
import stripJsonComments from 'strip-json-comments';

...

app.use(express.text{
    type: "application/json" // 
}) //or app.use(bodyParser.text({type: "application/json}))
app.use((req,res,next)=> {
    if(req.body){
        req.body = stripJsonComments(req.body);
    }
    next();
})
```

This still allows us to 