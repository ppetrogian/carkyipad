//
//  ClientDetailsViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 24/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"

@interface ClientDetailsViewController : StepViewController
@property (weak, nonatomic) IBOutlet UIButton *flagButton;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailRequiredLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneVerificationLabel;

@property (weak, nonatomic) IBOutlet UILabel *countryPrefixLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *bookLaterButton;

@property (nonatomic, assign) BOOL isPhoneConfirmed;
@end
