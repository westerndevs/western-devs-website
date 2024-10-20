---
title:  Let's Encrypt on Azure AKS
!/bin/bash
 Install the CustomResourceDefinition resources separately
 Create the namespace for cert-manager
 Label the cert-manager namespace to disable resource validation
 Add the Jetstack Helm repository
 Update your local Helm chart repository cache
 Install the cert-manager Helm chart
 Helm v3+
 To automatically install and manage the CRDs as part of your Helm release,
 you must add the --set installCRDs=true flag to your Helm installation command.
authorId: simon_timms
date: 2024-10-13
originalurl: https://blog.simontimms.com/2024/10/13/letsencrypt-azure-aks
mode: public
---



Wow, what an adventure I had getting Let's Encrypt certificates issued for my Azure AKS cluster. I had to go through a lot of different resources to get this working so I thought I would document it here. First thing to know is that the Azure documentation on this varies from slightly wrong to completely wrong. I have a bunch of PRs out for it but who knows how long that will take. 

<!-- more -->

What we're going to go through here is getting ingress working and then slapping a Let's Encrypt certificate on it. For ingress we're going to be using the Azure Application Gateway Ingress Controller. This one uses App Gateway to front the cluster so we can use all the rules and features of App Gateway which I think we'll be using to do some GeoIP blocking in the future. So first up we need to provision an Application Gateway. This can be done in a number of ways but we're using Open Tofu(Terraform) so to get the App Gateway provisioned we tag it onto the K8S cluster:

```
resource "azurerm_kubernetes_cluster" "default" {
  name                      = var.kubernetes_cluster_name
  location                  = var.resource_group_location
  resource_group_name       = var.resource_group_name
  tags                      = var.tags
  dns_prefix                = "k8s"
  automatic_upgrade_channel = "stable"
  kubernetes_version        = "1.30.4"
  node_resource_group       = local.node_resource_group_name
  sku_tier                  = "Free"

  default_node_pool {
    name                        = "default"
    node_count                  = 3
    os_sku                      = "Ubuntu"
    temporary_name_for_rotation = "defaulttemp"
    vm_size                     = "Standard_D8_v5"
    zones                       = [1, 2, 3]
  }

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  maintenance_window {
    allowed {
      day   = "Saturday"
      hours = [0, 1, 2, 3, 4, 5, 6]
    }
  }

  network_profile {
    dns_service_ip    = "10.245.0.10"
    load_balancer_sku = "standard"
    network_plugin    = "kubenet"
    network_policy    = "calico"
    pod_cidr          = "10.244.0.0/16"
    service_cidr      = "10.245.0.0/16"
  }

  oms_agent {
    log_analytics_workspace_id      = var.log_analytics_workspace_id
    msi_auth_for_monitoring_enabled = true
  }

  web_app_routing {
    dns_zone_ids = [var.web_application_routing_dns_zone_id]
  }

  ingress_application_gateway {
    gateway_name = "${var.kubernetes_cluster_name}-app-gateway"
    subnet_cidr  = "10.225.0.0/16"
  }
}
```
The important part is the last section there with `ingress_application_gateway`. This is what tells the AKS cluster to use the App Gateway as the ingress controller and provision one for you. If you want more granular control over the App Gateway you can provision is separately and then just point the AKS cluster at it. I tried that once but couldn't get the setting quite right so this is much easier as it will handle any network peering you might need. 

Great now we have that set up we can move onto getting a service and an ingress set up. We have a container listening on port 80 so we just need to put ingress and a service in front of it. For this project I'm using Grafana Tanka(https://tanka.dev/) instead of Helm. Why? I don't know at this stage, initially it looked cool but I struggled quite a bit with the syntax in places. Still it does a really nice diff during our builds prior to deploying so I'm sticking with it for now.

The service looks like this:

```
    service: service.new($._config.containers.web.name, { app: 'wotc-web' }, ports=[{ name: 'http', port: 80, targetPort: $._config.containers.web.port }]) {
      metadata+: {
        namespace: 'wigglepiggle-' + $._config.environment,
        labels: {
          app: $._config.containers.web.name,
          environment: $._config.environment,
        },
      },
      spec+: {
        type: 'ClusterIP',
        selector: {
          app: $._config.containers.web.name,
          environment: $._config.environment,
        },
      },
    },
```
What's going on here? We're creating a service in the `wigglepiggle-dev` namespace with some labels describing the app and environment. Don't get caught here: I initially thought labels were just fun annotations like they are in Azure resources but K8S uses them for selecting services so it's pretty important to get them right. We set up the ports to forward 80 to 80 and give the port a name of `http`. 

Now the ingress:

