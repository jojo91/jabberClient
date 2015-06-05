//
//  jabberClientAppDelegate.h
//  clientJabber
//
//  Created by Jonathan Lequeux on 5/29/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import <UIKit/UIKit.h>
// Ajouter par YTO
#import "XMPP.h"
#import "XMPPFramework.h"

@class LoginViewController;

@interface jabberClientAppDelegate : NSObject <UIApplicationDelegate, XMPPRosterDelegate>
{
    UIWindow *window;
    XMPPStream *xmppStream;
    NSString *password;
    BOOL isOpen;
    
    BOOL customCertEvaluation;
}

@property (strong, nonatomic) UIWindow *window;
// Ajouter par YTO
@property (nonatomic, readonly) XMPPStream *xmppStream;

- (void)disconnect;
- (void)setupStream;
- (void)goOnline;
- (void)goOffline;
- (BOOL)connectWith:(NSString *)jid :(NSString *)pass;

@end
