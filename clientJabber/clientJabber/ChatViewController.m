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
    self.title = [chatWithUser stringByReplacingOccurrencesOfString:@"@jonathans-macbook-pro.local" withString:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id) initWithUser:(NSString *) userName {
    self = [self initWithNibName:@"ChatViewController" bundle:nil];

    if (self = [super init]) {
        chatWithUser = userName;
    }
    return self;
}

- (IBAction)sendMessage:(id)sender {
    if([_message.text length] > 0) {
        NSMutableDictionary *newMessage = [NSMutableDictionary
                                             dictionaryWithDictionary:@{
                                                @"user"    : @"Moi",
                                                @"message" : _message.text
        }];
        
        [[self.chat.conversations objectForKey:chatWithUser] addObject:newMessage];
        [self.chat sendMessage:_message.text :chatWithUser];

        NSLog(@"envoi de message");
        NSLog(@"%@", self.chat.conversations);
        _message.text = @"";
    }
}

@end
