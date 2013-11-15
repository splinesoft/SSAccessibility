//
//  SSAccessibility.m
//  SSAccessibility
//
//  Created by Jonathan Hersh on 3/31/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSAccessibility.h"

@implementation SSAccessibility

+ (void) speakWithVoiceOver:(NSString *)string {
    if ([string length] == 0)
        return;
    
    if (!UIAccessibilityIsVoiceOverRunning())
        return;
    
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, string);
}

+ (BOOL) otherAudioMayBePlaying {
    UInt32 otherAudioIsPlaying;
    UInt32 propertySize = sizeof (otherAudioIsPlaying);
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying,
                            &propertySize,
                            &otherAudioIsPlaying);
#pragma clang diagnostic pop
    
    if (otherAudioIsPlaying)
    return YES;
    
    return NO;
}

@end
