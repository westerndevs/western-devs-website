---
title:  Parsing Vue Router Path Parameters
authorId: simon_timms
date: 2022-02-18
originalurl: https://blog.simontimms.com/2022/02/18/parsing-vue-router-parameters
mode: public
---



In the vue router you can set up path parameters that are bound into the rendered component. For instance you might have a route like this:

```javascript
{
    path: '/reports/:reportId/:reportName/:favorite',
    name: 'Reports',
    component: ReportView,
    props: true
}
```

This will bind the parameters `reportId`, `reportName` and `favorite` on the component. However when you drop into that component and look at the values passed in you will see that they are strings. Of course that makes sense, the router doesn't really know if the things you pass in are strings or something else. Consider the route `/reports/17/awesome report/false`. Here `reportId` and `favorite` are going to be strings. 

You can work around that by giving props in the router a function rather than just a boolean. 

```javascript
{
    path: '/reports/:reportId/:reportName/:favorite',
    name: 'Reports',
    component: ReportView,
    props: (route) => ({
      ...route.params,
      reportId: parseInt(route.params.reportId),
      favorite: route.params.favorite === 'true',
    })
  }
```