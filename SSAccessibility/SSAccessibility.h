//
//  SSAccessibility.h
//  SSAccessibility
//
//  Created by Jonathan Hersh on 3/31/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SSAccessibility : NSObject

/**
 * Speak some text with VoiceOver.
 * This is a shortcut for UIAccessibilityPostNotification.
 */
+ (void) speakWithVoiceOver:(NSString *)string;

/**
 * Return YES if external audio may be playing 
 * (a phone call, or the user playing music, or various system audio events)
 *
 * WARNING: As of iOS 7, this seems to always return YES.
 */
+ (BOOL) otherAudioMayBePlaying;

@end
