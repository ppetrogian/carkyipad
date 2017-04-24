//
//  ClientDetailsViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 24/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "ClientDetailsViewController.h"
#import "CountryPhoneCodeVC.h"
#import "TransferStepsViewController.h"
#import "CarkyApiClient.h"
#import "AppDelegate.h"
#import "DataModels.h"
#import "SharedInstance.h"

@interface ClientDetailsViewController () <SelectDelegate, UITextViewDelegate>

@end

@implementation ClientDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.confirmButton.enabled = YES;
    self.confirmButton.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// handler for flag did-select
- (void)didSelect:(BOOL)hasSelected {
    NSString *imName = [[SharedInstance sharedInstance].selCountryCode lowercaseString];
    [self.flagButton setImage:[UIImage imageNamed:imName] forState:UIControlStateNormal];
    self.countryPrefixLabel.text = [SharedInstance sharedInstance].selCountryId;
}

- (IBAction)flagButton_Click:(UIButton *)sender {
    [self hideKeyboard];
    CountryPhoneCodeVC *vcObj =[[CountryPhoneCodeVC alloc] initWithNibName:@"CountryPhoneCodeVC" bundle:nil];
    vcObj.delegate = self;
    vcObj.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popPresenter = [vcObj popoverPresentationController];
    popPresenter.sourceView = self.flagButton;
    [self presentViewController:vcObj animated:YES completion:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.confirmButton.enabled = YES;
        self.confirmButton.backgroundColor = [UIColor blackColor];
    }
}

-(void)hideKeyboard{
    [self.view endEditing:YES];
}

- (IBAction)confirmButton_Click:(UIButton *)sender {
    
}

@end
