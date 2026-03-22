---
title:  RavenDB on Kubernetes
authorId: simon_timms
date: 2024-11-14
originalurl: https://blog.simontimms.com/2024/11/14/ravendb-on-k8s
mode: public
---



I needed to get Particular Service Control up and running on our k8s cluster this week. Part of that is to get an instance of RavenDB running in the cluster and this actually caused me a bit of trouble. I kept running into problems where RavenDB would start up but then report that it couuld not access the data directory. What was up?

I tried overriding the entry point for the container and attaching to it to see what was going on but I couldn't see anything wrong. I was able to write to the directory without issue. Eventually I stumbled on a note in the [RavenDB documentation](https://ravendb.net/docs/article-page/6.0/csharp/migration/server/docker) which mentioned a change in the 6.x version of RavenDB which meant that Raven no longer ran as root inside the container. 

K8S has the ability to change the ownership of the volume to the user that the container is running as. This is done by setting the `fsGroup` property in the pod spec. In this case Raven runs as UID 999. So I updated my tanka spec to include the `fsGroup` property and the problem was solved. 

```
...
deployment: deployment.new($._config.containers.ravendb.name) {
      metadata+: {
        namespace: 'wigglepiggle-' + $._config.environment,
        labels: {
          app: $._config.containers.ravendb.name,
        },
      },
      spec+: {
        replicas: 1,
        selector: {
          matchLabels: $._config.labels,
        },
        template: {
          metadata+: {
            labels: $._config.labels,
          },
          spec+: {
            securityContext: {
              fsGroup: 999,
              fsGroupChangePolicy: 'OnRootMismatch',
            },
            containers: [
              {
                name: $._config.containers.ravendb.name,
                image: $._config.containers.ravendb.image,
                ports: [{ containerPort: 8080 }, { containerPort: 38888 }],
                volumeMounts: [
                  {
                    name: 'data',
                    mountPath: '/var/lib/ravendb/data',
                  },
                ],
                env: [
                  {
                    name: 'RAVEN_Setup_Mode',
                    value: 'None',
                  },
                  {
                    name: 'RAVEN_License_Eula_Accepted',
                    value: 'true',
                  },
                  {
                    name: 'RAVEN_ARGS',
                    value: '--log-to-console',
                  },
                  {
                    name: 'RAVEN_Security_UnsecuredAccessAllowed',
                    value: 'PrivateNetwork',
                  },
                ],
              },
            ],
            volumes: [
              {
                name: 'data',
                persistentVolumeClaim: {
                  claimName: $._config.containers.ravendb.name,
                },
              },
            ],
          },
        },
      },
    },
...
```

This generated yml like 

```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: service-control-ravendb
  name: service-control-ravendb
  namespace: wigglepiggle-dev
spec:
  replicas: 1
  selector:
    matchLabels:
      app: service-control
      environment: dev
  template:
    metadata:
      labels:
        app: service-control
        environment: dev
    spec:
      containers:
      - env:
        - name: RAVEN_Setup_Mode
          value: None
        - name: RAVEN_License_Eula_Accepted
          value: "true"
        - name: RAVEN_ARGS
          value: --log-to-console
        - name: RAVEN_Security_UnsecuredAccessAllowed
          value: PrivateNetwork
        image: ravendb/ravendb:6.0-latest
        name: service-control-ravendb
        ports:
        - containerPort: 8080
        - containerPort: 38888
        volumeMounts:
        - mountPath: /var/lib/ravendb/data
          name: data
      securityContext:
        fsGroup: 999
        fsGroupChangePolicy: OnRootMismatch
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: service-control-ravendb
```
