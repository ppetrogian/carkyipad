//
//  CarRentalStepsViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarRentalStepsViewController.h"
#import "PSStepButton.h"
#import "CircleLineButton.h"
#import "StepViewController.h"
#import "AppDelegate.h"
#import "DetailsStepViewController.h"
#import "RentalConfirmationView.h"
#import "CarStepViewController.h"
#import "ShadowViewWithText.h"
#import "CarExtrasViewController.h"
#import "StepViewController.h"
#import "RentalBookingResponse.h"
#import <Stripe/Stripe.h>

@interface CarRentalStepsViewController ()<StepDelegate>

@end

@implementation CarRentalStepsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.stepsBar.barStyle = UIBarStyleBlack;
    self.stepsBar.backgroundColor = [UIColor blackColor];
    
    for (NSInteger i = 0; i < self.stepViewControllers.count; i++) {
        RMStep *step = [self stepsBar:self.stepsBar stepAtIndex:i];
        step.stepView = (CircleLineButton *)self.stepButtonsStack.arrangedSubviews[i];
        step.titleLabel = (UILabel *)self.stepLabelsStack.arrangedSubviews[i];
        step.titleLabel.text = step.title;
        step.stepView.enabled = i == 0;
    }

    [self configureSegmentController];
}
-(void) configureSegmentController{
    self.segmentController.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
    [self.segmentController setAllSegmentList:@[NSLocalizedString(@"1. Details", nil), NSLocalizedString(@"2. Car", nil), NSLocalizedString(@"3. Extras", nil), NSLocalizedString(@"4. Payment", nil)]];
    [self.segmentController setSelectedSegmentIndex:0];
}


-(void)showAlertViewWithMessage:(NSString *)messageStr andTitle:(NSString *)titleStr {
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:titleStr  message: messageStr preferredStyle:UIAlertControllerStyleAlert];
    [myAlertController addAction: [self dismissAlertView_OKTapped:myAlertController]];
    [self presentViewController:myAlertController animated:YES completion:nil];
}

