---
layout: post
title: Angular Testing Patterns - Leverage Observable
tags:
  - Angular
  - Testing
featureImage: src/angular.png
categories:
  - Development 
authorId: simon_timms
date: 2018-02-21 14:38:30 
---

One of the most challenging parts of testing is finding seams to reduce the scope of tests. Doing so is important because it make your tests smaller and cleaner which makes them more resilient to changes in the rest of your code base. Testing isn't helping you if every minor change breaks dozens of interconnected tests. Angular's heavy use of Observable provides us a great seam. 

<!-- more -->
This post is part two of a series on angular testing. You can check out the other posts here:

1. [Keep the number of test bed tests to a minimum](/Development/angular-testing-1/). 
2. Leverage `Observable` as a testing seam (this post)
3. Leverage monkey patching as a testing seam
4. No matter what anybody says e2e tests still need sleeps

Reactive programming is a really nice paradigm which extend the Promise or Task patterns that have become quite popular over the last decade. Instead of returning a single value upon completion as Promises do an observable allows subscriptions which are handlers executed every time a value is returned from the observable. 

I have seen a lot of people who ignore the complexity of observables by simply converting to a promise using `toPromise` but this ignores some of the really cool things you can do with promises. For instances if I have a component that requires talking to multiple HTTP endpoints I'll [zip](http://reactivex.io/documentation/operators/zip.html) the responses together so that the rendering doesn't happen until all the requests are complete. There are a ton of other cool patters you can use if you stick with observables. 

Anyway, I'm not currently here to sell you on RxJS (it _is_ awesome) but tell you how you can use observables to act as a good seam to limit the scope of your tests. 

Let's look at a snippet of a component that makes use of observables and see how to shim in tests. 

```typescript
constructor(private vendorService: VendorService, 
            private deviceViewService: DeviceViewService, 
            private originsService: OriginsService){

}

ngOnInit() {
    this.vendorService.get().subscribe((v: Vendor[]) => this.vendors = v);

    this.deviceViewService.getDevices().subscribe(devices => {
      this.devices = devices;
      activateDevices();
    });

    let originsObservable = this.originsService.getOrigins();
    let destinationsObservable = this.originsService.getDestinations();
    Observable.zip(originsObservable, destinationsObservable, (origins: Origin[], destinations: Destination[])=>[origins,destinations])
        .subscribe((result)=>{
            this.setupOriginsAndDestinations(result);
        });
  }

```

Here we have 4 observables which complete in various ways. The first, `vendorService.get()`, simply assigns vendors to an existing variable. The devices observable does the same but also calls a function and, finally, the last two observables are synchronized via a zip operator. It looks like a lot is going on here but we can isolate things to test easily. 

First up we want to test to make sure that whatever is returned by the vendor service is properly assigned to the vendors collection. We can us a combination of mocks and observables to focus just on the vendor service like so 
(I'm using [ts-mockito](https://github.com/NagRock/ts-mockito)'s mocking syntax here):

```javascript
describe('Demo Component', () =>
{
    it('should set vendors', () => {
        //arrange
        let mockVendorService = mock(VendorService);
        let vendors = [{'id': 1, name: 'Vendor ABC'}];
        when(mockVendorService.get()).thenReturn(Observable.from([vendors]));
        let mockDeviceViewService = mock(DeviceViewService);
        when(mockDeviceViewService.getDevices()).thenReturn(Observable.from([]));
        let mockOriginsService = mock(OriginsService);
        when(mockOriginsService.getOrigins()).thenReturn(Observable.from([]));
        when(mockOriginsService.getDestinations()).thenReturn(Observable.from([]));
        let sut = new DemoComponent(instance(mockVendorService), instance(mockDeviceService), instance(mockOriginsService));

        //act
        sut.ngOnInit();

        //assert
        expect(sut.vendors).to.equal(vendors);
    });
});

```

As you can see we set up the mocks to return either an `Observable` with a single result to test the code or with an empty result to never trigger the subscriptions to that observable. So even though the ngOnInit is quite complex the testing doesn't have to be. 

Let's look at one more example for the zip case

```javascript
it('origins and destinations being complete should trigger setup', () => {
        //arrange
        let mockVendorService = mock(VendorService);
        when(mockVendorService.get()).thenReturn(Observable.from([]));
        let mockDeviceViewService = mock(DeviceViewService);
        when(mockDeviceViewService.getDevices()).thenReturn(Observable.from([]));
        let mockOriginsService = mock(OriginsService);
        let origins = [{'id': 1, name: 'Origin ABC'}];
        when(mockOriginsService.getOrigins()).thenReturn(Observable.from([origins]));
        let destinations = [{'id': 1, name: 'Destination ABC'}];
        when(mockOriginsService.getDestinations()).thenReturn(Observable.from([destinations]));
        let sut = new DemoComponent(instance(mockVendorService), instance(mockDeviceService), instance(mockOriginsService));

        let didWork = false;
        sut.setupOriginsAndDestinations = (passedOrigins, passedDestinations) => {
            didWork = passedOrigins === origins && passedDestinations === destinations;
        }

        //act
        sut.ngOnInit();

        //assert
        expect(didWork).to.be.true;
    });
```

You might also have equivalent tests to ensure that just completing one or the other of `getOrigins` and `getDestinations` doesn't cause the setup to be fired. 

The crux of this post is that observables provide for a nice place to hook into tests because you can use them to isolate large chunks of subscription code or exercise that code with arbitrary values. The more seams you have the easier testing becomes.

I already gave away a bit of the third post in this series when I overrode the setup method in the last example: this is called monkey patching and it is slick beans for isolating code to test. 