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

@property (strong, nonatomic) UIWindow *window;

@end
