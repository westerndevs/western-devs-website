---
title:  Advanced Web Application Firewall Rules in Azure with Terraform
## Web application firewall settings
authorId: simon_timms
date: 2021-05-19
originalurl: https://blog.simontimms.com/2021/05/19/advanced-waf-rules-in-terraform
mode: public
---



If you're creating an Application Gateway in Terraform for Azure you're using this resource `azurerm_application_gateway`. This resource allows for some basic configuration of the Web Application Firewall through the `waf_configuration` block. However the configuration there is very limited and basically restricted to turning it off and on and choosing the base rule set. If you want a custom rule then you need to break off the rules into a separate `azurerm_web_application_firewall_policy`. This can then be referenced back in the `azurerm_application_gateway` through the `firewall_policy_id`

You can use the advanced rules to set up things like Geographic restrictions. For instance this set of rules will block everything but requests from Canada and the US.

```
### Web application firewall settings
resource "azurerm_web_application_firewall_policy" "appfirewall" {
  name                = local.basename
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  custom_rules {
    name      = "OnlyUSandCanada"
    priority  = 1
    rule_type = "MatchRule"

    match_conditions {
      match_variables {
        variable_name = "RemoteAddr"
      }
      operator           = "GeoMatch"
      negation_condition = true
      match_values       = ["CA", "US"]
    }
    action = "Block"
  }

  policy_settings {
    enabled = true
    mode    = "Detection"
    # Global parameters
    request_body_check          = true
    max_request_body_size_in_kb = 128
    file_upload_limit_in_mb     = 100
  }
}
```