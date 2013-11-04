//
//  SSSpeechSynthesizer.m
//  SSAccessibility
//
//  Created by Jonathan Hersh on 9/24/13.
//  Copyright (c) 2013 Splinesoft. All rights reserved.
//

#import "SSAccessibility.h"
#import "SSSpeechSynthesizer.h"
#import <MSWeakTimer.h>

@interface SSSpeechSynthesizer ()

@property (nonatomic, strong) MSWeakTimer *speakResetTimer;
@property (nonatomic, strong) NSMutableArray *speechQueue;

- (void) voiceOverStatusChanged;
- (void) didFinishAnnouncing;
- (void) maybeDequeueLine;

@end

@implementation SSSpeechSynthesizer

- (id)init {
    if( ( self = [super init] ) ) {
        _speechQueue = [NSMutableArray new];
        _mayBeSpeaking = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(voiceOverStatusChanged)
                                                     name:UIAccessibilityVoiceOverStatusChanged
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didFinishAnnouncing)
                                                     name:UIAccessibilityAnnouncementDidFinishNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [_speakResetTimer invalidate];
    [_speechQueue removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - speech control

- (void)voiceOverStatusChanged {
    if( UIAccessibilityIsVoiceOverRunning() )
        [self continueSpeaking];
    else
        [self stopSpeaking];
}

- (void)stopSpeaking {
    [_speakResetTimer invalidate];
    [_speechQueue removeAllObjects];
    _mayBeSpeaking = NO;
}

- (void)continueSpeaking {
    [self maybeDequeueLine];
}

#pragma mark - Speaking

- (void)enqueueLineForSpeaking:(NSString *)line {
    if( [line length] == 0 )
        return;
    
    [_speechQueue addObject:line];
    
    [self maybeDequeueLine];
}

- (void)maybeDequeueLine {
    if( [_speechQueue count] == 0 )
        return;
    
    if( !UIAccessibilityIsVoiceOverRunning() )
        return;
    
    if ( !_mayBeSpeaking || ![SSAccessibility otherAudioMayBePlaying] ) {
        _mayBeSpeaking = YES;
        
        if (_speakResetTimer)
            [_speakResetTimer invalidate];
        
        _speakResetTimer = [MSWeakTimer scheduledTimerWithTimeInterval:10.0f
                                                                target:self
                                                              selector:@selector(didFinishAnnouncing)
                                                              userInfo:nil
                                                               repeats:NO
                                                         dispatchQueue:dispatch_get_main_queue()];
        
        [SSAccessibility speakWithVoiceOver:[_speechQueue[0] copy]];
        
        [_speechQueue removeObjectAtIndex:0];
    }
}

#pragma mark - VoiceOver events

- (void)didFinishAnnouncing {
    _mayBeSpeaking = NO;
    
    if (_speakResetTimer)
        [_speakResetTimer invalidate];
    
    [self maybeDequeueLine];
}

@end
