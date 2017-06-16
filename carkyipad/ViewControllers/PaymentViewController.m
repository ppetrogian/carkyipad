//
//  PaymentViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 24/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PaymentViewController.h"
#import <Stripe/Stripe.h>
#import "TransferStepsViewController.h"
#import "CarRentalStepsViewController.h"
#import "CarkyApiClient.h"
#import "AppDelegate.h"
#import "DataModels.h"
#import "CardIO.h"
#import "BKCardExpiryField.h"
#import "PaymentCardEditorField.h"
#import "TermsAndConditionsViewController.h"
#import "ButtonUtils.h"
#import "PayPalMobile.h"
#import "RentalConfirmationView.h"

@interface PaymentViewController () <CardIOPaymentViewControllerDelegate, STPPaymentCardTextFieldDelegate, PayPalPaymentDelegate, UITextFieldDelegate>
@property (nonatomic, readonly, weak) CarRentalStepsViewController *parentRentalController;
@property (nonatomic, readonly, weak) TransferStepsViewController *parentTransferController;
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@property (nonatomic, assign) BOOL isForTransfer;
@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.stpCardTextField becomeFirstResponder];
    AppDelegate *app = [AppDelegate instance];
    //[self disablePayButton];
    self.stpCardTextField.borderColor = UIColor.blackColor;
    self.stpCardTextField.borderWidth = 1;
    self.isForTransfer = [self.stepsController isKindOfClass:TransferStepsViewController.class];
    CarkyBackendType bt = (CarkyBackendType)app.environment;
    if (bt == CarkyBackendTypeStage || bt == CarkyBackendTypeLive) {
        self.cvvTextField.text = @"";
        self.expiryDateTextField.text = @"";
        [self.payNowButton disableButton];
    } else {
        [self.stpCardTextField replaceField:@"numberField" withValue:@"4242424242424242"];
        [self.payNowButton enableButton];
    }
    TabletMode tm = (TabletMode)[AppDelegate instance].clientConfiguration.tabletMode;
    if(tm == TabletModeReception && self.isForTransfer) { //acceptsCash
        self.payWithCashButton.hidden = NO;
        [self.payWithCashButton enableButton];
        self.payWithCashButton.backgroundColor = [UIColor blueColor];
        //self.payWithCashButton.titleLabel.textColor = [UIColor blackColor];
    }
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        // See PayPalConfiguration.h for details and default values.
        // Should you wish to change any of the values, you can do so here.
        // For example, if you wish to accept PayPal but not payment card payments, then add:
        _payPalConfiguration.acceptCreditCards = NO;
        // Or if you wish to have the user choose a Shipping Address from those already
        // associated with the user's PayPal account, then add:
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionNone;
        _payPalConfiguration.rememberUser = NO;
    }
    self.cvvTextField.delegate = self;
    return self;
}

- (void)validateCardDetails {
    double price = [self getTotalPrice];
    if (price <= 0) {
        return;
    }
    STPCardParams *card = [self getCardParamsFromUI];
    BOOL mustEnable = [STPCardValidator validationStateForCard:card] == STPCardValidationStateValid;
    if (!mustEnable && self.payNowButton.isEnabled) {
        [self.payNowButton disableButton];
    }
    else if(mustEnable && !self.payNowButton.isEnabled) {
        [self.payNowButton enableButton];
    }
}

- (void)paymentCardTextFieldDidChange:(nonnull STPPaymentCardTextField *)textField {
    [self validateCardDetails];
}

