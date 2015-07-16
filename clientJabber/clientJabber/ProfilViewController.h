//
//  ProfilViewController.h
//  clientJabber
//
//  Created by Yonael Tordjman on 03/07/2015.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatXmpp.h"

@interface ProfilViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *presenceInput;
- (IBAction)showPickerProfile:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerProfil;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)DoneAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *hostnameTextfield;

@property (weak, nonatomic) IBOutlet UILabel *jaberIdTextfield;

@property (strong, nonatomic) ChatXmpp *chat;

@end
