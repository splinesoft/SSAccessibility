//
//  SSSpeechSynthesizer.h
//  SSAccessibility
//
//  Created by Jonathan Hersh on 9/24/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

/**
 * SSSpeechSynthesizer manages a queue of lines of text, speaking one at a time
 * with VoiceOver, then speaking the next line when speaking finishes.
 *
 * The user can interrupt speech by tapping any element on screen that is announced by VoiceOver.
 * If interrupted, SSSpeechSynthesizer will start speaking again 10 seconds after it last started speaking.
 *
 * Why not use iOS 7's AVSpeechSynthesizer?
 * You should if you can. AVSpeechSynthesizer is good for speaking long blobs of text.
 * But there are reasons to prefer VoiceOver:
 * * AVSpeechSynthesizer requires iOS 7
 * * AVSpeechSynthesizer doesn't always pause or stop speaking when asked
 * * AVSpeechSynthesizer supports a user-specified speaking rate for each line of text. VoiceOver's
 *   speaking rate is defined system-wide
 * `AVSpeechSynthesizer` doesn't stop speaking (only ducks) when a user with VoiceOver taps an element
 * * There is no API to programmatically access the system preferred VoiceOver speaking rate
 * * The user can immediately (and intentionally or unintentionally) interrupt
 *   VoiceOver by tapping any element on screen
 */

#import <Foundation/Foundation.h>

@protocol SSSpeechSynthesizerDelegate;

@interface SSSpeechSynthesizer : NSObject

/*
 * Returns a best guess as to whether the synthesizer is currently speaking something with VoiceOver.
 * There is no guaranteed programmatic access to VoiceOver's speaking status.
 * THIS MAY BE INACCURATE.
 */
@property (nonatomic, assign, readonly) BOOL mayBeSpeaking;

/**
 * Stops speaking at the end of the current announcement and clears the text queue.
 */
- (void) stopSpeaking;

/**
 * Resumes speaking.
 * Useful if speaking was interrupted, perhaps when the user touched a VoiceOver element.
 */
- (void) continueSpeaking;

/**
 * Add a new line to the end of the speaking queue.
 * Will not interrupt speaking.
 */
- (void) enqueueLineForSpeaking:(NSString *)line;

@end
