---
layout: post
title: Accessing B2C Claims in an Azure Function
authorId: simon_timms
date: 2019-02-13 19:00
categories:
  - B2C
originalurl: https://blog.simontimms.com/2019/02/13/2019-02-12-Getting-b2c-claims-in-an-azure-function/
---

In a [previous article](2019-01-30-Functions-aad-authentication) I talked about how to authenticate your function application against Azure Active Directory Business to Consumer (which we're going to call B2C for the sake of my fingers). Chances are in your function you're going to want to get some of the information which is available as a claim from the bearer token. Here is how to do it.

<!--more-->

On the surface this seems like a really simple problem. After all you can take the bearer token you got and paste it into [jwt.io](https://jwt.io/) and get back all the information you want. However we should probably take some effort to validate that what's coming back is what was originally derived from the B2C login. We can do this by making use of the System.IdentityModel.Tokens.Jwt NugGet package along with a bunch of other cryptographic stuff from the framework.

In my case I'm most interested in the `emails` claim so I can send the user an e-mail. The first thing we need to do is get the Issuer Signing key from Azure B2C. The easiest way to do this is to use the json metadata endpoint your service provided. 

![The metadata URL for your B2C](https://blog.simontimms.com/images/functions-claims/metadata.png)

If you click on that link you'll get a document like 

```javascript
{
	issuer: "https://yourtenant.b2clogin.com/a04a23ad-1e6a-4114-a91b-b8f8f7ac9660/v2.0/",
	authorization_endpoint: "https://yourtenant.b2clogin.com/yourtenant.onmicrosoft.com/oauth2/v2.0/authorize?p=b2c_1_siupin",
	token_endpoint: "https://yourtenant.b2clogin.com/yourtenant.onmicrosoft.com/oauth2/v2.0/token?p=b2c_1_siupin",
	end_session_endpoint: "https://yourtenant.b2clogin.com/yourtenant.onmicrosoft.com/oauth2/v2.0/logout?p=b2c_1_siupin",
	jwks_uri: "https://yourtenant.b2clogin.com/yourtenant.onmicrosoft.com/discovery/v2.0/keys?p=b2c_1_siupin",
	response_modes_supported: [
		"query",
		"fragment",
		"form_post"
	],
	response_types_supported: [
		"code",
		"code id_token",
		"code token",
		"code id_token token",
		"id_token",
		"id_token token",
		"token",
		"token id_token"
	],
	scopes_supported: [
		"openid"
	],
	subject_types_supported: [
		"pairwise"
	],
	id_token_signing_alg_values_supported: [
		"RS256"
	],
	token_endpoint_auth_methods_supported: [
		"client_secret_post",
		"client_secret_basic"
	],
	claims_supported: [
		"emails",
		"idp",
		"name",
		"sub",
		"tfp"
	]
}
```

In this document is the `jwks_uri` which, if you click on it will give you something like this (keys altered to protect the innocent)

```javascript

{
	keys: [{
		kid: "X5eXjf93njNFum1kl2Ytv8dlNP4-c57dO6QGTVBwaNk",
		nbf: 1493764781,
		use: "sig",
		kty: "RSA",
		e: "AQAB",
		n: "tVKUtcx_n9rt5afY_2WFNvU6PlFMggCatsZ3l4RjKxH0jgdLqab345de3ZGXYbPzXvmmLiWZizpb-h0qup5jznOvOr-Dhw9908584BSgC83YacjWNqEK3urxhyE2jWjwRm2N95WGgb5mzE5XmZIvkvyXnn7X8dvgFPF5QwIngGsDG8LyHuJWlaDhr_EPLMW4wHvH0zZCuRMARIJmmqiMy3VD4ftq4nS5s8vJL0pVSrkuNojtokp84AtkADCDU_BUhrc2sIgfnvZ03koCQRoZmWiHu86SuJZYkDFstVTVSR0hiXudFlfQ2rOhPlpObmku68lXw-7V-P7jwrQRFfQVXw"
	}]
}
```

The information in here is what's needed to decode the JWT and validate it. The keys here can rotate so if you're going to cache the information you'll want to make sure it expires with some frequency. I've seen an hour recommended but your mileage may vary. I followed the very helpful post [here](https://stackoverflow.com/a/47390593/361) for how to consume this information. 

In my function I grabbed the bearer token out of the request and passed it 

```csharp
var bearerToken = request.Headers["Authorization"].ToString().Split(' ').Last();
var json = await client.GetStringAsync(configService.TokenMetadataEndpoint()); //client is a static HTTP Client
JwtSecurityTokenHandler handler = new JwtSecurityTokenHandler();
var claims = handler.ValidateToken(bearerToken,
    new TokenValidationParameters
    {
        ValidateAudience = true,
        ValidateIssuer = true,
        ValidateLifetime = true,
        ValidIssuer =  configService.TokenIssuer(),
        ValidAudience = configService.TokenAudience(),
        IssuerSigningKeys = GetSecurityKeys(JsonConvert.DeserializeObject<JsonWebKeySet>(json))
    },
    out var validatedToken).Claims;
```

The token audience is the ID of the API application in Azure B2C. The token issuer I had trouble figuring out, in the end the only place I could find it was in a known JWT that I decoded. For me it ended up being `https://yourtenant.b2clogin.com/a04a23ad-1e6a-4114-a91b-b8f8f7ac9660/v2.0/`. I'm not sure if that GUID in there changes from tenant to tenant but certainly the host name in the URL will change to yours. We want to make sure to validate that the JWT hasn't expired (lifetime) that it was issued by our B2C instance (issuer) and that it was intended for this application (audience).

The claims object here will contain all of the claims for the JWT. I'm interested in `emails` so I run

```csharp
var email = claims.Single(x => x.Type == "emails");
```

Getting the security keys is done via this handy function which deserializes the keys into a list of SecurityKeys. 

```csharp
private static List<SecurityKey> GetSecurityKeys(JsonWebKeySet jsonWebKeySet)
    {
        var keys = new List<SecurityKey>();

        foreach (var key in jsonWebKeySet.Keys)
        {
            if (key.Kty == "RSA")
            {
                if (key.X5C != null && key.X5C.Length > 0)
                {
                    string certificateString = key.X5C[0];
                    var certificate = new X509Certificate2(Convert.FromBase64String(certificateString));

                    var x509SecurityKey = new X509SecurityKey(certificate)
                    {
                        KeyId = key.Kid
                    };

                    keys.Add(x509SecurityKey);
                }
                else if (!string.IsNullOrWhiteSpace(key.E) && !string.IsNullOrWhiteSpace(key.N))
                {
                    byte[] exponent = Base64UrlDecode(key.E);
                    byte[] modulus = Base64UrlDecode(key.N);

                    var rsaParameters = new RSAParameters
                    {
                        Exponent = exponent,
                        Modulus = modulus
                    };

                    var rsaSecurityKey = new RsaSecurityKey(rsaParameters)
                    {
                        KeyId = key.Kid
                    };

                    keys.Add(rsaSecurityKey);
                }
                else
                {
                    throw new Exception("JWK data is missing in token validation");
                }
            }
            else
            {
                throw new NotImplementedException("Only RSA key type is implemented for token validation");
            }
        }

        return keys;
    }
}
```

The final pieces are the models

```csharp
//Model the JSON Web Key Set
    public class JsonWebKeySet
    {
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore, NullValueHandling = NullValueHandling.Ignore, PropertyName = "keys", Required = Required.Default)]
        public JsonWebKey[] Keys { get; set; }
    }


    //Model the JSON Web Key object
    public class JsonWebKey
    {
        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore, NullValueHandling = NullValueHandling.Ignore, PropertyName = "kty", Required = Required.Default)]
        public string Kty { get; set; }

        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore, NullValueHandling = NullValueHandling.Ignore, PropertyName = "use", Required = Required.Default)]
        public string Use { get; set; }

        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore, NullValueHandling = NullValueHandling.Ignore, PropertyName = "kid", Required = Required.Default)]
        public string Kid { get; set; }

        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore, NullValueHandling = NullValueHandling.Ignore, PropertyName = "x5t", Required = Required.Default)]
        public string X5T { get; set; }

        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore, NullValueHandling = NullValueHandling.Ignore, PropertyName = "e", Required = Required.Default)]
        public string E { get; set; }

        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore, NullValueHandling = NullValueHandling.Ignore, PropertyName = "n", Required = Required.Default)]
        public string N { get; set; }

        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore, NullValueHandling = NullValueHandling.Ignore, PropertyName = "x5c", Required = Required.Default)]
        public string[] X5C { get; set; }

        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore, NullValueHandling = NullValueHandling.Ignore, PropertyName = "alg", Required = Required.Default)]
        public string Alg { get; set; }
    }
```

and the Bas64Decoder

```csharp
static byte[] Base64UrlDecode(string arg)
{
    string s = arg;
    s = s.Replace('-', '+'); // 62nd char of encoding
    s = s.Replace('_', '/'); // 63rd char of encoding
    switch (s.Length % 4) // Pad with trailing '='s
    {
        case 0: break; // No pad chars in this case
        case 2: s += "=="; break; // Two pad chars
        case 3: s += "="; break; // One pad char
        default:
            throw new System.Exception(
        "Illegal base64url string!");
    }
    return Convert.FromBase64String(s); // Standard base64 decoder
}
```

As with all things security related this stuff is confusing and convoluted. Hopefully this post will help out somebody in the future.