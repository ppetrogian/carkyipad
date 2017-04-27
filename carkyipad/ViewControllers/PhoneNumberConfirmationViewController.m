//
//  PhoneNumberConfirmationViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 24/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//
#import "TransferStepsViewController.h"
#import "PhoneNumberConfirmationViewController.h"
#import "ClientDetailsViewController.h"
#import "CarkyApiClient.h"
#import "AppDelegate.h"

@interface PhoneNumberConfirmationViewController ()
@property (nonatomic, strong) NSString *sendCodeText;
@end

@implementation PhoneNumberConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sendCodeText = self.enterTheCodePhoneNumberLabel.text;
    self.enterTheCodePhoneNumberLabel.text = [NSString stringWithFormat:@"%@%@", self.sendCodeText, self.phoneNumber];
    //[self.confirmCodeTextField becomeFirstResponder];
    for (NSInteger i=1; i<=6; i++) {
        UITextField *tf = [self.view viewWithTag:i];
        [AppDelegate configurePSTextField:tf withColor:[UIColor blackColor]];
        if (i==1) {
            [tf becomeFirstResponder];
        }
    }
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

- (IBAction)digitButton_BeginEdit:(UITextField *)sender {
    sender.text = @"";
}

- (IBAction)digitButton_Edit:(UITextField *)sender {
    NSInteger tagNo = sender.tag;
    if (tagNo < 6) {
        [[self.view viewWithTag:tagNo+1] becomeFirstResponder];
    }
}

- (IBAction)resendCodeButton_Click:(UIButton *)sender {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api SendPhoneNumberConfirmationForUser:self.userId withBlock:^(NSString *str) {
        NSLog(@"Confirm response %@", str);
    }];
}

- (IBAction)submitVerificationCodeButton_Click:(UIButton *)sender {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    NSMutableString *strDigits = [NSMutableString stringWithCapacity:6];
    for (NSInteger i=1; i<=6; i++) {
        UITextField *tf = [self.view viewWithTag:i];
        [strDigits appendString:tf.text];
    }
    self.confirmCodeTextField.text = [strDigits copy];
    [api ConfirmPhoneNumberWithCode:self.confirmCodeTextField.text forUser:self.userId withBlock:^(BOOL isOk) {
        // todo check why bad request
        if (isOk) {
            self.delegate.isPhoneConfirmed = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            TransferStepsViewController *transferVc = (TransferStepsViewController *)self.delegate.parentViewController;
            [transferVc showAlertViewWithMessage:@"You entered wrong code" andTitle:@"Error"];
        }
    }];
}

@end
