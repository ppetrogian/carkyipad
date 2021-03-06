//
//  PaymentViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
@class ShadowViewWithText;
#import "CheckMarkButton.h"

@interface PaymentViewController : StepViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet ShadowViewWithText *totalPriceButton;
//-----------
@property (nonatomic, weak) IBOutlet UIView *clientDetailBackView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *clientCenterConstraint;
@property (nonatomic, weak) IBOutlet UITextField *firstNameTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *lastNameTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *phoneTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *emailNameTxtFld;
@property (nonatomic, weak) IBOutlet UIButton *confirmButton;
-(IBAction) confirmButtonAction:(UIButton *)sender;
//-------------------
@property (nonatomic, weak) IBOutlet UIView *paymnetBackView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *paymentCenterConstraint;
@property (nonatomic, weak) IBOutlet UITextField *cardNumberTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *expireTxtFld;
@property (nonatomic, weak) IBOutlet UITextField *cvvTxtFld;
@property (nonatomic, weak) IBOutlet UIButton *payButton;
@property (nonatomic, weak) IBOutlet UIButton *paypalButton;
@property (nonatomic, weak) IBOutlet UILabel *temsLabel;
-(IBAction)displayTemsAndConditions:(id)sender;
-(IBAction) payButtonAction:(UIButton *)sender;
-(IBAction) paypalButtonAction:(UIButton *)sender;
//---------
@property (nonatomic, weak) IBOutlet CheckMarkButton *checkMarkButton;
-(IBAction)checkmarkButtonAction:(CheckMarkButton *)sender;
-(IBAction) backButtonAction:(UIButton *)sender;
@end
