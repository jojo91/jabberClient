//
//  LoginViewController.h
//  clientJabber
//
//  Created by Jonathan Lequeux on 5/29/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>
{
    XMPPStream *xmppStream;
    NSString *password;
}

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (readwrite, copy) NSString *hostName;
@property (readwrite, assign) UInt16 *hostPort;
@property (weak, nonatomic) IBOutlet UITextField *inputPassword;

@property (weak, nonatomic) IBOutlet UITextField *inputJabber;

- (BOOL)connectWithUser:(NSString *)jid :(NSString *)pass;

@end
