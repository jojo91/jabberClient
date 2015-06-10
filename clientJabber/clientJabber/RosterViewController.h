//
//  RosterViewController.h
//  clientJabber
//
//  Created by Yonael Tordjman on 09/06/2015.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "ChatXmpp.h"

@interface RosterViewController : UIViewController <NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *fetchedResultsController;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) ChatXmpp *chat;
@end
