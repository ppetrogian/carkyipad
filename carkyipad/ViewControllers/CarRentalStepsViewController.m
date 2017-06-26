//
//  CarRentalStepsViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarRentalStepsViewController.h"
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
#import "CalendarRange.h"
#import "RefreshableViewController.h"
#import "ResetsForIdle.h"
#import "RequestRideViewController.h"
#define kSegmentHeight 50
#define kMaxIdleTimeSeconds 120

@interface CarRentalStepsViewController ()<StepDelegate, MBProgressHUDDelegate,ResetsForIdle>
@property(strong, nonatomic) RentalConfirmationView *confirmationView;
@end

@implementation CarRentalStepsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.stepsBar.barStyle = UIBarStyleBlack;
    self.stepsBar.backgroundColor = [UIColor blackColor];

    [self configureSegmentController];
    AppDelegate *app = [AppDelegate instance];
    app.idleTimer = [NSTimer scheduledTimerWithTimeInterval:kMaxIdleTimeSeconds target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
}

-(void) configureSegmentController{
    self.segmentController.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kSegmentHeight);
    [self.segmentController setAllSegmentList:@[NSLocalizedString(@"1. Details", nil), NSLocalizedString(@"2. Car", nil), NSLocalizedString(@"3. Extras", nil), NSLocalizedString(@"4. Payment", nil)]];
    [self.segmentController setSelectedSegmentIndex:0];
}


-(void)showAlertViewWithMessage:(NSString *)messageStr andTitle:(NSString *)titleStr {
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:titleStr  message: messageStr preferredStyle:UIAlertControllerStyleAlert];
    [myAlertController addAction: [self dismissAlertView_OKTapped:myAlertController withBlock:^(BOOL b) {}]];
    [self presentViewController:myAlertController animated:YES completion:nil];
}

-(void)showAlertViewWithMessage:(NSString *)messageStr andTitle:(NSString *)titleStr withBlock:(BlockBoolean)block {
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:titleStr  message: messageStr preferredStyle:UIAlertControllerStyleAlert];
    [myAlertController addAction: [self dismissAlertView_OKTapped:myAlertController withBlock:block]];
    [self presentViewController:myAlertController animated:YES completion:nil];
}