-(UIAlertAction *)dismissAlertView_OKTapped:(UIAlertController *)myAlertController {
    return [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
        [myAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
}
#pragma mark -
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfStepsInStepsBar:(RMStepsBar *)bar {
    return 4;
}

- (NSArray *)stepViewControllers {
    StepViewController *firstStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
    firstStep.step.title = NSLocalizedString(@"Details", nil) ;
    firstStep.stepDelegate = self;
    StepViewController *secondStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Car"];
    secondStep.step.title =  NSLocalizedString(@"Car", nil);
    secondStep.stepDelegate = self;
    
    StepViewController *thirdStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Extras"];
    thirdStep.step.title =  NSLocalizedString(@"Extras", nil);
    thirdStep.stepDelegate = self;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Transfer" bundle:nil];
    UITabBarController *tabbarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    
    StepViewController *vc4 = [self.storyboard instantiateViewControllerWithIdentifier:@"Payment"];
    vc4.stepDelegate = self;
    
    return @[firstStep, secondStep, thirdStep, tabbarController.viewControllers[1], tabbarController.viewControllers[2]];
}

- (void)finishedAllSteps {
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {        
    }];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Wizard finish",nil) message:NSLocalizedString(@"Payment done", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:actionYes];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPreviousStep {
    if ([self.currentStepViewController isKindOfClass:CarStepViewController.class]) {
        self.totalView.hidden = YES;
    }
    [self.segmentController setSelectedSegmentIndex:self.segmentController.selectedIndex-1];
    [super showPreviousStep];
}

-(void)showNextStep {
    if ([self.currentStepViewController isKindOfClass:DetailsStepViewController.class]) {
        self.totalView.hidden = YES;
        CarStepViewController *carVc = self.childViewControllers[self.currentStepIndex + 1];
        [carVc prepareCarStep];
    } else if ([self.currentStepViewController isKindOfClass:CarStepViewController.class]) {
        CarExtrasViewController *carExtrasVc = self.childViewControllers[self.currentStepIndex + 1];
        [carExtrasVc prepareCarStep];
    }
    [self.segmentController setSelectedSegmentIndex:self.segmentController.selectedIndex+1];
    [super showNextStep];
    
}

-(RentalBookingRequest *)getRentalRequestWithCC:(BOOL)forCC {
    RentalBookingRequest *request = [RentalBookingRequest new];
    request.clientUserId = self.userId;
    BookingInfo *bookInfo = [BookingInfo new];
    PaymentInfo *payInfo = [PaymentInfo new];
    request.bookingInfo = bookInfo;
    request.paymentInfo = payInfo;
    //bookInfo.fleetLocationId = [AppDelegate instance].clientConfiguration.areaOfServiceId;
    bookInfo.commission = 0;
    bookInfo.carTypeId = ((NSNumber*)self.results[kResultsCarTypeId]).integerValue;
    bookInfo.extraIds = self.results[kResultsExtras];
    bookInfo.insuranceId = ((NSNumber*)self.results[kResultsInsuranceId]).integerValue;

    bookInfo.agreedToTermsAndConditions = YES;
    payInfo.paymentMethod = forCC ? 3 : 2; //3 credit card, paypal 2
    DSLCalendarRange *range = self.results[kResultsDayRange];
    // pickup info
    NSInteger pickupWellKnownLocationId = ((NSNumber*)self.results[kResultsPickupLocationId]).integerValue;
    if(pickupWellKnownLocationId > 0)
        bookInfo.wellKnownPickupLocationId = pickupWellKnownLocationId;
    else
        bookInfo.pickupLocation = self.selectedPickupLocation;
    bookInfo.pickupLocation.address = self.results[kResultsPickupLocationName];
    bookInfo.pickupDateTime = [DateTime modelObjectWithDate:range.startDay.date];
    
    NSInteger dropoffWellKnownLocationId = ((NSNumber*)self.results[kResultsDropoffLocationId]).integerValue;
    if(dropoffWellKnownLocationId == 0) {
        bookInfo.wellKnownDropoffLocationId = bookInfo.wellKnownPickupLocationId;
        bookInfo.dropoffLocation = bookInfo.pickupLocation;
    }
    else if(dropoffWellKnownLocationId > 0)
        bookInfo.wellKnownDropoffLocationId = dropoffWellKnownLocationId;
    else
        bookInfo.dropoffLocation = self.selectedDropoffLocation;
    bookInfo.dropoffLocation.address = self.results[kResultsDropoffLocationName];
    bookInfo.dropoffDateTime = [DateTime modelObjectWithDate:range.endDay.date];
    return request;
}

- (void)MakeRentalRequest:(BlockBoolean)block request:(RentalBookingRequest *)request {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    MBProgressHUD *hud = [AppDelegate showProgressNotification:nil withText:@"Waiting confirmation..."];
    [api CreateRentalBookingRequest:request withBlock:^(NSArray *array) {
        [AppDelegate hideProgressNotification:hud];
        
        if ([array.firstObject isKindOfClass:RentalBookingResponse.class]) {
            RentalBookingResponse *responseObj = array.firstObject;
            if (responseObj.reservationCode.length > 0) {
                block(YES);
                [self displayRentalConfirmationView:responseObj];
            } else {
                block(NO);
                [self showAlertViewWithMessage:@"Empty reservation code" andTitle:@"Error"];
            }
        } else {
            block(NO);
            [self showAlertViewWithMessage:array.firstObject andTitle:@"Error"];
        }
    }];
}

-(void)hideKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - Confirmation View
-(void) displayRentalConfirmationView:(RentalBookingResponse *)response {
    [self hideKeyboard];
    RentalConfirmationView *confirmationView = [[[NSBundle mainBundle] loadNibNamed:@"RentalConfirmationView" owner:self options:nil] firstObject];
    confirmationView.frame = [UIScreen mainScreen].bounds;
    confirmationView.alpha = 0;
    confirmationView.pickupAddressLabel.text = response.pickupAddress;
    confirmationView.dropoffAddressLabel.text = response.dropoffAddress;
    confirmationView.pickupDateLabel.text = response.pickupDate;
    confirmationView.dropoffDateLabel.text = response.dropoffDate;
    confirmationView.pickupTimeLabel.text = response.pickupTime;
    confirmationView.dropoffTimeLabel.text = response.dropoffTime;
    //-----------
    confirmationView.nameLabel.text = response.displayName;
    confirmationView.reservationLabel.text = response.reservationCode;
    NSInteger nDays = ((NSNumber*)self.results[kResultsDays]).integerValue;
    confirmationView.durationLabel.text = [NSString stringWithFormat:@"%zd days",nDays];
    //-------------------
     confirmationView.extrasPriceLabel.text = [NSString stringWithFormat:@"€%zd", response.extrasPrice];
     confirmationView.extrasItemsLabel.text = response.extrasDisplay;
     confirmationView.insurancePriceLabel.text = [NSString stringWithFormat:@"€%zd", response.insurancePrice];
     confirmationView.insuranceItemsLabel.text = response.insuranceDisplay;
     confirmationView.carPriceLabel.text = [NSString stringWithFormat:@"€%zd", response.carPrice];
     confirmationView.totalPriceLabel.text = [NSString stringWithFormat:@"€%zd", response.total];
    //confiramtionView.delegate = self;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:confirmationView];
    [UIView animateWithDuration:0.3 animations:^{
        confirmationView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)payRentalWithCreditCard:(BlockBoolean)block {
    // send payment to back end
    STPAPIClient *stpClient = [STPAPIClient sharedClient];
    
    [stpClient createTokenWithCard:self.cardParams completion:^(STPToken *token, NSError *error) {
        if (error) {
            NSString *strDescr = [NSString stringWithFormat: @"Credit card error: %@", error.localizedDescription];
            [self showAlertViewWithMessage:strDescr andTitle:@"Error"];
            return;
        }
        RentalBookingRequest *request = [self getRentalRequestWithCC:YES];
        request.paymentInfo.stripeCardToken = token.tokenId;
        [self MakeRentalRequest:block request:request]; // create rental request
        block(YES);
    }]; // create token
}

- (IBAction)gotoBack:(id)sender {
    [self showPreviousStep];
}
- (IBAction)gotoNext:(id)sender {
    [self showNextStep];
}
#pragma mark - Step Delegate
-(void) didSelectedNext:(UIButton *)sender{
    [self showNextStep];
}
-(void) didSelectedBack:(UIButton *)sender{
    [self showPreviousStep];
}
@end
