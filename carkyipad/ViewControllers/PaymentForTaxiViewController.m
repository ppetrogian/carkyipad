//
//  PaymentForTaxiViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 24/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PaymentForTaxiViewController.h"
#import <Stripe/Stripe.h>
#import "TransferStepsViewController.h"
#import "CarkyApiClient.h"
#import "AppDelegate.h"
#import "DataModels.h"
#import "CardIO.h"
#import "BKCardExpiryField.h"
#import "PaymentCardEditorField.h"

@interface PaymentForTaxiViewController () <CardIOPaymentViewControllerDelegate, STPPaymentCardTextFieldDelegate, UITextFieldDelegate>
@property (nonatomic, readonly, weak) TransferStepsViewController *parentController;
@end

@implementation PaymentForTaxiViewController

- (void)disablePayButton {
     self.payNowButton.backgroundColor = [UIColor lightGrayColor];
     self.payNowButton.enabled = NO;
}

-(void)enablePayButton {
    self.payNowButton.backgroundColor = [UIColor blackColor];
    self.payNowButton.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.stpCardTextField becomeFirstResponder];

    //[self disablePayButton];

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
-(TransferStepsViewController *)parentController {
    return (TransferStepsViewController *)self.stepsController;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.expiryDateTextField) {
        NSString *expDate = [self.expiryDateTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"" options:0 range:NSMakeRange(0, self.expiryDateTextField.text.length)];
        expDate = [expDate stringByReplacingOccurrencesOfString:@"/" withString:@"" options:0 range:NSMakeRange(0, expDate.length)];
        [self.stpCardTextField replaceField:@"expirationField" withValue:expDate];
    }
    else if (textField == self.cvvTextField) {
        [self.stpCardTextField replaceField:@"cvcField" withValue:self.cvvTextField.text];
    }
    if (self.stpCardTextField.isValid) {
        [self enablePayButton];
    }
    return YES;
}

- (IBAction)takePhoto_click:(UIButton *)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.stpCardTextField replaceField: @"numberField" withValue:info.cardNumber];
    self.expiryDateTextField.dateComponents.month = info.expiryMonth;
    self.expiryDateTextField.dateComponents.year = info.expiryYear;
    self.expiryDateTextField.text = [NSString stringWithFormat:@"%02lu/%lu", (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear % 2000];
    self.cvvTextField.text = info.cvv;
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)payNowButton_click:(UIButton *)sender {
    STPCardParams *cardParams = self.stpCardTextField.cardParams;
    cardParams.cvc = self.cvvTextField.text;
    cardParams.expMonth = self.expiryDateTextField.dateComponents.month;
    cardParams.expYear = self.expiryDateTextField.dateComponents.year;
    self.parentController.cardParams = cardParams;
    [self disablePayButton];
    [self.parentController payWithCreditCard:^(BOOL b) {
        [self enablePayButton];
    }];
}

- (IBAction)payWithPaypalButton_click:(UIButton *)sender {
    // todo
}
@end
