# SSAccessibility

[![Build Status](https://travis-ci.org/splinesoft/SSAccessibility.png?branch=master)](https://travis-ci.org/splinesoft/SSAccessibility)

iOS Accessibility helpers.

`SSAccessibility` powers a VoiceOver speech queue in my app [MUDRammer - A Modern MUD Client for iPhone and iPad](https://itunes.apple.com/us/app/mudrammer-a-modern-mud-client/id597157072?mt=8).

## Install

Install with [CocoaPods](http://cocoapods.org).

```
pod 'SSAccessibility', :git => 'https://github.com/splinesoft/SSAccessibility.git'
```

## SSSpeechSynthesizer


SSSpeechSynthesizer manages a queue of lines of text, speaking one at a time with VoiceOver, then speaking the next line when speaking finishes.

The user can interrupt speech by tapping any element on screen that is announced by VoiceOver.

### Why not use iOS 7's `AVSpeechSynthesizer`?

You should if you can. `AVSpeechSynthesizer` is good for speaking long blobs of text. But there are reasons to prefer VoiceOver:

* `AVSpeechSynthesizer` requires iOS 7
* `AVSpeechSynthesizer` doesn't always pause or stop speaking when asked
* The user can set her preferred VoiceOver speaking rate in Settings.app, but there is no programmatic API access to that default speech rate -- say, for use in your `AVSpeechSynthesizer`
* `AVSpeechSynthesizer` doesn't stop speaking (only ducks) when a user with VoiceOver taps an element
* The user can immediately (and intentionally or unintentionally) interrupt VoiceOver by tapping any element on screen

## SSAccessibility

Misc Accessibility helpers. See `SSAccessibility.h`.

```objc
// Speak some text with VoiceOver. This is a shortcut for UIAccessibilityPostNotification.
[SSAccessibility speakWithVoiceOver:@"Hello world!"];
```

## Thanks!

`SSAccessibility` is a [@jhersh](https://github.com/jhersh) production -- ([electronic mail](mailto:jon@her.sh) | [@jhersh](https://twitter.com/jhersh))