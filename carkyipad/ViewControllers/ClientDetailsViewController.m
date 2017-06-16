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
#import "ButtonUtils.h"
#import "Validation.h"

@interface ClientDetailsViewController () <SelectDelegate, UITextViewDelegate>
@property (nonatomic, readonly, weak) TransferStepsViewController *parentController;
@property (nonatomic, strong) RegisterClientResponse *registerClientResponse;
@property (nonatomic, strong) Validation *validator;
@end

@implementation ClientDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isPhoneConfirmed = NO;
    self.validator = [Validation new];
    AppDelegate *app = [AppDelegate instance];
    
    CarkyBackendType bt = (CarkyBackendType)[AppDelegate instance].environment;
    if (bt == CarkyBackendTypeStage || bt == CarkyBackendTypeLive) {
        self.firstNameTextField.text = @"";
        self.lastNameTextField.text = @"";
        self.emailTextField.text = @"";
        self.phoneNumberTextField.text = @"";
        [self.confirmButton disableButton];
    } else {
         [self.confirmButton enableButton];
    }
    if (app.hotelPrefilled) {
        self.firstNameTextField.text = app.clientConfiguration.firstName;
        self.lastNameTextField.text = app.clientConfiguration.lastName;
        self.emailTextField.text = app.clientConfiguration.email;
        self.phoneNumberTextField.text = app.clientConfiguration.telephone;
        [self.confirmButton enableButton];
    }
    TabletMode tm = (TabletMode)app.clientConfiguration.tabletMode;
    if(tm == TabletModeReception) {
        self.emailTextField.hidden = YES;
    }
    [self.firstNameTextField becomeFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger maxPhoneLen = 10;
    if ([self.countryPrefixLabel.text isEqualToString:@"+55"] ) {
        maxPhoneLen = 11;
    }
    if (self.phoneNumberTextField == textField) {
        // Prevent crashing undo bug
        if(range.length + range.location > textField.text.length) {
            return NO;
        }
        if (![self.validator isDigit:string]) {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= maxPhoneLen;
    }
    return YES;
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
        destVc.userId = self.registerClientResponse.userId;
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

- (IBAction)textField_edit:(UITextField *)sender {
    BOOL mustEnable =  self.firstNameTextField.text.length > 0 && self.lastNameTextField.text.length > 0 && self.phoneNumberTextField.text.length > 0;
    if (self.emailTextField.hidden == NO) {
        mustEnable = mustEnable && self.emailTextField.text.length > 0  && [self.validator emailValidation:self.emailTextField.text];
    }
    else {
        self.emailTextField.text = [NSString stringWithFormat:@"phone%@@eageantaxi.com", self.phoneNumberTextField.text];
    }
    if (!mustEnable && self.confirmButton.isEnabled) {
        [self.confirmButton disableButton];
    }
    else if(mustEnable && !self.confirmButton.isEnabled) {
        [self.confirmButton enableButton];
    }
}

-(void)hideKeyboard{
    [self.view endEditing:YES];
}

-(TransferStepsViewController *)parentController {
    return (TransferStepsViewController *)self.stepsController;
}

- (IBAction)backButton_Click:(id)sender {
    [self.parentController showPreviousStep];
}

- (IBAction)confirmButton_Click:(UIButton *)sender {
    RegisterClientRequest *acc = [RegisterClientRequest new];
    acc.phoneNumber = self.phoneNumberTextField.text;
    acc.email = self.emailTextField.text;
    acc.confirmEmail = self.emailTextField.text;
    acc.firstName = self.firstNameTextField.text;
    acc.lastName = self.lastNameTextField.text;
    acc.phoneNumberCountryCode = self.countryPrefixLabel.text;
    // inform parent and call api
    self.parentController.clientData = acc;
    CarkyApiClient *api = [CarkyApiClient sharedService];
    if (self.isPhoneConfirmed) {
        [self.parentController showNextStep];
    } else {
        [[AppDelegate instance] showProgressNotificationWithText:nil inView:self.view];
        [api RegisterClient:acc withBlock:^(NSArray *arr) {
            [[AppDelegate instance] hideProgressNotification];
            if (arr && arr.count > 0) {
                if ([arr.firstObject isKindOfClass:RegisterClientResponse.class]) {
                    self.registerClientResponse = arr.firstObject;
                    self.parentController.userId = self.registerClientResponse.userId;
                    self.isPhoneConfirmed = self.registerClientResponse.phoneConfirmed;
                    if (!self.isPhoneConfirmed) {
                        [self performSegueWithIdentifier:@"phoneConfirmSegue" sender:nil];
                    } else {
                        self.isPhoneConfirmed = NO;
                        [self.parentController showNextStep];
                    }
                } else {
                    [self.parentController showAlertViewWithMessage:arr.firstObject andTitle:@"Error"];
                }
            } else {
                [self.parentController showAlertViewWithMessage:@"Cannot register client" andTitle:@"Error"];
            }
        }];
    }
}
        
 

@end
