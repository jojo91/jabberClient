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

- (void)testServerAddingContacts {
    BOOL result;
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    [testChat connectWith:@"test@chat.local" :@"test"];
    result = [testChat addContactInRoster:@"yonael.tordjman@gmail.com"];
    XCTAssertEqual(result, YES, @"Should have matched");
}

-(bool) isNumeric:(NSString*) checkText
{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSNumber* number = [numberFormatter numberFromString:checkText];
    if (number != nil) {
        NSLog(@"%@ is numeric", checkText);
        return true;
    }
    NSLog(@"%@ is not numeric", checkText);
    return false;
}

- (void)testServerGetContacts {
    NSString* result;
    BOOL res;
    ChatXmpp *testChat = [[ChatXmpp alloc]init];
    [testChat connectWith:@"test@chat.local" :@"test"];
    XMPPIQ *iq = [[XMPPIQ alloc]init];
    NSXMLElement *queryElement = [iq elementForName: @"query" xmlns: @"jabber:iq:roster"];
    NSMutableArray *ArrayUsers = [[NSMutableArray alloc]init];
    if (queryElement)
    {
        NSArray *itemElements = [queryElement elementsForName: @"item"];
        [ArrayUsers removeAllObjects];
        for (int i=0; i<[itemElements count]; i++)
        {
            NSString *jid=[[[itemElements objectAtIndex:i] attributeForName:@"jid"] stringValue];
            [ArrayUsers addObject:jid];
        }
    }
    result = [NSString stringWithFormat: @"%ld", (long)[ArrayUsers count]];

    if([self isNumeric:result])
    {
        res = YES;
    }
    else
    {
        res = NO;
    }
    
    XCTAssertEqual(res, YES, @"Should have matched");
}

- (void)testServerDeleteContacts {
    BOOL result;
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    [testChat connectWith:@"test@chat.local" :@"test"];
    result = [testChat removeContactInRoster:@"yonael.tordjman@gmail.com"];
    XCTAssertEqual(result, YES, @"Should have matched");
}

- (void)testChangeProfileToDispo
{
    BOOL result;
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    [testChat connectWith:@"test@chat.local" :@"test"];
    result = [testChat statusOnline];
    XCTAssertEqual(result, YES, @"Should have matched");
}

- (void)testChangeProfileToAway
{
    BOOL result;
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    [testChat connectWith:@"test@chat.local" :@"test"];
    result = [testChat statusAway];
    XCTAssertEqual(result, YES, @"Should have matched");
}

- (void)testChangeProfileToBusy
{
    BOOL result;
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    [testChat connectWith:@"test@chat.local" :@"test"];
    result = [testChat statusBusy];
    XCTAssertEqual(result, YES, @"Should have matched");
}

- (void)testChangeProfileToOffline
{
    BOOL result;
    ChatXmpp *testChat = [[ChatXmpp alloc] init];
    [testChat connectWith:@"test@chat.local" :@"test"];
    result = [testChat statusOnline];
    XCTAssertEqual(result, YES, @"Should have matched");
}



@end