-(UIAlertAction *)dismissAlertView_OKTapped:(UIAlertController *)myAlertController withBlock:(BlockBoolean)block {
    return [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
        block(YES);
        [myAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(void)showRetryDialogViewWithMessage:(NSString *)messageStr andTitle:(NSString *)titleStr withBlockYes:(BlockBoolean)blockYes andBlockNo:(BlockBoolean)blockNo {
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:titleStr  message: messageStr preferredStyle:UIAlertControllerStyleAlert];
    [myAlertController addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
        blockYes(YES);
        [myAlertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [myAlertController addAction: [UIAlertAction actionWithTitle:NSLocalizedString(@"No", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * action)  {
        blockNo(NO);
        [myAlertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:myAlertController animated:YES completion:nil];
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
    
    // add client details, payment screen from transfer storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Transfer" bundle:nil];
    UITabBarController *tabbarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    
    return @[firstStep, secondStep, thirdStep, tabbarController.viewControllers[2], tabbarController.viewControllers[3]];
}

- (void)canceled {
    AppDelegate *app = [AppDelegate instance];
    [app.idleTimer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPreviousStep {
    [self.segmentController setSelectedSegmentIndex:self.segmentController.selectedIndex-1];
    [super showPreviousStep];
}

-(void)showNextStep {
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
    bookInfo.fleetLocationId = [AppDelegate instance].clientConfiguration.areaOfServiceId;
    bookInfo.commission = 0;
    bookInfo.carTypeId = ((NSNumber*)self.results[kResultsCarTypeId]).integerValue;
    bookInfo.extraIds = self.results[kResultsExtras];
    NSInteger carInsuranceId = ((NSNumber*)self.results[kResultsInsuranceId]).integerValue;
    if(carInsuranceId > 0)
        bookInfo.insuranceId = carInsuranceId;
    bookInfo.agreedToTermsAndConditions = YES;
    payInfo.paymentMethod = forCC ? 3 : 2; //3 credit card, paypal 2
    CalendarRange *range = self.results[kResultsDayRange];
    // pickup info
    NSInteger pickupWellKnownLocationId = ((NSNumber*)self.results[kResultsPickupLocationId]).integerValue;
    if(pickupWellKnownLocationId > 0)
        bookInfo.wellKnownPickupLocationId = pickupWellKnownLocationId;
    else {
        bookInfo.pickupLocation = self.selectedPickupLocation;
        bookInfo.pickupLocation.address = self.results[kResultsPickupLocationName];
    }
    bookInfo.pickupDateTime = [DateTime modelObjectWithDate:range.startDay.date];
    
    NSInteger dropoffWellKnownLocationId = ((NSNumber*)self.results[kResultsDropoffLocationId]).integerValue;
    if(dropoffWellKnownLocationId == 0) {
        // drop-off same as pickup
        bookInfo.wellKnownDropoffLocationId = bookInfo.wellKnownPickupLocationId;
        bookInfo.dropoffLocation = bookInfo.pickupLocation;
        bookInfo.dropoffLocation.address = bookInfo.pickupLocation.address;
    }
    else if(dropoffWellKnownLocationId > 0)
        bookInfo.wellKnownDropoffLocationId = dropoffWellKnownLocationId;
    else {
        // negative well-known locationId means custom location
        bookInfo.dropoffLocation = self.selectedDropoffLocation;
        bookInfo.dropoffLocation.address = self.results[kResultsDropoffLocationName];
    }
    bookInfo.dropoffDateTime = [DateTime modelObjectWithDate:range.endDay.date];
    return request;
}

-(void)payRentalWithPaypal:(NSString *)confirmationString andResponse:(NSDictionary *)confirmDict andBlock:(BlockBoolean)block  {
    RentalBookingRequest *request = [self getRentalRequestWithCC:NO];
    request.paymentInfo.payPalResponse = confirmationString;
    request.paymentInfo.payPalAuthorizationId = confirmDict[@"response"][@"authorization_id"];
    [self MakeRentalRequest:block request:request]; // create rental request
}

- (void)MakeRentalRequest:(BlockBoolean)block request:(RentalBookingRequest *)request {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [api CreateRentalBookingRequestForIpad:request withBlock:^(NSArray *array) {
        [[AppDelegate instance] hideProgressNotification];
        
        if ([array.firstObject isKindOfClass:RentalBookingResponse.class]) {
            RentalBookingResponse *responseObj = array.firstObject;
            if (responseObj.bookingInfo.reservationCode.length > 0) {
                block(YES);
                [self displayRentalConfirmationView:responseObj];
            } else {
                block(NO);
                [self showAlertViewWithMessage:@"Empty reservation code" andTitle:@"Error"];
            }
        }
        else {
            block(NO);
            [self showAlertViewWithMessage:array.firstObject andTitle:@"Error"];
        }
    }];
}

- (void)hudWasHidden {

}

-(void)hideKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - Confirmation View
-(void) displayRentalConfirmationView:(RentalBookingResponse *)response {
    [self hideKeyboard];
    self.confirmationView = [[[NSBundle mainBundle] loadNibNamed:@"RentalConfirmationView" owner:self options:nil] firstObject];
    self.confirmationView.frame = [UIScreen mainScreen].bounds;
    self.confirmationView.alpha = 0;
    self.confirmationView.pickupAddressLabel.text = response.bookingInfo.pickupAddress;
    self.confirmationView.dropoffAddressLabel.text = response.bookingInfo.dropoffAddress;
    self.confirmationView.pickupDateLabel.text = response.bookingInfo.pickupDate;
    self.confirmationView.dropoffDateLabel.text = response.bookingInfo.dropoffDate;
    self.confirmationView.pickupTimeLabel.text = response.bookingInfo.pickupTime;
    self.confirmationView.dropoffTimeLabel.text = response.bookingInfo.dropoffTime;
    // car type image view
    NSURL *urlCar = [NSURL URLWithString:response.bookingInfo.carImage];
    NSData *dataCar = [NSData dataWithContentsOfURL:urlCar];
    UIImage *imgCar = [[UIImage alloc] initWithData:dataCar];
    self.confirmationView.carTypeImageView.image = imgCar;
    //-----------
    self.confirmationView.nameLabel.text = response.bookingInfo.displayName;
    self.confirmationView.reservationLabel.text = response.bookingInfo.reservationCode;
    self.confirmationView.durationLabel.text = [NSString stringWithFormat:@"%.1lf days", response.bookingInfo.actualDurationInDays];
    //-------------------
     self.confirmationView.extrasPriceLabel.text = [NSString stringWithFormat:@"€%.2lf", response.bookingInfo.extrasPrice];
     self.confirmationView.extrasItemsLabel.text = response.bookingInfo.extrasDisplay;
     self.confirmationView.insurancePriceLabel.text = [NSString stringWithFormat:@"€%.2lf", response.bookingInfo.insurancePrice];
     self.confirmationView.insuranceItemsLabel.text = response.bookingInfo.insuranceDisplay;
     self.confirmationView.carPriceLabel.text = [NSString stringWithFormat:@"€%.2lf", response.bookingInfo.carPrice];
     self.confirmationView.totalPriceLabel.text = [NSString stringWithFormat:@"€%.2lf", response.bookingInfo.total];
    self.confirmationView.carTypeNameLabel.text = response.bookingInfo.carDisplay;
    [self.confirmationView.carTypeNameLabel sizeToFit];
    [self.confirmationView.bookingNewBtn addTarget:self action:@selector(bookingNew_Click:) forControlEvents:UIControlEventTouchUpInside];
    //confiramtionView.delegate = self;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.window addSubview:self.confirmationView];
    [UIView animateWithDuration:0.3 animations:^{
        self.confirmationView.alpha = 1.0;
    } completion:^(BOOL finished) {}];
    [self performSelector:@selector(bookingNew_Click:) withObject:self.confirmationView.bookingNewBtn afterDelay:20.0];
}

- (void)bookingNew_Click:(UIButton*)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(bookingNew_Click:) object:self.confirmationView.bookingNewBtn];
    AppDelegate *app = [AppDelegate instance];
    [app loadInitialControllerForMode:app.clientConfiguration.tabletMode];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)payRentalWithCreditCard:(BlockBoolean)block {
    RentalBookingRequest *request = [self getRentalRequestWithCC:YES];
    request.paymentInfo.stripeCardToken = self.stripeCardToken;
    [self MakeRentalRequest:block request:request]; // create rental request
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

- (void)stepsBarDidSelectCancelButton:(RMStepsBar *)bar {
    [self canceled];
}

- (void)stepsBar:(RMStepsBar *)bar shouldSelectStepAtIndex:(NSInteger)index {
    
}

#pragma mark -
#pragma mark Handling idle timeout

-(void)resetForIdleTimer {
    if ([self.childViewControllers[0] isKindOfClass:RequestRideViewController.class]) {
        // clear gmap resources
        RequestRideViewController *rrvc = self.childViewControllers[0];
        GMSMapView *mapView = rrvc.mapView;
        [mapView clear] ;
        [mapView removeFromSuperview];
    }
    if ([self.currentStepViewController conformsToProtocol:@protocol(ResetsForIdle)]) {
        id<ResetsForIdle> rvc = (id<ResetsForIdle>)self.currentStepViewController;
        [rvc resetForIdleTimer];
    }
    AppDelegate *app = [AppDelegate instance];
    [self dismissViewControllerAnimated:NO completion:nil];
    [app loadInitialControllerForMode:app.clientConfiguration.tabletMode];
}

- (void)resetIdleTimer {
    AppDelegate *app = [AppDelegate instance];
    if (!app.idleTimer) {
        app.idleTimer = [NSTimer scheduledTimerWithTimeInterval:kMaxIdleTimeSeconds target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];
    }
    else {
        if (fabs([app.idleTimer.fireDate timeIntervalSinceNow]) < kMaxIdleTimeSeconds-1.0)
            [app.idleTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:kMaxIdleTimeSeconds]];
    }
}

- (void)idleTimerExceeded {
    AppDelegate *app = [AppDelegate instance];
    NSLog(@"Exceeded timer for class %@", self.class);
    [app.idleTimer invalidate];
    [self resetForIdleTimer];
}

- (UIResponder *)nextResponder {
    [self resetIdleTimer];
    return [super nextResponder];
}

@end