- (IBAction)expiryDate_edit:(UITextField *)sender {
    [self validateCardDetails];
}
- (IBAction)cvv_edit:(UITextField *)sender {
    [self validateCardDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    // Start out working with the test! When you are ready, switch to PayPalEnvironmentProduction.
    if ([[AppDelegate instance].clientConfiguration.payPalMode caseInsensitiveCompare:@"sandbox"] == NSOrderedSame) {
        [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
    } else {
        [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
    }
}

-(double)getTotalPrice {
    double price = self.isForTransfer ? (double)self.parentTransferController.selectedCarCategory.price : ((NSNumber*)self.parentRentalController.results[kResultsTotalPrice]).doubleValue;
    return price;
}

-(void)viewDidAppear:(BOOL)animated {
    double price = [self getTotalPrice];
    NSString *strText = [NSString stringWithFormat:@"PAY NOW       %.2lf€", price];
    [self.payNowButton setTitle:strText forState: UIControlStateNormal];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"termsSegue"]) {
        TermsAndConditionsViewController *termsVc = (TermsAndConditionsViewController *)segue.destinationViewController;
        termsVc.terms = (NSString *)sender;
    }
}

-(CarRentalStepsViewController *)parentRentalController {
    return (CarRentalStepsViewController *)self.stepsController;
}

-(TransferStepsViewController *)parentTransferController {
    return (TransferStepsViewController *)self.stepsController;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.cvvTextField == textField) {
        // Prevent crashing undo bug
        if(range.length + range.location > textField.text.length) {
            return NO;
        }
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 3;
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
    [self.payNowButton enableButton];
    [self.stpCardTextField replaceField: @"numberField" withValue:info.cardNumber];
    self.expiryDateTextField.dateComponents.month = info.expiryMonth;
    self.expiryDateTextField.dateComponents.year = info.expiryYear;
    self.expiryDateTextField.text = [NSString stringWithFormat:@"%02lu/%lu", (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear % 2000];
    self.cvvTextField.text = info.cvv;
    [self validateCardDetails];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.payNowButton enableButton];
    [self validateCardDetails];
}

- (STPCardParams *)getCardParamsFromUI {
    STPCardParams *cardParams = self.stpCardTextField.cardParams;
    cardParams.cvc = self.cvvTextField.text;
    cardParams.expMonth = self.expiryDateTextField.dateComponents.month;
    cardParams.expYear = self.expiryDateTextField.dateComponents.year;
    return cardParams;
}

- (IBAction)payWithCashButton_Click:(UIButton *)sender {
    // only for transfer
    [self.payWithCashButton disableButton];
    if (self.isForTransfer) {
        self.parentTransferController.payWithCash = YES;
    }
    [[AppDelegate instance] showProgressNotificationWithText:nil inView:self.view];
    [self.parentTransferController showNextStep];
    [[AppDelegate instance] hideProgressNotification];
    [self.payWithCashButton enableButton];
    self.payWithCashButton.backgroundColor = [UIColor blueColor];
    //self.payWithCashButton.titleLabel.textColor = [UIColor blackColor];
}

- (IBAction)payNowButton_click:(UIButton *)sender {
    [self.payNowButton disableButton];
    [[AppDelegate instance] showProgressNotificationWithText:NSLocalizedString(@"Card Validation", nil) inView:self.view];
    if (self.isForTransfer) {
        self.parentTransferController.payWithCash = NO;
    }
    STPCardParams *cardParams;
    cardParams = [self getCardParamsFromUI];
    self.parentTransferController.cardParams = cardParams;
    self.parentRentalController.cardParams = cardParams;
    // send payment to back end
    STPAPIClient *stpClient = [STPAPIClient sharedClient];
    [stpClient createTokenWithCard:self.parentTransferController.cardParams completion:^(STPToken *token, NSError *error) {
        [[AppDelegate instance] hideProgressNotification];
        if (error) {
            NSString *strDescr = [NSString stringWithFormat: @"Credit card error: %@", error.localizedDescription];
            [self.parentTransferController showAlertViewWithMessage:strDescr andTitle:@"Error"];
            return;
        }
        // is for transfer or for rental payment
        if (self.isForTransfer) {
            self.parentTransferController.stripeCardToken = token.tokenId;
            [self.payNowButton enableButton];
            [self.parentTransferController showNextStep];
        }
        else {
            [[AppDelegate instance] showProgressNotificationWithText:NSLocalizedString(@"Requesting", nil) inView:self.view];
            self.parentRentalController.stripeCardToken = token.tokenId;
            [self.parentRentalController payRentalWithCreditCard:^(BOOL b) {
                [self.payNowButton enableButton];
                [[AppDelegate instance] hideProgressNotification]; }];
        }
    }];
}
- (IBAction)agreeWithTermsButton_Click:(id)sender {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api FetchTerms:@"en-US" withBlock:^(NSString *string) {
        [self performSegueWithIdentifier:@"termsSegue" sender:string];
    }];
}

