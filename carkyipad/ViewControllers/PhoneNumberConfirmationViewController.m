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
#import "ButtonUtils.h"

@interface PhoneNumberConfirmationViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSString *sendCodeText;
@end

@implementation PhoneNumberConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sendCodeText = self.enterTheCodePhoneNumberLabel.text;
    self.enterTheCodePhoneNumberLabel.text = [NSString stringWithFormat:@"%@%@", self.sendCodeText, self.phoneNumber];
    
    for (NSInteger i=1; i<=6; i++) {
        UITextField *tf = [self.view viewWithTag:i];
        tf.delegate = self;
        [AppDelegate configurePSTextField:tf withColor:[UIColor blackColor]];
        if (i==1) {
            [tf becomeFirstResponder];
        }
    }
    [self.submitVerificationCodeButton disableButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug
    if(range.length + range.location > textField.text.length)  {
        return NO;
    }
    // allow backspace
    if ([textField.text stringByReplacingCharactersInRange:range withString:string].length < textField.text.length) {
        return YES;
    }
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 1;
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
    } else if(sender.text.length > 0) {
          [self.submitVerificationCodeButton enableButton];
    }
}

- (IBAction)resendCodeButton_Click:(UIButton *)sender {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api SendPhoneNumberConfirmationForUser:self.userId withBlock:^(NSString *str) {
        NSLog(@"Confirm response %@", str);
    }];
}

-(NSInteger)getCodeLength {
    NSInteger len = 0;
    for (NSInteger i=1; i<=6; i++) {
        UITextField *tf = [self.view viewWithTag:i];
        len += tf.text.length;
    }
    return len;
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
- (IBAction)back_Click:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
