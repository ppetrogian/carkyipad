
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 24/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
@class PaymentCardEditorField,ClientDetailsViewController,BKCardExpiryField;

@interface PaymentViewController : StepViewController
@property (weak, nonatomic) IBOutlet UIButton *payNowButton;
@property (weak, nonatomic) IBOutlet UIButton *payWithPaypalButton;
@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;
@property (weak, nonatomic) IBOutlet BKCardExpiryField *expiryDateTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *paymentsScrollView;

@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeWithTermsButton;
@property (weak, nonatomic) IBOutlet PaymentCardEditorField *stpCardTextField;
@end
