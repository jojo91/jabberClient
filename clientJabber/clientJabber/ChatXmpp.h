//
//  ChatXmpp.h
//  clientJabber
//
//  Created by Jonathan Lequeux on 6/8/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"
#import "XMPPFramework.h"

@interface ChatXmpp : NSObject <XMPPRosterDelegate>

@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) NSString *password;
@property (readwrite, copy) NSString *hostName;
@property (readwrite, assign) UInt16 *hostPort;
@property (readwrite, nonatomic) BOOL isOpen;

@property (strong, nonatomic) XMPPPresence *askingGuy;

@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;

- (NSManagedObjectContext *)managedObjectContext_roster;

- (void)initChat:(NSString *)jid :(NSString *)pass;
- (void)disconnect;
- (void)setupStream;
- (void)goOnline;
- (void)goOffline;
- (BOOL)connectWith:(NSString *)jid :(NSString *)pass;
- (void)sendMessage:(NSString *)message :(NSString *)userName;
- (void)addContactInRoster:(NSString *)value;

@end
