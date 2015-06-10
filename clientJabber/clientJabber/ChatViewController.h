//
//  ChatViewController.h
//  clientJabber
//
//  Created by Jonathan Lequeux on 6/10/15.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *myContact;
@property (nonatomic,retain) NSString *chatWithUser;

- (id) initWithUser:(NSString *) userName;
@end
