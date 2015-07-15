//
//  clientJabberTests.m
//  clientJabberTests
//
//  Created by Jonathan ; on 5/29/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XMPP.h"
#import "XMPPFramework.h"
#import "ChatXmpp.h"

@interface clientJabberTests : XCTestCase
{
    XMPPRoster *xmppRoster;
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPStream *xmppStream;
}
@end

@implementation clientJabberTests

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

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


- (void)testConnect
{
    NSString *Jid = [[NSString alloc]initWithFormat:@"userappli@jonathans-macbook-pro.local"];
    NSString *Password = [[NSString alloc]initWithFormat:@"test"];
    
    if ([Jid isEqualToString:@""] || [Password isEqualToString:@""])
    {
        XCTFail(@"Variable shouldn't be empty");
    }
    
    if (Jid == nil|| Password == nil)
    {
        XCTFail(@"Variables should not be nil");
    }
    
    ChatXmpp *testChatXmpp = [[ChatXmpp alloc]init];
    [testChatXmpp initChat:Jid :Password];
}

- (void)testStream
{
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream setHostName:@"localhost"];
    [xmppStream setHostPort:5222];
    
    // ROSTER //
    
    xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    xmppRoster        = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
    
    xmppRoster.autoFetchRoster = YES;
    xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;
    
    [xmppRoster            activate:xmppStream];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    ////////////
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)testAddContact
{
    [self testStream];
    NSString *value = [[NSString alloc]initWithFormat:@""];
    
    if(value == nil)
    {
        XCTFail(@"Error, Variable is nil Or empty");
    }
    else
    {
        XMPPJID *jid = [XMPPJID jidWithString:value];

        [xmppRoster addUser:jid withNickname:nil];
    }
}

- (void)testContactList
{
    [self testStream];
    [self testConnect];
    
    XMPPIQ *iq;
    NSXMLElement *queryElement = [iq elementForName: @"query" xmlns: @"jabber:iq:roster"];
    
    if (queryElement) {
        NSArray *itemElements = [queryElement elementsForName: @"item"];
        [itemElements count];
        NSLog(@"%lu",(unsigned long)[itemElements count]);
    }
    XCTFail(@"Don't get ROSTER LIST");
}
@end
