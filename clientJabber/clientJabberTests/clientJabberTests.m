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


@end
