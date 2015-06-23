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
        _message.text = @"";
        [self.tableMessage reloadData];
    }
}

- (IBAction)reloadTableView:(id)sender {
    [self.tableMessage reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.chat.conversations objectForKey:chatWithUser] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell                  = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    //*********************************************************
    NSMutableDictionary *message = [NSMutableDictionary dictionary];
    message = [[self.chat.conversations objectForKey:chatWithUser] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@", message[@"user"], message[@"message"]];
    //*********************************************************
    return cell;
}

@end
