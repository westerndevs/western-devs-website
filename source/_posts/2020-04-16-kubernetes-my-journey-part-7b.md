---
layout: post
title: Kubernetes - My Journey - Part 7b
category: kubernetes
tags: kubernetes, azure, aks, identityserver, docker, containers
authorId: dave_white
date: 2020-04-16 10:00
---
<style>
    h1, h2, h3, h4, h5, h6 {
       margin-top: 25px;
    }

    img {
       margin: 25px 0px;
    }
    figure.highlight{
        background-color: #E8EEFE;
    }
    figure.highlight .gutter{
        color: #0033CD;
    }
    figure.highlight pre {
        font-family: 'Cascadia Code PL', monospace;
    }
    code {
        font-family: 'Cascadia Code PL', sans-serif;
        border-width: 0.1em;
        border-color: #E8EEFE;
        border-style: solid;
        border-radius: 0.3em;
        background-color: #E8EEFE;
        color: #0033CD;
        padding: 0em 0.4em;
        white-space: nowrap;
    }
    blockquote {
        position: relative;
        font-family: 'Cascadia Code PL', serif;
        padding-left: 1em;
        border-left: 0.2em solid #005da0;
        font-size: 1.1em;
        line-height: 1em;
        font-weight: 100;
        &:before, &:after {
            content: '\201C';
            color: #005da0;
        }
        &:after {
            content: '\201D';
        }
    }
</style>
<link  href="https://cdnjs.cloudflare.com/ajax/libs/viewerjs/1.5.0/viewer.min.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/viewerjs/1.5.0/viewer.min.js"></script>

[Series Table of Contents](/kubernetes/kubernetes-my-journey)

**Previously:**
[Moving to Azure Kubernetes Service - Part A](/kubernetes/kubernetes-my-journey-part-7a)

# Moving to Azure Kubernetes Service - Part B

We're really making some progress! We should have our **AKS** cluster running now and ready for use to start putting some resources into. If you don't, head on back to the previous article in the series and get your **k8s** standing up in Azure!

## Continuing with Pulumi

In the prevoius article, we used Pulumi exclusively to describe what we wanted in our **AKS** infrastructure and we had the Pulumi CLI do all the hard work of provisioning our **k8s** cluster. Now we are going to ask Pulumi to do a little more work and help us get our **k8s** resources into the cluster.

First, let's create a new Pulumi Project and Stack to hold our resource specific configuration values, application, and history.

Let's create a folder in our infrastructure folder for the **k8s** deployment stack. Starting in your `infra` folder, run the command:

`mkdir k8s && cd k8s`

Now use the Pulumi CLI to build our new project with its initial stack.

`pulumi new azure-typescript --secrets-provider=passphrase`

This will kick off the workflow to acquire some details before it creates the stack. In my case, I answered the workflow questions with:

1. project name (k8s) <-- hit enter and accepted default
1. project description: **Deploy our kubernetes infrastructure**
1. stack name: (dev) <-- hit enter and accepted default
1. Enter your passphrase to protect config/secrets: **P@ssw0rd!**
1. azure:environment: (public) <-- hit enter and accept default
1. azure:location: (WestUS) **WestUS**

This will scaffold our new project and submit the project and stack details to our Pulumi cloud. Let's open VS Code, open the **index.ts** and delete everything from the file.

We are going to need to add the Pulumi kubernetes SDK module to our project.

`npm install @pulumi/kubernetes`

Now, at the top of our empty **index.ts** file, we can add the following imports.

```typescript
import * as pulumi from "@pulumi/pulumi";
import * as k8s from "@pulumi/kubernetes";
```

### Getting Configuration Values

In our **AKS** Pulumi project/stack, we had a number of configuration values that we stored in our Pulumi service. One of those important configuration values was the kubeConfig file that contains the credentials required to connect to our **k8s** instance. We are now going to use the Pulumi SDK to get that kubeConfig value so that we can use it in this project.

