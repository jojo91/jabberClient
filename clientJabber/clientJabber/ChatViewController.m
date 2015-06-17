//
//  ChatViewController.m
//  clientJabber
//
//  Created by Jonathan Lequeux on 6/10/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

@synthesize chatWithUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    _myContact.text = [chatWithUser stringByReplacingOccurrencesOfString:@"@jonathans-macbook-pro.local" withString:@""];
    _conversations = [NSMutableDictionary dictionary];
    NSMutableDictionary *emptyMessage = [NSMutableDictionary
                                         dictionaryWithDictionary:@{
                                                                    @"user"    : @"Moi",
                                                                    @"message" : @""
    }];

    NSMutableArray *messages = [[NSMutableArray alloc] initWithObjects:emptyMessage, nil];
    _conversations           = [[NSMutableDictionary alloc] initWithObjectsAndKeys:messages, chatWithUser, nil];
    NSLog(@"%@", _conversations);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithUser:(NSString *) userName {
    self = [self initWithNibName:@"ChatViewController" bundle:nil];

    if (self = [super init]) {
        chatWithUser = userName;
//        turnSockets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (IBAction)sendMessage:(id)sender {
    [self.chat sendMessage:_message.text :chatWithUser];
    _message.text = @"";
}

@end
