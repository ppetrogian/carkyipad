//
//  PaymentViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PaymentViewController.h"
#import "ShadowViewWithText.h"
#import "StepViewController.h"
#import "RMStepsController.h"
#import "CarRentalStepsViewController.h"
#import "UIController.h"
#import "PasscodeView.h"
#import "AppDelegate.h"
#import "RentalConfirmationView.h"

@interface PaymentViewController ()<PasscodeViewDelegate>

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
    NSMutableDictionary *res = self.stepsController.results;
    NSInteger totalprice = ((NSNumber *)res[kResultsTotalPrice]).integerValue;
    self.totalPriceButton.text = [NSString stringWithFormat:@"%@     %@: %ld€", NSLocalizedString(@"PAY NOW", nil), NSLocalizedString(@"Total", nil), totalprice];
    CarRentalStepsViewController *parentVc = (CarRentalStepsViewController *)self.stepsController;
    parentVc.totalView.hidden = YES;*/
    [self setupInit];
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self displayClientDetailView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)payNow:(id)sender {
    [self.stepsController showNextStep];
}
-(void) setupInit{
    UIController *controller = [UIController sharedInstance];
    [controller addBorderWithWidth:1.0 withColor:[UIColor lightGrayColor] withCornerRadious:3 toView:self.firstNameTxtFld];
    [controller addBorderWithWidth:1.0 withColor:[UIColor lightGrayColor] withCornerRadious:3 toView:self.lastNameTxtFld];
    [controller addBorderWithWidth:1.0 withColor:[UIColor lightGrayColor] withCornerRadious:5 toView:self.phoneTxtFld];
    [controller addBorderWithWidth:1.0 withColor:[UIColor lightGrayColor] withCornerRadious:5 toView:self.emailNameTxtFld];
    [controller addBorderWithWidth:0.0 withColor:[UIColor clearColor] withCornerRadious:2 toView:self.confirmButton];
    //add left padding
    [controller addLeftPaddingtoTextField:self.firstNameTxtFld withFrame:CGRectMake(0, 0, 20, 20) withBackgroundColor:[UIColor clearColor] withImage:nil];
    [controller addLeftPaddingtoTextField:self.lastNameTxtFld withFrame:CGRectMake(0, 0, 20, 20) withBackgroundColor:[UIColor clearColor] withImage:nil];
    [controller addLeftPaddingtoTextField:self.phoneTxtFld withFrame:CGRectMake(0, 0, 40, 20) withBackgroundColor:[UIColor clearColor] withImage:nil];
    [controller addLeftPaddingtoTextField:self.emailNameTxtFld withFrame:CGRectMake(0, 0, 20, 20) withBackgroundColor:[UIColor clearColor] withImage:nil];
    //----------------------
    [controller addBorderWithWidth:1.0 withColor:[UIColor lightGrayColor] withCornerRadious:5 toView:self.cardNumberTxtFld];
    [controller addBorderWithWidth:1.0 withColor:[UIColor lightGrayColor] withCornerRadious:2 toView:self.expireTxtFld];
    [controller addBorderWithWidth:1.0 withColor:[UIColor lightGrayColor] withCornerRadious:2 toView:self.cvvTxtFld];
    [controller addLeftPaddingtoTextField:self.cardNumberTxtFld withFrame:CGRectMake(0, 0, 20, 20) withBackgroundColor:[UIColor clearColor] withImage:nil];
    [controller addRightPaddingtoTextField:self.cardNumberTxtFld withFrame:CGRectMake(0, 0, 50, 20) withBackgroundColor:[UIColor clearColor] withImage:@"TakePic"];
    [controller addLeftPaddingtoTextField:self.expireTxtFld withFrame:CGRectMake(0, 0, 50, 20) withBackgroundColor:[UIColor clearColor] withImage:@"Expiry_logo"];
    [controller addLeftPaddingtoTextField:self.cvvTxtFld withFrame:CGRectMake(0, 0, 50, 20) withBackgroundColor:[UIColor clearColor] withImage:@"cvv_logo"];
    [controller addBorderWithWidth:0.0 withColor:[UIColor clearColor] withCornerRadious:2 toView:self.payButton];
    [controller addBorderWithWidth:0.0 withColor:[UIColor clearColor] withCornerRadious:2 toView:self.paypalButton];
    //----
    self.checkMarkButton.isChecked = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -
-(IBAction) confirmButtonAction:(UIButton *)sender{
    NSLog(@"Confirm button Action");
    [self displayPassCodeView];
}
-(void) checkStatusForConfirmButton{
    if (self.firstNameTxtFld.text.length>1 && self.lastNameTxtFld.text.length>1 && self.phoneTxtFld.text.length>1 && self.emailNameTxtFld.text.length>1) {
        //self.confirmButton.enabled = YES;
        self.confirmButton.backgroundColor = [UIColor blackColor];
    }
    else{
       // self.confirmButton.enabled = NO;
        self.confirmButton.backgroundColor = [UIColor lightGrayColor];
    }
}
#pragma mark - Payment
-(IBAction)checkmarkButtonAction:(CheckMarkButton *)sender{
    sender.isChecked = !sender.isChecked;
}
-(IBAction) payButtonAction:(UIButton *)sender{
    [self displayRentalConfirmationView];
}
-(IBAction) paypalButtonAction:(UIButton *)sender{
    
}
-(void) displayPaymentView{
    self.paymnetBackView.hidden = NO;
    self.clientCenterConstraint.constant = -1000;
    self.paymentCenterConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.clientDetailBackView.hidden = YES;
    }];
}
-(IBAction)displayTemsAndConditions:(id)sender{
    NSLog(@"Display terms and conditions");
}
#pragma mark -
-(void) displayClientDetailView{
    self.paymnetBackView.hidden = YES;
    self.clientDetailBackView.hidden = NO;
    self.clientCenterConstraint.constant = 0;
    self.paymentCenterConstraint.constant = 1000;
}
#pragma mark - UITextFieldDelegate
-(void) textFieldDidEndEditing:(UITextField *)textField{
    
}
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    [self performSelector:@selector(checkStatusForConfirmButton) withObject:nil afterDelay:0.01];
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL) updateExpireTextFieldText:(UITextField *)textField range:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 5) {
        if (string.length>1 || range.location>4) {
            return NO;
        }
        //check for
        if (range.location == 0 && range.length == 0) {
            if (string.integerValue>1) {
                [self performSelector:@selector(updateStringWithValue:) withObject:[NSNumber numberWithInteger:1] afterDelay:0.005];
            }
        }
        if (range.location == 1 && range.length == 0) {
            if (string.integerValue>2) {
                return NO;
            }
            else if (textField.text.integerValue==0 && string.integerValue == 0){
                return NO;
            }
            [self performSelector:@selector(updateStringWithValue:) withObject:[NSNumber numberWithInteger:10] afterDelay:0.001];
        }
        else if (range.location == 2 && range.length == 1){
            [self performSelector:@selector(updateStringWithValue:) withObject:[NSNumber numberWithInteger:21] afterDelay:0.001];
        }
    }
    return YES;
}
-(void) updateStringWithValue:(NSNumber *)value{
    if (value.integerValue == 10) {
        self.expireTxtFld.text = [NSString stringWithFormat:@"%@/",self.expireTxtFld.text];
    }
    else if(value.integerValue == 21){
        NSString *text = [NSString stringWithFormat:@"%@",self.expireTxtFld.text];
        self.expireTxtFld.text = [text substringWithRange:NSMakeRange(0, 1)];
    }
    else if(value.integerValue == 1){
        self.expireTxtFld.text = [NSString stringWithFormat:@"0%@/",self.expireTxtFld.text];
    }
}
#pragma mark - Passcode View
-(void) displayPassCodeView{
    PasscodeView *passcodeView = [[[NSBundle mainBundle] loadNibNamed:@"PasscodeView" owner:self options:nil] firstObject];
    passcodeView.frame = [UIScreen mainScreen].bounds;
    passcodeView.alpha = 0;
    passcodeView.delegate = self;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:passcodeView];
    [UIView animateWithDuration:0.2 animations:^{
        passcodeView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [passcodeView displayKeyboard];
    }];
}
-(void) didSelectedResendCode{
    NSLog(@"Resend code");
}
-(void) didSelectedSubmitCode:(NSString *)code{
    NSLog(@"Entered code is = %@",code);
    [self displayPaymentView];
}
#pragma mark - Confirmation View
-(void) displayRentalConfirmationView{
    RentalConfirmationView *confirmationView = [[[NSBundle mainBundle] loadNibNamed:@"RentalConfirmationView" owner:self options:nil] firstObject];
    confirmationView.frame = [UIScreen mainScreen].bounds;
    confirmationView.alpha = 0;
    //confiramtionView.delegate = self;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:confirmationView];
    [UIView animateWithDuration:0.3 animations:^{
        confirmationView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma maark - 
-(IBAction) backButtonAction:(UIButton *)sender{
    if (self.stepDelegate && [self.stepDelegate respondsToSelector:@selector(didSelectedBack:)]) {
        [self.stepDelegate didSelectedBack:sender];
    }
}
@end
