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
#import "TermsAndConditionsViewController.h"
#import "ButtonUtils.h"
#import "PayPalMobile.h"

@interface PaymentForTaxiViewController () <CardIOPaymentViewControllerDelegate, STPPaymentCardTextFieldDelegate, PayPalPaymentDelegate, UITextFieldDelegate>
@property (nonatomic, readonly, weak) TransferStepsViewController *parentController;
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@end

@implementation PaymentForTaxiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.stpCardTextField becomeFirstResponder];

    //[self disablePayButton];
    [self.stpCardTextField replaceField:@"numberField" withValue:@"4242424242424242"];
    self.stpCardTextField.borderColor = UIColor.blackColor;
    self.stpCardTextField.borderWidth = 1;
    
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
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
}

-(void)viewDidAppear:(BOOL)animated {
    NSInteger price = self.parentController.selectedCarCategory.price;
    [self.payNowButton setTitle:[NSString stringWithFormat:@"PAY NOW       %ld€", price] forState: UIControlStateNormal];
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
        [self.payNowButton enableButton];
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
    [self.payNowButton disableButton];
    [self.parentController payWithCreditCard:^(BOOL b) {
        [self.payNowButton enableButton];
    }];
}
- (IBAction)agreeWithTermsButton_Click:(id)sender {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api FetchTerms:@"en-US" withBlock:^(NSString *string) {
        [self performSegueWithIdentifier:@"termsSegue" sender:string];
    }];
}

- (IBAction)backButton_Click:(id)sender {
    [self.parentController showPreviousStep];
}

- (IBAction)payWithPaypalButton_click:(UIButton *)sender {
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    NSInteger price = self.parentController.selectedCarCategory.price;
    payment.amount = [[NSDecimalNumber alloc] initWithInt:(int)price];
    payment.currencyCode = @"EUR";
    payment.shortDescription = [NSString stringWithFormat:@"Transfer to %@", self.parentController.selectedLocation.name];
    
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
    } else {
        // Create a PayPalPaymentViewController.
        PayPalPaymentViewController *paymentViewController;
        paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment configuration:self.payPalConfiguration delegate:self];
        
        // Present the PayPalPaymentViewController.
        [self presentViewController:paymentViewController animated:YES completion:nil];
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
}
    
- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
        // Send the entire confirmation dictionary
    //NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation  options:0 error:nil];
        
        // Send confirmation to your server; your server should verify the proof of payment
        // and give the user their goods or services. If the server is not reachable, save
        // the confirmation and try again later.
    NSLog(@"%@", completedPayment.confirmation);
    
    [self.parentController payWithPaypal:completedPayment.confirmation];
}
    
@end