- (IBAction)backButton_Click:(id)sender {
    [self.parentRentalController showPreviousStep];
}

- (void)showPaypalUIforPayment:(PayPalPayment *)payment {
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture.
    // To perform Authorization only, and defer Capture to your server,
    // use PayPalPaymentIntentAuthorize.
    // To place an Order, and defer both Authorization and Capture to
    // your server, use PayPalPaymentIntentOrder.
    // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
    payment.intent = PayPalPaymentIntentAuthorize;
    // If your app collects Shipping Address information from the customer,
    // or already stores that information on your server, you may provide it here.
    //payment.shippingAddress = address; // a previously-created PayPalShippingAddress object
    
    // Several other optional fields that you can set here are documented in PayPalPayment.h,
    // including paymentDetails, items, invoiceNumber, custom, softDescriptor, etc.
    
    // Check whether payment is processable.
    if (!payment.processable) {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
        NSLog(@"Error payment not processable");
        [self.parentRentalController showAlertViewWithMessage:@"Error" andTitle:@"PayPal Payment is not processable"];
    } else {
        // Create a PayPalPaymentViewController.
        PayPalPaymentViewController *paymentViewController;
        paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfiguration delegate:self];
        
        // Present the PayPalPaymentViewController.
        [self presentViewController:paymentViewController animated:YES completion:nil];
    }
}

- (IBAction)payWithPaypalButton_click:(UIButton *)sender {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    if (self.isForTransfer) {
        TransferBookingRequest *request = [self.parentTransferController getPaymentRequestWithCC:NO orWithCash:NO];
        [api CreateTransferBookingRequestPayPalPayment:request withBlock:^(NSArray *array) {
            CreateTransferBookingRequestPayPalPaymentResponse *responseObj = array.firstObject;
            // Create a PayPalPayment
            PayPalPayment *payment = [[PayPalPayment alloc] init];
            // Amount, currency, and description
            payment.amount = [[NSDecimalNumber alloc] initWithString:responseObj.amount];
            payment.currencyCode = responseObj.currency;
            payment.shortDescription = responseObj.internalBaseClassDescription;
            [self showPaypalUIforPayment:payment];
        }];
    }
    else {
        RentalBookingRequest *request = [self.parentRentalController getRentalRequestWithCC:NO];
        [api RentalChargesForIpad:request withBlock:^(NSArray *array) {
            ChargesForIPadResponse *chargesResponse = array.firstObject;
            // Create a PayPalPayment
            PayPalPayment *payment = [[PayPalPayment alloc] init];
            // Amount, currency, and description
            NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
            [fmt setPositiveFormat:@"0.##"];
            payment.amount = [[NSDecimalNumber alloc] initWithString:[fmt stringFromNumber:[NSNumber numberWithFloat:chargesResponse.total]]];
            payment.currencyCode = chargesResponse.currency;
            payment.shortDescription = chargesResponse.chargesDescription;
            [self showPaypalUIforPayment:payment];
        }];
    }
}
    
#pragma mark - PayPalPaymentDelegate methods
    
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.payNowButton enableButton];
}

- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
        // Send the entire confirmation dictionary
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation  options:0 error:nil];
    NSString* newStr = [[NSString alloc] initWithData:confirmation encoding:NSUTF8StringEncoding];
    
        // Send confirmation to your server; your server should verify the proof of payment
        // and give the user their goods or services. If the server is not reachable, save
        // the confirmation and try again later.
    NSLog(@"%@", completedPayment.confirmation);
    if (self.isForTransfer) {
        // go to next page and call service from there
        self.parentTransferController.payPalPaymentResponse = newStr;
        [self.parentTransferController showNextStep];
    }
    else {
        [[AppDelegate instance] showProgressNotificationWithText:@"Requesting" inView:self.view];
        [self.parentRentalController payRentalWithPaypal:newStr andResponse:completedPayment.confirmation andBlock:^(BOOL b) {
            [self.payNowButton enableButton];
            [[AppDelegate instance] hideProgressNotification];
        }];
    }
}


@end
