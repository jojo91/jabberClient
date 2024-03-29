//
//  LoginViewController.m
//  clientJabber
//
//  Created by Jonathan Lequeux on 5/29/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import "LoginViewController.h"
#import "XMPP.h"
#import "RosterViewController.h"

@interface LoginViewController ()

@end


@implementation LoginViewController

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
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoginChat:(id)sender {
    self.chat = [[ChatXmpp alloc] init];
    [self.chat initChat:_inputJabber.text :_inputPassword.text];
    RosterViewController *Controller = [[RosterViewController alloc]initWithNibName:@"RosterViewController" bundle:nil];
    Controller.chat = self.chat;
    [self.navigationController pushViewController:Controller animated:YES];
}
@end
