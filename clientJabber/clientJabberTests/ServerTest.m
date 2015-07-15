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


- (void)testServerConnectionWithGoodLogin {
    BOOL result;
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    result = [testChat connectWith:@"usertest1@jonathans-macbook-pro.local" :@"test"];
    XCTAssertEqual(result, YES, @"Should have matched");
}

- (void)testServerConnectionWithNoLoginAndNoPassword {
    BOOL result;
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    result = [testChat connectWith:@"" :@""];
    XCTAssertEqual(result, NO, @"Should have matched");
}

- (void)testServerConnectionWithBadLoginAndPassword {
    BOOL result;
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    result = [testChat connectWith:@"toto" :@"topot"];
    XCTAssertEqual(result, YES, @"Should have matched");
}

- (void)testServerDisconnection {
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    [testChat connectWith:@"usertest1@jonathans-macbook-pro.local" :@"test"];
    [testChat disconnect];
    XCTAssertEqual(testChat.isOpen, NO, @"Should have matched");
}

- (void)testServerSendingEmptyMessage {
    BOOL result;
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    [testChat connectWith:@"usertest1@jonathans-macbook-pro.local" :@"test"];
    result = [testChat sendMessage:@"" :@"usertest2@jonathans-macbook-pro.local"];
    XCTAssertEqual(result, NO, @"Should have matched");
}

- (void)testServerSendingGoodMessage {
    BOOL result;
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    [testChat connectWith:@"usertest1@jonathans-macbook-pro.local" :@"test"];
    result = [testChat sendMessage:@"coucou" :@"usertest2@jonathans-macbook-pro.local"];
    XCTAssertEqual(result, YES, @"Should have matched");
}

- (void)testServerReceivingMessage {
    NSMutableDictionary *newMessage = [NSMutableDictionary
                                       dictionaryWithDictionary:@{
                                                    @"user"    : @"Me",
                                                    @"message" : @"coucou"
    }];
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    [testChat connectWith:@"usertest1@jonathans-macbook-pro.local" :@"test"];
    [testChat sendMessage:@"coucou" :@"usertest1@jonathans-macbook-pro.local"];
    XCTAssertEqual(testChat.conversations, newMessage, @"Should have matched");
}

- (void)testServerAddingContacts {
    //A faire
}

- (void)testServerGetContacts {
    //A faire
}


@end
