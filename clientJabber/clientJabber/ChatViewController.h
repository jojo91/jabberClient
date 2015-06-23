//
//  ChatViewController.h
//  clientJabber
//
//  Created by Jonathan Lequeux on 6/10/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatXmpp.h"

@interface ChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) ChatXmpp *chat;
@property (nonatomic,retain) NSString *chatWithUser;
@property (weak, nonatomic) IBOutlet UITextField *message;
@property (weak, nonatomic) IBOutlet UITableView *tableMessage;

- (id) initWithUser:(NSString *) userName;


- (IBAction)sendMessage:(id)sender;
- (IBAction)reloadTableView:(id)sender;

@end