```
ingres: k.networking.v1.ingress.new($.config.containers.web.name) {
      metadata+: {
        name: $._config.containers.web.name,
        namespace: 'wigglepiggle-' + $._config.environment,
        labels: {
          app: $._config.containers.web.name,
          environment: $._config.environment,
        },
      },

      spec+: {
        ingressClassName: 'azure-application-gateway',
        rules: [
          {
            host: $._config.containers.web.domain,
            http: {
              paths: [
                {
                  path: '/',
                  pathType: 'Prefix',
                  backend: {
                    service: {
                      name: $._config.containers.web.name,
                      port: {
                        number: 80,
                      },
                    },
                  },
                },
              ],
            },
          },
        ],
      },
    },
```
Here we again expose the port 80 and give a path of `/` along with a host which is what will be used to determine with service a request will be routed to. 

If we deploy these now we should be able to see an entry in the `Services and ingresses` section of the K8S cluster. And if we click into that we should be able to get to the resource - but no HTTPS. The DNS entry is provisioned, in my case, using the Azure DNS service. 

Now onto SSL! I'm cheap as a... well I can't think of how cheap I am without resorting to racial stereotypes but I'm pretty cheap. So I'm going to use Let's Encrypt to get a free certificate. For this I'm going to use the cert-manager. This is where the Azure documentation falls apart. You can read the docs at https://learn.microsoft.com/en-us/azure/application-gateway/ingress-controller-letsencrypt-certificate-application-gateway but I'd suggest using the below instead. We start by installing the cert-manager:

```
#!/bin/bash


kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.1/cert-manager.crds.yaml


kubectl create namespace cert-manager


kubectl label namespace cert-manager cert-manager.io/disable-validation=true


helm repo add jetstack https://charts.jetstack.io


helm repo update



helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.16.1 \
  # --set installCRDs=true



```

This installs the cert manager. It's job is to provision and update certificates for us. We then need to create a ClusterIssuer. This is a resource that tells the cert-manager where to get the certificates from. In this case we're going to use Let's Encrypt. 

```
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    email: team-wigglepiggle@inventive.io
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt-private-key
    solvers:
      - http01:
          ingress:
          #   class: azure/application-gateway
            ingressTemplate:
              metadata:
                annotations:
                  kubernetes.io/ingress.class: azure/application-gateway
```

This will directly use prod Let's Encrypt - you might want to play using the staging server first if you're not confident. I wasn't confident. In here we've set the email which will have certificate expiries sent to it (but you should never see them because cert-manager will renew certs before they expire). 

Now we need to create a Certificate resource. This is what will actually get the certificate for us. I provisioned a certificate with a lot of DNS names instead of a wildcard. Might revisit this later.

```
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: wigglepiggle
spec:
  secretName: wigglepiggle-tls
  privateKey:
    rotationPolicy: Always
  commonName: wigglepiggle.com
  dnsNames:
    - wigglepiggle.com
    - "www.wigglepiggle.com"
    - "wotc.wigglepiggle.com"
    - "i9.wigglepiggle.com"
    - "user.wigglepiggle.com"
    - "admin.wigglepiggle.com"
    - "communication.wigglepiggle.com"
    - "wotc-dev.wigglepiggle.com"
    - "i9-dev.wigglepiggle.com"
    - "user-dev.wigglepiggle.com"
    - "admin-dev.wigglepiggle.com"
    - "communication-dev.wigglepiggle.com"
    - "wotc-tst.wigglepiggle.com"
    - "i9-tst.wigglepiggle.com"
    - "user-tst.wigglepiggle.com"
    - "admin-tst.wigglepiggle.com"
    - "communication-tst.wigglepiggle.com"
  usages:
    - digital signature
    - key encipherment
    - server auth
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
```

Now all that's left is to update the ingres to use this certificate. 

```
ingres: k.networking.v1.ingress.new($.config.containers.web.name) {
      metadata+: {
        name: $._config.containers.web.name,
        namespace: 'wigglepiggle-' + $._config.environment,
        labels: {
          app: $._config.containers.web.name,
          environment: $._config.environment,
        },
        annotations: {
          'kubernetes.io/ingress.class': 'azure/application-gateway',
          'cert-manager.io/cluster-issuer': 'letsencrypt-prod',
        },
      },

      spec+: {
        tls: [
          {
            hosts: [$._config.containers.web.domain],
            secretName: 'wigglepiggle-tls',
          },
        ],
        ingressClassName: 'azure-application-gateway',
        rules: [
          {
            host: $._config.containers.web.domain,
            http: {
              paths: [
                {
                  path: '/',
                  pathType: 'Prefix',
                  backend: {
                    service: {
                      name: $._config.containers.web.name,
                      port: {
                        number: 80,
                      },
                    },
                  },
                },
              ],
            },
          },
        ],
      },
    },
```

Notice the lines with `annotations` and `tls`. This tells the ingress to use the certificate we just provisioned. The secret name should match the one in the certificate resource.

Phew! That's all it took to get Let's Encrypt certificates on an Azure AKS cluster. I hope this helps you out.
