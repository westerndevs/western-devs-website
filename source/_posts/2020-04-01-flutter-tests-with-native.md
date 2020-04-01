---
layout: post
title: Flutter unit testing with native channels
authorId: simon_timms
date: 2020-04-01 10:00
originalurl: 'https://blog.simontimms.com/2020/04/01/2020-04-01-flutter-tests-with-native/'
---

Today I was digging through some unit tests in our flutter project that seemed to be failing on my machine but not necessarily in other places like our build pipeline. The problem was that we had some calls to async methods which were not being awaited properly. I fixed those up and they uncovered a bunch of more serious problems in our tests. We were calling out to validate a phone number with libphonenumber and now we were actually awaiting the call properly we saw this error

<!-- more -->

```bash
[master ≡ +0 ~2 -0 !]> flutter test
00:03 +27 -1: test\unit\providers\create_account_provider_test.dart: Real mobile number - is valid [E]
  MissingPluginException(No implementation found for method isValidPhoneNumber on channel codeheadlabs.com/libphonenumber)
  package:blah/providers/create_account_provider.dart 101:9  CreateAccountProvider.setMobileNumber

00:03 +28 -2: test\unit\providers\create_account_provider_test.dart: Valid state if properties are valid [E]
  MissingPluginException(No implementation found for method isValidPhoneNumber on channel codeheadlabs.com/libphonenumber)
  package:blah/providers/create_account_provider.dart 101:9  CreateAccountProvider.setMobileNumber
```

As it turns out libphonenumber is actually a native implementation wrapped up with flutter. To communicate with this native code isn't possible in a test environment so it needs to be mocked. This can be done by mocking the channel. 

In the setUp() for the unit tests I added a call to setMockMethodCallHandler like so 

```dart
const _channel = const MethodChannel('codeheadlabs.com/libphonenumber');
setUp(() async {
_channel.setMockMethodCallHandler((MethodCall methodCall) async {
    return true;
    });  
});

tearDown((){
_channel.setMockMethodCallHandler(null);
});
```

With this call in place I was able to run the test without issue. 