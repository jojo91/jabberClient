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
    }
    return self;
}

- (IBAction)sendMessage:(id)sender {
    if([_message.text length] > 0) {
        NSMutableDictionary *emptyMessage = [NSMutableDictionary
                                             dictionaryWithDictionary:@{
                                                @"user"    : @"Moi",
                                                @"message" : _message.text
        }];
        
        [[_conversations objectForKey:chatWithUser] addObject:emptyMessage];
        [self.chat sendMessage:_message.text :chatWithUser];
        _message.text = @"";
        NSLog(@"%@", _conversations);
    }
}

@end
