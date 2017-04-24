//
//  PhoneNumberConfirmationViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 24/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PhoneNumberConfirmationViewController.h"
#import "ClientDetailsViewController.h"
#import "CarkyApiClient.h"

@interface PhoneNumberConfirmationViewController ()
@property (nonatomic, strong) NSString *sendCodeText;
@end

@implementation PhoneNumberConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.sendCodeText = self.enterTheCodePhoneNumberLabel.text;
    self.enterTheCodePhoneNumberLabel.text = [NSString stringWithFormat:@"%@%@", self.sendCodeText, self.phoneNumber];
    [self.confirmCodeTextField becomeFirstResponder];
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

- (IBAction)resendCodeButton_Click:(UIButton *)sender {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api SendPhoneNumberConfirmationForUser:self.userId withBlock:^(NSString *str) {
        NSLog(@"Confirm response %@", str);
    }];
}

- (IBAction)submitVerificationCodeButton_Click:(UIButton *)sender {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api ConfirmPhoneNumberWithCode:self.confirmCodeTextField.text forUser:self.userId withBlock:^(BOOL isOk) {
        // todo check why bad request
        if (1==1) {
            self.delegate.isPhoneConfirmed = YES;
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

@end
