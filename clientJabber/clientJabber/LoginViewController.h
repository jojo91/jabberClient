//
//  LoginViewController.h
//  clientJabber
//
//  Created by Jonathan Lequeux on 5/29/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "jabberClientAppDelegate.h"
#import "ChatXmpp.h"
#import "XMPP.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) XMPPStream *xmppStream;
@property (strong, nonatomic) ChatXmpp *chat;

@property (readwrite, copy) NSString *hostName;
@property (readwrite, assign) UInt16 *hostPort;
@property (weak, nonatomic) IBOutlet UITextField *inputPassword;
@property (weak, nonatomic) IBOutlet UITextField *inputJabber;

@end
