//
//  ProfilViewController.m
//  clientJabber
//
//  Created by Yonael Tordjman on 03/07/2015.
//  Copyright (c) 2015 Jonathan Lequeux. All rights reserved.
//

#import "ProfilViewController.h"

@interface ProfilViewController ()
{
    NSArray *arrayProfile;
}

@end

@implementation ProfilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pickerProfil.alpha = 0.0f;
    _doneButton.alpha = 0.0f;
    arrayProfile = @[@"En ligne", @"Occupé", @"Invisible"];
    _pickerProfil.delegate = self;
    _pickerProfil.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _presenceInput.text = [arrayProfile objectAtIndex:row];
    
    if ([_presenceInput.text isEqualToString:@"En ligne"]) {
        [self.chat statusOnline];
    }else if ([_presenceInput.text isEqualToString:@"Occupé"])
    {
        [self.chat statusAway];
    }else if([_presenceInput.text isEqualToString:@"Invisible"])
    {
        [self.chat StatusOffline];
    }else
    {
        NSLog(@"");
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return arrayProfile[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrayProfile count];
}

- (IBAction)showPickerProfile:(id)sender {
    _pickerProfil.alpha = 1.0f;
    _doneButton.alpha = 1.0f;
}
- (IBAction)DoneAction:(id)sender {
    _doneButton.alpha = 0.0f;
    _pickerProfil.alpha = 0.0f;
}
@end
