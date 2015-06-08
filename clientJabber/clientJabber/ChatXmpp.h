//
//  ChatXmpp.h
//  clientJabber
//
//  Created by Jonathan Lequeux on 6/8/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@interface ChatXmpp : NSObject

@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) NSString *password;
@property (readwrite, copy) NSString *hostName;
@property (readwrite, assign) UInt16 *hostPort;
@property (readwrite, nonatomic) BOOL isOpen;

- (void)initChat:(NSString *)jid :(NSString *)pass;
- (void)disconnect;
- (void)setupStream;
- (void)goOnline;
- (void)goOffline;
- (BOOL)connectWith:(NSString *)jid :(NSString *)pass;

@end
