//
//  LoginViewController.m
//  clientJabber
//
//  Created by Jonathan Lequeux on 5/29/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import "LoginViewController.h"
#import "jabberClientAppDelegate.h"
#import "XMPP.h"

@interface LoginViewController ()
{
    jabberClientAppDelegate *appDelegate;
}

@end

@implementation LoginViewController
@synthesize xmppStream;

- (jabberClientAppDelegate *)appDelegate
{
    return (jabberClientAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication]delegate];
    appDelegate = [[jabberClientAppDelegate alloc]init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)connectWithUser:(NSString *)jid :(NSString *)pass;
{
    xmppStream = [[self appDelegate] xmppStream];
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (jid == nil || pass == nil) {
        return NO;
    }
    
    [xmppStream setMyJID:[XMPPJID jidWithString:jid]];
    password = pass;
    
    [xmppStream setHostName:@"localhost"];
    [xmppStream setHostPort:5222];
    
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

- (IBAction)LoginChat:(id)sender {
    [[self appDelegate]connectWith:_inputJabber.text :_inputPassword.text ];
}
@end
