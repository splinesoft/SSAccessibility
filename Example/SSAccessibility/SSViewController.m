//
//  SSViewController.m
//  SSAccessibility
//
//  Created by Jonathan Hersh on 1/4/14.
//  Copyright (c) 2014 Splinesoft. All rights reserved.
//

#import "SSViewController.h"
#import <SSSpeechSynthesizer.h>

NSString * const kNormalTitle = @"VoiceOver Synthesizer";

@interface SSViewController () <UITextViewDelegate, SSSpeechSynthesizerDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) SSSpeechSynthesizer *synthesizer;

- (void) voiceOverStatusChanged;
- (void) flashTitle:(NSString *)title;
- (void) enqueueText:(UIBarButtonItem *)sender;

@end

@implementation SSViewController

- (instancetype) init {
    if ((self = [super init])) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = kNormalTitle;
        
        _synthesizer = [SSSpeechSynthesizer new];
        _synthesizer.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(voiceOverStatusChanged)
                                                     name:UIAccessibilityVoiceOverStatusChanged
                                                   object:nil];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Enqueue"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(enqueueText:)];
    
    _textView = [[UITextView alloc] initWithFrame:self.view.frame];
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor clearColor];
    _textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _textView.text = @"Type to enqueue text to the synthesizer. Make sure VoiceOver is enabled!";
    [self.view addSubview:_textView];
    
    [_textView becomeFirstResponder];
}

#pragma mark - Enqueue

- (void)enqueueText:(UIBarButtonItem *)sender {
    NSString *text = [_textView.text copy];
    
    if ([text length] == 0) {
        return;
    }
    
    [_synthesizer enqueueLineForSpeaking:text];
    
    [_textView resignFirstResponder];
    _textView.text = @"";
    [_textView becomeFirstResponder];
    
    if (!UIAccessibilityIsVoiceOverRunning()) {
        [[[UIAlertView alloc] initWithTitle:@"Is this thing on?"
                                   message:@"The synthesizer will start speaking when VoiceOver is enabled."
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

#pragma mark - VO status

- (void)flashTitle:(NSString *)title {
    self.title = title;
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.title = kNormalTitle;
    });
}

- (void)voiceOverStatusChanged {
    if (UIAccessibilityIsVoiceOverRunning()) {
        [self flashTitle:@"VoiceOver enabled!"];
    } else {
        [self flashTitle:@"VoiceOver disabled!"];
    }
}

#pragma mark - SSSpeechSynthesizerDelegate

- (NSTimeInterval)synthesizer:(SSSpeechSynthesizer *)synthesizer
  secondsToWaitBeforeSpeaking:(NSString *)line {
    
    return 0.5;
}

- (void)synthesizer:(SSSpeechSynthesizer *)synthesizer willBeginSpeakingLine:(NSString *)line {
    
}

- (void)synthesizer:(SSSpeechSynthesizer *)synthesizer
       didSpeakLine:(NSString *)line {
    
}

- (void)synthesizerDidFinishQueue:(SSSpeechSynthesizer *)synthesizer {
    
}

@end
