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
#import "PhoneNumberConfirmationViewController.h"

@interface ClientDetailsViewController () <SelectDelegate, UITextViewDelegate>
@property (nonatomic, readonly, weak) TransferStepsViewController *parentController;
@property (nonatomic, strong) NSString *userId;
@end

@implementation ClientDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isPhoneConfirmed = NO;
    
    self.confirmButton.enabled = YES;
    self.confirmButton.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"phoneConfirmSegue"]) {
        PhoneNumberConfirmationViewController *destVc = segue.destinationViewController;
        destVc.delegate = self;
        destVc.phoneNumber = [NSString stringWithFormat:@"%@%@", self.countryPrefixLabel.text, self.phoneNumberTextField.text];
        destVc.userId = self.userId;
    }
}

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

-(TransferStepsViewController *)parentController {
    return (TransferStepsViewController *)self.stepsController;
}

- (IBAction)confirmButton_Click:(UIButton *)sender {
    RegisterClientRequest *acc = [RegisterClientRequest new];
    acc.phoneNumber = self.phoneNumberTextField.text;
    acc.email = self.emailTextField.text;
    acc.confirmEmail = self.confirmEmailTextField.text;
    acc.firstName = self.firstNameTextField.text;
    acc.lastName = self.lastNameTextField.text;
    acc.phoneNumberCountryCode = self.countryPrefixLabel.text;
    // inform parent and call api
    self.parentController.clientData = acc;
    CarkyApiClient *api = [CarkyApiClient sharedService];
    if (self.isPhoneConfirmed) {
        [self.parentController showNextStep];
    } else {
        [api RegisterClient:acc withBlock:^(NSString *str) {
            self.userId = str;
            [self performSegueWithIdentifier:@"phoneConfirmSegue" sender:nil];
        }];
    }
}
        
 

@end
