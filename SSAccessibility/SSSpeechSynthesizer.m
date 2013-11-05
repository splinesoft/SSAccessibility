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
@property (nonatomic, copy) NSString *lastSpokenText;

- (void) voiceOverStatusChanged;
- (void) voiceOverDidFinishAnnouncing:(NSNotification *)note;
- (void) voiceOverMayHaveTimedOut;
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
                                                 selector:@selector(voiceOverDidFinishAnnouncing:)
                                                     name:UIAccessibilityAnnouncementDidFinishNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc {
    _delegate = nil;
    [_speakResetTimer invalidate];
    [_speechQueue removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - speech control

- (void)voiceOverStatusChanged {
    if( UIAccessibilityIsVoiceOverRunning() ) {
        [self continueSpeaking];
    } else {
        [self stopSpeaking];
    }
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
    if( [line length] == 0 ) {
        return;
    }
    
    [_speechQueue addObject:line];
    
    [self maybeDequeueLine];
}

- (void)maybeDequeueLine {
    if( [_speechQueue count] == 0 ) {
        return;
    }
    
    if( !UIAccessibilityIsVoiceOverRunning() ) {
        return;
    }
    
    if ( !_mayBeSpeaking || ![SSAccessibility otherAudioMayBePlaying] ) {
        _mayBeSpeaking = YES;
        
        if (_speakResetTimer) {
            [_speakResetTimer invalidate];
        }
        
        self.lastSpokenText = _speechQueue[0];
        
        if (_timeoutDelay > 0) {
            _speakResetTimer = [MSWeakTimer scheduledTimerWithTimeInterval:_timeoutDelay
                                                                    target:self
                                                                  selector:@selector(voiceOverMayHaveTimedOut)
                                                                  userInfo:nil
                                                                   repeats:NO
                                                             dispatchQueue:dispatch_get_main_queue()];
        }
        
        if ( [_delegate respondsToSelector:@selector(synthesizer:willBeginSpeakingLine:)] ) {
            [_delegate synthesizer:self
             willBeginSpeakingLine:_lastSpokenText];
        }
        
        [SSAccessibility speakWithVoiceOver:_lastSpokenText];
        
        [_speechQueue removeObjectAtIndex:0];
    }
}

#pragma mark - VoiceOver events

- (void)voiceOverDidFinishAnnouncing:(NSNotification *)note {
    _mayBeSpeaking = NO;
    
    if (_speakResetTimer) {
        [_speakResetTimer invalidate];
    }
    
    NSDictionary *userInfo = [note userInfo];
    
    // We speak the next line only if VoiceOver successfully spoke our last line.
    if ( userInfo
         && _lastSpokenText
         && [userInfo[UIAccessibilityAnnouncementKeyStringValue] isEqualToString:_lastSpokenText] ) {
        
        if ( [userInfo[UIAccessibilityAnnouncementKeyWasSuccessful] boolValue] ) {
            [self maybeDequeueLine];
        } else {
            // the system does not always call this observer with
            // UIAccessibilityAnnouncementKeyWasSuccessful == NO :(
            _lastSpokenText = nil;
        }
    }
}

- (void)voiceOverMayHaveTimedOut {
    [self stopSpeaking];
}

@end
