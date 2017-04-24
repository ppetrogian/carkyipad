//
//  PhoneNumberConfirmationViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 24/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STPPaymentCardTextField,ClientDetailsViewController;

@interface PhoneNumberConfirmationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *confirmCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *resendCodeButton;
@property (weak, nonatomic) IBOutlet UILabel *enterTheCodePhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitVerificationCodeButton;

@property (nonatomic, weak) ClientDetailsViewController *delegate;
@property (strong,nonatomic) NSString *phoneNumber;
@property (nonatomic, strong) NSString *userId;
@end
