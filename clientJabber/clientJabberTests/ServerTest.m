//
//  ServerTest.m
//  clientJabber
//
//  Created by Jonathan Lequeux on 7/10/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ChatXmpp.h"

@interface ServerTest : XCTestCase

@end

@implementation ServerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)serverConnection {
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    [testChat initChat:@"userappli@jonathans-macbook-pro.local" :@"test"];
//    Card *card1 = [[Card alloc] init];
//    card1.contents = @"one";
//    Card *card2 = [[Card alloc] init];
//    card2.contents = @"one";
//    NSArray *handOfCards = @[card2];
//    int matchCount = [card1 match:handOfCards];
//    XCTAssertEqual(matchCount, 1, @"Should have matched");
}

@end