[Inter-Stack Dependencies](https://www.pulumi.com/docs/intro/concepts/organizing-stacks-projects/#inter-stack-dependencies)

```typescript
// setup config
const env = pulumi.getStack(); // reference to this stack
const stackId = `dave/aks/${env}`;
const aksStack = new pulumi.StackReference(stackId);
const kubeConfig = aksStack.getOutput("kubeConfig");
const k8sProvider = new k8s.Provider("k8s", { kubeconfig: kubeConfig  });

// output kubeConfig for debugging purposes
let _ = aksStack.getOutput("kubeConfig").apply(unwrapped => console.log(unwrapped));

```

If we break down this fragment of Typescript, we see that:

1. Get a reference to the current stack
1. Ask Pulumi for an object reference to our **AKS** stack variables. We want the kubeConfig secret from it.
1. Create a **k8s.Provider** using the acquired kubeConfig values
    - (Option) - Output the kubeConfig to the console for debugging

`pulumi up` to test your application. It should simply compile, access our **aks8** stack, and output the kubeConfig!

### Labels

Almost everything in **k8s** uses labels to perform important actions. For example, Services expose Deployments that match the selector labels. Also, you can use labels to do queries via **kubectl** or as filters in **octant**, **k9s**, or the **Kubernetes Web UI**. You'll see labels used throughout the manifests and the Pulumi code.

We will define some common label groups that we'll use throughout our application, merging them with service/deployment specific sets of labels as required. You can add to these groups as required for your situation.

```typescript
// Common labels
const baseBackEndLabels = { tier: "backend", group: "infrastructure" };
const baseApplicationGroupLabels = {tier: "frontend", group:"auth"};
```

### Moving Postgres from Manifest to Pulumi

Now that we have a **k8s.Provider** that we can use to send instructions to our **AKS** cluster, we need to create the Pulumi instructions to start putting resources into our **k8s** cluster. Starting with postgres, let's take a look at our manifest that we used when putting resources into **minikube**.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgres-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 1Gi
  hostPath:
    path: /var/lib/postgresql/data
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-dep
  labels:
    app: postgres
    tier: backend
    group: infrastructure
spec:
  replicas: 1
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      volumes:
        - name: postgres-pv-storage
          persistentVolumeClaim:
            claimName: postgres-pv-claim
      containers:
        - name: postgres
          image: postgres:alpine
          env:
            - name: POSTGRES_USER
              value: "admin"
            - name: POSTGRES_PASSWORD
              value: "P@ssw0rd!"
            - name: POSTGRES_DB
              value: "identity"
          ports:
            - containerPort: 5432
          volumeMounts:
            - mountPath: "/var/lib/postgresql/data"
              name: postgres-pv-storage
---
# from postgres-svc.yml
apiVersion: v1
kind: Service
metadata:
  name: postgres-svc
spec:
  selector:
    app: postgres
  ports:
    - protocol: TCP
      port: 5432
```

We're going to ignore the first resource in the manifest. Because we are using **AKS**, we are able to take advantage of the _dynamic persistent volume_ mechanism that is provided. We simply need to create **PersistentVolumeClaim** with the correct **storageClass** and **Azure/AKS** will take care of provisioning an actual persistent volume for us and attaching it to the correct host/node.

The second resource is the PersistentVolumeClaim. The important differnce between the manifest and the Pulumi application is going to be the use of the **storageClassName** configuration value that is coming from our **aksStack** configuration. In the **AKS** stack, this value is set to **managed-premium**.

For our third resource, the actual Deployment, we mostly want to map the values from our manifest into the TypeScript/JSON notation.

Last but not least, we map the Service manifest settings that will give the postgres-dep resource some network (internal to cluster) configuration into our Pulumi application.

```typescript
// Add Postgres to AKS Cluster
const postgresLabels = {...{ app: "postgres", role: "db" }, ...baseBackEndLabels};

const postgresPVClaimName = "postgres-pv-claim";
const postgresPersistentVolumeClaim = new k8s.core.v1.PersistentVolumeClaim(postgresPVClaimName,{
    metadata:{ name: postgresPVClaimName},
    spec: {
        storageClassName: aksStack.getOutput("storageClassName"),
        accessModes: ["ReadWriteOnce"],
        resources: {
            requests: {
                storage: "32Gi"
            }
        }
    }
}, {provider: k8sProvider});

const postgresDepName = "postgres-dep";
const postgresDeployment = new k8s.apps.v1.Deployment(postgresDepName, {
    metadata: { 
        name: postgresDepName, 
        labels: postgresLabels
    },
    spec: {
        selector: { matchLabels: postgresLabels },
        replicas: 1,
        revisionHistoryLimit: 2,
        template: {
            metadata: { labels: postgresLabels },
            spec: {
                containers: [{
                    name: "postgres",
                    image: "postgres:alpine",
                    volumeMounts: [{
                        mountPath: "/var/lib/postgresql/data",
                        name: "volume"
                    }],
                    resources: {
                        requests: {
                            cpu: "100m",
                            memory: "100Mi",
                        },
                    },
                    ports: [{ containerPort: 5432 }],
                    env: [
                        {name: "POSTGRES_USER", value: "admin"},
                        {name: "POSTGRES_PASSWORD", value: "P@ssw0rd!"},
                        {name: "POSTGRES_DB", value: "identity"},
                        {name: "PGDATA", value: "/mnt/data/pgdata"}
                    ]
                }],
                volumes:[{
                    name: "volume",
                    persistentVolumeClaim: {
                        claimName: postgresPVClaimName
                    }
                }]
            },
        },
    },
}, {provider: k8sProvider});

const postgresServiceName = "postgres-svc";
const postgresService = new k8s.core.v1.Service(postgresServiceName, 
    {
        metadata: {
            name: postgresServiceName,
            labels: postgresLabels,
        },
        spec: {
            ports: [{ port: 5432, protocol: "TCP"}],
            selector: postgresLabels,
        },
    }, {provider: k8sProvider});
```

`pulumi up` to compile our application and deploy postgres into the **k8s** cluster!

### Moving pgAdmin4 from Manifest to Pulumi

Our next step is to migrate the pgAdmin4 manifest settings into Pulumi. This is going to be mostly the same as the postgres migration. I'll point out a few differences below.

For brevity, I've already removed the PersistentVolume manifest declaration.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pgadmin4-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pgadmin4-dep
  labels:
    app: pgadmin4
spec:
  replicas: 1
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: pgadmin4
  template:
    metadata:
      labels:
        app: pgadmin4
    spec:
      volumes:
        - name: pgadmin4-pv-storage
          persistentVolumeClaim:
            claimName: pgadmin4-pv-claim
      containers:
        - name: pgadmin4
          image: dpage/pgadmin4
          env:
            - name: PGADMIN_DEFAULT_EMAIL
              value: "admin@mydomain.com"
            - name: PGADMIN_DEFAULT_PASSWORD
              value: "P@ssw0rd!"
          ports:
            - containerPort: 80
          volumeMounts:
            - mountPath: "/var/lib/pgadmin/data"
              name: pgadmin4-pv-storage
---
# from pgadmin4-svc.yml
apiVersion: v1
kind: Service
metadata:
  name: pgadmin4-svc
spec:
  selector:
    app: pgadmin4
  type: NodePort
  ports:
    - protocol: TCP
      port: 80
      nodePort: 5050
```

There are a few items that are different as we move to Pulumi because we are using Pulumi for the Azure production (eventually) environment and the operationalization of our stack. We will be using pgAdmin4 (the container, if not the application) to do database backups. The pgAdmin4 container has all of the tooling and settings required to do backups. What we need though is somewhere to put the backups. In this case, we will leverage another feature of **AKS** called azureFile storage provider for **k8s**. This bit of configuration instructs **k8s**, via Azure and **AKS**, to use a storage account file share as a volume in our pod.

```typescript
  name: pgAdminAzureVolumeName, // <-- This is "azure"
    azureFile: {
      secretName: azureStorageSecretName,
      shareName: azureFileShareName,
      readOnly: false
    }
```

Recall that these resources were created in the **AKS** project so we need these values from our other stack configuration.

> Eventually, I expect we will move to a managed [Azure Database for Postgres](https://azure.microsoft.com/en-ca/services/postgresql/) SaaS offering, so all of this may eventually disappear. For now, we'll manage it all ourselves.

```typescript
// Add pgAdmin4 to AKS Cluster
const pgAdminLabels = {...{ app: "pgAdmin4", role: "db"}, ...baseBackEndLabels };

const pgadminServiceName = "pgadmin-svc";
const pgAdminService = new k8s.core.v1.Service(pgadminServiceName, {
    metadata: {
        name: pgadminServiceName,
        labels: pgAdminLabels,
    },
    spec: {
        ports: [{ port: 80, targetPort: 80, protocol: "TCP"}],
        selector: pgAdminLabels,
    },
}, {provider: k8sProvider});

const pgAdminAzureVolumeName = "azure";
const pgAdminDepName = "pgadmin-dep";
const pgAdminDeployment = new k8s.apps.v1.Deployment(pgAdminDepName, {
    metadata: { name: pgAdminDepName },
    spec: {
        selector: { matchLabels: pgAdminLabels },
        replicas: 1,
        revisionHistoryLimit: 2,
        template: {
            metadata: { labels: pgAdminLabels },
            spec: {
                containers: [{
                    name: "pgadmin",
                    image: "dpage/pgadmin4",
                    resources: {
                        requests: {
                            cpu: "100m",
                            memory: "150Mi",
                        },
                        limits: {
                            memory: "200Mi"
                        }
                    },
                    ports: [{ containerPort: 80 }],
                    env: [
                        {name: "PGADMIN_DEFAULT_EMAIL", value: "admin@mydomain.com"},
                        {name: "PGADMIN_DEFAULT_PASSWORD", value: "P@ssw0rd!"},
                        {name: "POSTGRES_USER", value: "admin"},
                        {name: "POSTGRES_PASSWORD", value: "P@ssw0rd!"},
                        {name: "POSTGRES_DB", value: "identity"}
                    ],
                    volumeMounts:[
                        {name: pgAdminAzureVolumeName, mountPath: "/var/lib/pgadmin/azure"}
                    ]
                }],
                volumes: [{
                    name: pgAdminAzureVolumeName,
                    azureFile: {
                        secretName: azureStorageSecretName,
                        shareName: azureFileShareName,
                        readOnly: false
                    }
                }],
            },
        },
    },
}, {provider: k8sProvider});
```

`pulumi up` will put the pgAdmin4 application/images into our **k8s** cluster. With the given configuration, it will be able to connect to the postgres database.

### Moving Seq from Manifest to Pulumi

The final step (for now) of moving all of our infrastructure/backend components into pulumi is the Seq instance. This will be similar to the postgres instance as it also uses a PersistentVolumeClaim to get an azureDisk attached to the VM for saving our log data.

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: seq-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  capacity:
    storage: 3Gi
  hostPath:
    path: /mnt/data/seqv6/
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: seq-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: seq-dep
  labels:
    app: seq
spec:
  replicas: 1
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: seq
  template:
    metadata:
      labels:
        app: seq 
    spec:
      volumes:
        - name: seq-pv-storage
          persistentVolumeClaim:
            claimName: seq-pv-claim
      containers:
      - name: seq 
        image: datalust/seq:preview
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: "/data"
          name: seq-pv-storage
        env:
        - name: ACCEPT_EULA
          value: "Y"
---
# from seq-svc.yml
apiVersion: v1
kind: Service
metadata:
  name: seq-svc
spec:
  selector:
    app: seq
  type: NodePort
  ports:
    - protocol: TCP
      port: 80
      nodePort: 5341
```

There are two notable differences in Pulumi Application code that were not in the manifests.

First of all, we are adding a [side-car container](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/) to this pod now that we are moving to Azure. This means that there are two containers running in this Pod. They are separate images (applications) but they will share the same network space and be able to access each other at the DNS **localhost** with the appropriate port. The side-car container we are adding is a container image called [sqelf](https://hub.docker.com/r/datalust/sqelf) which is a product produced by [datalust.co](https://www.datalust.co) that allows use to ingest log events in the `graylog` message format and send them directly into Seq.

The second change is in the Service description. We need to expose the **sqelf** service on a UDP port so that eventually, **fluentd** will be able to send log event messages, in the **graylog** format, to the **sqelf** container. The **squelf** container then just sends it on to **Seq**. We'll discuss **fluentd** in another article.

```typescript
// Add Seq to AKS Cluster
const seqLabels = {...{ app: "seq", role: "logingestion"}, ...baseBackEndLabels};
const seqPersistentVolumeClaim = new k8s.core.v1.PersistentVolumeClaim("seq-pv-claim",{
    metadata:{ name: "seq-pv-claim"},
    spec: {
        storageClassName: aksStack.getOutput("storageClassName"),
        accessModes: ["ReadWriteOnce"],
        resources: {
            requests: {
                storage: "32Gi"
            }
        }
    }
}, {provider: k8sProvider});

const seqServiceName = "seq-svc";
const seqService = new k8s.core.v1.Service(seqServiceName, {
    metadata: {
        name: seqServiceName,
        labels: seqLabels,
    },
    spec: {
        ports: [
            { name: "http-seq", port: 80, targetPort: 80, protocol: "TCP"},
            { name: "udp-sqelf", port: 12201, protocol: "UDP"}],
        selector: seqLabels,
    },
},{provider: k8sProvider});

const seqDeploymentName = "seq-dep";
const seqDeployment = new k8s.apps.v1.Deployment(seqDeploymentName, {
    metadata: { name: seqDeploymentName },
    spec: {
        selector: { matchLabels: seqLabels },
        replicas: 1,
        revisionHistoryLimit: 2,
        template: {
            metadata: { labels: seqLabels },
            spec: {
                volumes: [{
                    name: "seq-pv-storage",
                    persistentVolumeClaim: {
                        claimName: "seq-pv-claim"
                    }
                }],
                containers: [{
                    name: "seq",
                    image: "datalust/seq:preview",
                    resources: {
                        requests: {
                            cpu: "100m",
                            memory: "500Mi",
                        },
                        limits:{
                            memory: "1000Mi"
                        }
                    },
                    ports: [{ containerPort: 80, protocol: "TCP" }],
                    volumeMounts: [{
                        mountPath: "/data",
                        name: "seq-pv-storage"
                    }],
                    env: [{name: "ACCEPT_EULA", value: "Y"}]
                },
                {
                    name: "sqelf",
                    image: "datalust/sqelf",
                    resources: {
                        requests: {
                            cpu: "100m",
                            memory: "100Mi",
                        },
                    },
                    ports: [{containerPort: 12201, protocol: "UDP"}],
                    env: [
                        {name: "ACCEPT_EULA", value: "Y"},
                        {name: "SEQ_ADDRESS", value: "http://localhost:80"}
                    ]
                }
            ],
            },
        },
    },
}, {provider: k8sProvider});
```

`pulumi up` will get the Seq pod up and running, with 2 containers, in our **k8s** infrastructure.

### Moving IdentityServer4 from Manifest to Pulumi

The final bit of work to get our platform moved from **minikube** to **AKS** is to move our applications. There is nothing terribly special or noteworthy from a container perspective in this mapping. None of these pods need durable storage. The only difference with these pods is that they indicate that they want to use **docker-credentials** secret to access the private ACR.

There is a particularly important difference for our application when it comes to networking and accessing our applications. Our **k8s** has a public IP address and all of our applications will eventually be accessed via a unique DNS entry, not a shared DNS entry with different ports. I imagine you could use the shared DNS/multiple ports approach, but I did not. I don't think it helps human beings understand what they are using or working on to hide the intention behind a port abstraction. So, we will give everything its own URL.

This has consequences on our initial database seed data. Once this is all deployed, we will have to go into pgAdmin4 and run a script to update our configuration. Otherwise, the authentication system won't work. The Admin needs to be able _and allowed_ to access the STS from its hostname location so we'll need to change the STS seed data. We're also going to change the configuration that is stored in the environmental variables which are appsettings.json overrides.

#### STS

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: identity-sts-dep
  labels:
    app: identity-sts
spec:
  replicas: 1
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: identity-sts
  template:
    metadata:
      labels:
        app: identity-sts
    spec:
      containers:
      - name: identity-sts
        image: depthconsulting.azurecr.io/skoruba-identityserver4-sts-identity:latest
        env:
        - name: ASPNETCORE_ENVIRONMENT
          value: "Development"
        - name: SEQ_URL
          value: "http://seq-svc"
        - name: ConnectionStrings__ConfigurationDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: ConnectionStrings__PersistedGrantDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: ConnectionStrings__IdentityDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: AdminConfiguration__IdentityAdminBaseUrl
          value: http://127.0.0.1.xip.io:9000
        - name: ASPNETCORE_URLS
          value: "http://+:80"
        ports:
        - containerPort: 80
      imagePullSecrets:
      - name: docker-credentials
---
# from identity-sts-svc.yml
apiVersion: v1
kind: Service
metadata:
  name: identity-sts-svc
spec:
  selector:
    app: identity-sts
  type: NodePort
  ports:
    - protocol: TCP
      port: 80
      nodePort: 80
```

I'm so glad that Pulumi is a programatic IaC model. One thing I can do here before we get to far along is move my DB connection strings (and the list) into variables and then use them where needed.

```typescript
const dbConnectionString = "Server=postgres-svc; User Id=admin; Database=identity; Port=5432; Password=P@ssw0rd!; SSL Mode=Prefer; Trust Server Certificate=true;";
const dbConnectionStringList = [
    {name: "ConnectionStrings__ConfigurationDbConnection", value: dbConnectionString},
    {name: "ConnectionStrings__PersistedGrantDbConnection", value: dbConnectionString},
    {name: "ConnectionStrings__IdentityDbConnection", value: dbConnectionString},
    {name: "ConnectionStrings__AdminLogDbConnection", value: dbConnectionString},
    {name: "ConnectionStrings__AdminAuditLogDbConnection", value: dbConnectionString}
];
```

Now to code the STS provisioning.

```typescript
// Add Identity STS Service to AKS Cluster
const stsLabels = {...{ app: "identity-sts", role: "authentication"}, ...baseApplicationGroupLabels};
const stsDepName = "identity-sts-dep";
const stsDeployment = new k8s.apps.v1.Deployment(stsDepName, {
    metadata: { 
        name: stsDepName,
        labels: stsLabels
    },
    spec: {
        selector: { matchLabels: {app: "identity-sts"} },
        replicas: 1,
        revisionHistoryLimit: 2,
        template: {
            metadata: { labels: stsLabels },
            spec: {
                containers: [{
                    name: "identity-sts",
                    image: "depthconsulting.azurecr.io/skoruba-identityserver4-sts-identity:latest",
                    resources: {
                        requests: {
                            cpu: "100m",
                            memory: "200Mi",
                        },
                        limits:{
                            memory: "300Mi"
                        }
                    },
                    ports: [{ containerPort: 80, protocol: "TCP" }],
                    env: [
                        {name: "ASPNETCORE_ENVIRONMENT", value: "Development"},
                        {name: "SEQ_URL", value: "http://seq-svc:5341"},
                        {name: "AdminConfiguration__IdentityAdminBaseUrl", value: "https://auth-admin.codingwithdave.xyz"},
                        {name: "ASPNETCORE_URLS", value: "http://+:80"}
                    ].concat(dbConnectionStringList)
                }],
                imagePullSecrets: [{name: acrSecretName }]
            },
        },
    },
}, {provider: k8sProvider});

const stsServiceName = "identity-sts-svc";
const stsService = new k8s.core.v1.Service(stsServiceName, {
    metadata: {
        name: stsServiceName,
        labels: {app: "identity-sts"},
    },
    spec: {
        ports: [
            { name: "http", port: 80, targetPort: 80, protocol: "TCP"}
        ],
        selector: {app: "identity-sts"},
    },
},{provider: k8sProvider});
```

#### IdentityServer4 Admin

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: identity-admin-dep
  labels:
    app: identity-admin
spec:
  replicas: 1
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: identity-admin
  template:
    metadata:
      labels:
        app: identity-admin
    spec:
      containers:
      - name: identity-admin
        image: depthconsulting.azurecr.io/skoruba-identityserver4-admin:latest
        env:
        - name: ASPNETCORE_ENVIRONMENT
          value: "Development"
        - name: SEQ_URL
          value: "http://seq-svc"
        - name: ConnectionStrings__ConfigurationDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: ConnectionStrings__PersistedGrantDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: ConnectionStrings__IdentityDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: ConnectionStrings__AdminLogDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: ConnectionStrings__AdminAuditLogDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: AdminConfiguration__IdentityServerBaseUrl
          value: http://127.0.0.1.xip.io
        - name: AdminConfiguration__IdentityAdminRedirectUri
          value: http://127.0.0.1.xip.io:9000/signin-oidc
        - name: ASPNETCORE_URLS
          value: "http://+:80"
        ports:
        - containerPort: 80
      imagePullSecrets:
      - name: docker-credentials
---
# from identity-admin-svc.yml
apiVersion: v1
kind: Service
metadata:
  name: identity-admin-svc
spec:
  selector:
    app: identity-admin
  type: NodePort
  ports:
    - protocol: TCP
      port: 80
      nodePort: 9000
```

```typescript
// Add Auth Admin Application to AKS Cluster
const adminLabels = {...{ app: "identity-admin", role: "authentication"}, ...baseApplicationGroupLabels};
const adminDepName = "identity-admin-dep";
const adminDeployment = new k8s.apps.v1.Deployment(adminDepName, {
    metadata: {
        name: adminDepName,
        labels: adminLabels
    },
    spec: {
        selector: { matchLabels: {app: "identity-admin"} },
        replicas: 1,
        revisionHistoryLimit: 2,
        template: {
            metadata: { labels: adminLabels },
            spec: {
                containers: [{
                    name: "identity-admin",
                    image: "depthconsulting.azurecr.io/skoruba-identityserver4-admin:latest",
                    resources: {
                        requests: {
                            cpu: "100m",
                            memory: "200Mi",
                        },
                        limits:{
                            memory: "300Mi"
                        }
                    },
                    ports: [{ containerPort: 80, protocol: "TCP" }],
                    env: [
                        {name: "ASPNETCORE_ENVIRONMENT", value: "Development"},
                        {name: "SEQ_URL", value: "http://seq-svc:5341"},
                        {name: "AdminConfiguration__IdentityServerBaseUrl", value: "https://auth.codingwithdave.xyz"},
                        {name: "AdminConfiguration__IdentityAdminRedirectUri", value: "https://auth-admin.codingwithdave.xyz/signin-oidc"},
                        {name: "AdminConfiguration__RequireHttpsMetadata", value: "true"},
                        {name: "ASPNETCORE_URLS", value: "http://+:80"}
                    ].concat(dbConnectionStringList)
                }],
                imagePullSecrets: [{name: acrSecretName }]
            },
        },
    },
}, {provider: k8sProvider});

const adminServiceName = "identity-admin-svc";
const adminService = new k8s.core.v1.Service(adminServiceName, {
    metadata: {
        name: adminServiceName,
        labels: {app: "identity-admin"},
    },
    spec: {
        ports: [{ port: 80, targetPort: 80, protocol: "TCP"}],
        selector: {app: "identity-admin"},
    },
},{provider: k8sProvider});
```

#### IdentityServer4 Admin API

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: identity-admin-api-dep
  labels:
    app: identity-admin-api
spec:
  replicas: 1
  revisionHistoryLimit: 2
  selector:
    matchLabels:
      app: identity-admin-api
  template:
    metadata:
      labels:
        app: identity-admin-api
    spec:
      containers:
      - name: identity-admin-api
        image: depthconsulting.azurecr.io/skoruba-identityserver4-admin-api:latest
        env:
        - name: ASPNETCORE_ENVIRONMENT
          value: "Development"
        - name: SEQ_URL
          value: "http://seq-svc"
        - name: ConnectionStrings__ConfigurationDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: ConnectionStrings__PersistedGrantDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: ConnectionStrings__IdentityDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: ConnectionStrings__AdminLogDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: ConnectionStrings__AdminAuditLogDbConnection
          value: "User ID=admin;Password=P@ssw0rd!;Host=postgres-svc;Port=5432;Database=identity;Pooling=true;"
        - name: AdminApiConfiguration__IdentityServerBaseUrl
          value: http://127.0.0.1.xip.io
        - name: AdminApiConfiguration__ApiBaseUrl
          value: http://127.0.0.1.xip.io:5000
        - name: ASPNETCORE_URLS
          value: "http://+:80"
        ports:
        - containerPort: 80
      imagePullSecrets:
      - name: docker-credentials
---
# from identity-adminapi-svc.yml
apiVersion: v1
kind: Service
metadata:
  name:  identity-admin-api-svc
spec:
  selector:
    app:  identity-admin-api
  type: NodePort
  ports:
    - protocol: TCP
      port: 80
      nodePort: 5000
```

```typescript
// Add Auth Admin API to AKS Cluster
const adminApiLabels = {...{ app: "identity-admin-api", role: "authentication"}, ...baseApplicationGroupLabels};
const adminApiDepName = "identity-admin-api-dep";
const adminApiDeployment = new k8s.apps.v1.Deployment(adminApiDepName, {
    metadata: { 
      name: adminApiDepName,
      labels: adminApiLabels
    },
    spec: {
        selector: { matchLabels: {app: "identity-admin-api"} },
        replicas: 1,
        revisionHistoryLimit: 2,
        template: {
            metadata: { labels: adminApiLabels },
            spec: {
                containers: [{
                    name: "identity-admin-api",
                    image: "depthconsulting.azurecr.io/skoruba-identityserver4-admin-api:latest",
                    resources: {
                        requests: {
                            cpu: "100m",
                            memory: "200Mi",
                        },
                        limits:{
                            memory: "300Mi"
                        }
                    },
                    ports: [{ containerPort: 80, protocol: "TCP" }],
                    env: [
                        {name: "ASPNETCORE_ENVIRONMENT", value: "Development"},
                        {name: "SEQ_URL", value: "http://seq-svc:5341"},
                        {name: "AdminApiConfiguration__IdentityServerBaseUrl", value: "https://auth.codingwithdave.xyz"},
                        {name: "AdminApiConfiguration__ApiBaseUrl", value: "https://auth-admin-api.codingwithdave.xyz"},
                        {name: "ASPNETCORE_URLS", value: "http://+:80"}
                    ].concat(dbConnectionStringList)
                }],
                imagePullSecrets: [{name: acrSecretName }]
            },
        },
    },
}, {provider: k8sProvider});

const adminApiServiceName = "identity-admin-api-svc";
const adminApiService = new k8s.core.v1.Service(adminApiServiceName, {
    metadata: {
        name: adminApiServiceName,
        labels: {app: "identity-admin-api"},
    },
    spec: {
        ports: [{ port: 80, targetPort: 80, protocol: "TCP"}],
        selector: {app: "identity-admin-api"},
    },
},{provider: k8sProvider});
```

`pulumi up` will push all of your applications up into **AKS**.

### Verify all the Pods are Up and Running

With our last `pulumi up` we should have all of our **AKS** infrastructure up and hosting our **k8s** cluster, and we should have all of our applications/services/resources from our second pulumi stack in the **k8s** cluster. We should now be able to go into a one of our tools and verify that the apps are running.

If you used the pulumi application in our previous post, you should have a **az aks get-credentials ...** in your pulumi output for that stack. It should look something like this:

```powershell
az aks get-credentials --resource-group rg_identity_dev_zwus_aks `
--name aksclusterfbfa950e --context "MyProject.Identity"
```

You can run that command, with your specific values, and have the **azure-cli** append this **k8s** context details into your kubeConfig file. Once that is done, we can type `octant` on the command line and look at our pods.

Using **octant** (v0.12.1), we can see that all of our pods are present in the cluster.

<img src="/images/dwhite/octant-azure-pods-running.png" alt="Pods running in Azure" height="250px">

We will click into the **pgAdmin4** pod as an example in the article, but you should eventually click into all of the pods to ensure they are functioning.

Looking at the pgAdmin4 pod, we can see that it is initialized and ready! If we go down a bit further, we'll see the port forward functionality of **octant** waiting for us to press the button.

<img src="/images/dwhite/octant-azure-pgadmin-portforward.png" alt="PortForward function in Octant" height="250px">

Once we press the button, we'll see that we now have an option to navigate to the port-forward URL.

<img src="/images/dwhite/octant-azure-pgadmin-portforward-started.png" alt="PortForward to pgAdmin4 started" height="100px">

When we click on that link, you'll see the pgAdmin4 log in screen and once you log in, you should be able to create a server entry in our list to our postgres pod. The **k8s** network DNS name for our postgres pod should be **postgres-svc** from our Service resource. Once the entry is connected, we should be able to see our postgres database!

<img src="/images/dwhite/octant-azure-pgadmin-running.png" alt="pgAdmin4 running" height="250px">

You should work your way through all of the pods. They should all be up and running. The whole authentication/authorization system won't be working yet. We'll wait until the next article to fix that up and test it out.

#### Problems

When you have problems in **k8s**, you have to start looking in two places. First, you have to look in the logs. **octant** has a nice screen for looking at the log files directly on a pod. Remember, we don't have log ingestion and tooling setup for the **k8s** cluster yet, so we have to go look in the pods themselves. Here you can see pgAdmin4 running just fine, but if it wasn't working, you'll find clues as to why here.

<img src="/images/dwhite/octant-azure-pgadmin-log.png" alt="pgAdmin4 logs in the pod" height="250px">

Once we have all of our log ingestion infrastructure in place, we will be able to go to Seq to look log entries across the cluster, but you should always be ready to go look directly in the pods for the log entries.

And the other place you will probably want to inspect is the running pod itself. You can use the **terminal** tab in **octant** to look at various settings in your pod.

<img src="/images/dwhite/octant-azure-pgadmin-terminal.png" alt="pgAdmin4 terminal window" height="250px">

### Not Quite Done Yet

This article is going to end in a bit of a "not quite working as I'd like" state. All of the pods are up and running, but our IdentityServer4 needs some configuration changes in order to work. And in order to do that, we need to be able to access our **k8s** publicly, give it a DNS entry (hostname), and then configure our IdentityServer4 system to allow those hostnames to interact with the STS.

Our next stop will be adding an Ingress Controller to our **k8s** cluster and getting all of these services publicly available.

**Next up:**
[Making Your Kubernetes Cluster Publicly Accessible](/kubernetes/kubernetes-my-journey-part-8)

<script>
// View an image
const gallery = new Viewer(document.getElementById('mainPostContent', {
    "navbar": false,
    "toolbar": false
}));
</script>