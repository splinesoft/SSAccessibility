//
//  SSAccessibilityTests.m
//  SSAccessibilityTests
//
//  Created by Jonathan Hersh on 1/4/14.
//  Copyright (c) 2014 Splinesoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SSAccessibility.h>
#import <SSSpeechSynthesizer.h>

@interface SSAccessibilityTests : XCTestCase

@end

@implementation SSAccessibilityTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitializable
{
    XCTAssertNotNil([SSSpeechSynthesizer new], @"Should be initializable");
}

@end
