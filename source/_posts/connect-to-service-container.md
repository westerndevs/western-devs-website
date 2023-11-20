---
title:  Connect to a Service Container in Github Actions
authorId: simon_timms
date: 2023-11-20
originalurl: https://blog.simontimms.com/2023/11/20/connect-to-service-container
mode: public
---



Increasingly there is a need to run containers during a github action build to run realistic tests. In my specific scenario I had a database integration test that I wanted to run against a postgres database with our latest database migrations applied.

We run our builds inside a multi-stage docker build so we actually need to have a build container communicate with the database container during the build phase. This is easy enough in the run phase but in the build phase there is just a flag you can pass to the build called `network` which takes an argument but the arguments it can take don't appear to be documented anywhere. After significant trial and error I found that the argument it takes that we want is `host`. This will build the container using the host networking. As we surfaced the ports for postgres in our workflow file like so 
```yml
postgres:
    image: postgres:15.3
    ports:
        - 5432:5432
    env:
        POSTGRES_DB: default
        POSTGRES_USER: webapp_user
        POSTGRES_PASSWORD: password
    options: >-
        --health-cmd pg_isready
        --health-interval 10s
        --health-timeout 5s
        --health-retries 5
```

We are able to access the database from the build context with `127.0.0.1`. So we can pass in a variable to our container build 
```dockerfile
docker build --network=host . --tag ${{ env.DOCKER_REGISTRY_NAME }}/${{ env.DOCKER_IMAGE_NAME }}:${{ github.run_number }} --build-arg 'DATABASE_CONNECTION_STRING=${{ env.DATABASE_CONNECTION_STRING }}'
```

With all this in place the tests run nicely in the container during the build. Phew. 