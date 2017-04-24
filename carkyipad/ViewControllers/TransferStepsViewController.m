//
//  TransferStepsViewController
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "TransferStepsViewController.h"
#import "CarkyApiClient.h"
#import "AppDelegate.h"
#import "DataModels.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "TGRArrayDataSource.h"
#import "CountryPhoneCodeVC.h"
#import "SharedInstance.h"
#import "CardIO.h"
#import <Stripe/Stripe.h>
#import <Bolts/Bolts.h>

#define baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
NSString * const URLDirectionsFmt = @"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false";

@interface TransferStepsViewController () <CLLocationManagerDelegate, CardIOPaymentViewControllerDelegate, STPPaymentCardTextFieldDelegate, SelectDelegate, UITextFieldDelegate, UITableViewDelegate>
@property (nonatomic, strong) LatLng* userPos;

@property (nonatomic, assign) NSInteger userFleetLocationId;
@property (nonatomic, strong) GMSPolyline *polyline;
@property (nonatomic,strong) TGRArrayDataSource* wellKnownLocationsDataSource;
@property (nonatomic, strong) NSMutableArray *locationMarkers;
@property (nonatomic, strong) NSMutableArray *driverMarkers;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectedCarTypes;
@property (nonatomic,strong) TGRArrayDataSource* carCategoriesDataSource;
@property (nonatomic, assign) NSInteger totalPrice;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) UIControl *activeField;
@end

@implementation TransferStepsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];

    [AppDelegate configurePSTextField:self.fromLocationTextField withColor:[UIColor whiteColor]];
    [AppDelegate configurePSTextField:self.toLocationTextField withColor:[UIColor whiteColor]];
    self.toLocationTextField.delegate = self;
    // set wizard frames
    self.viewFindDrivers.frame = self.locationsTableView.frame;
    self.paymentsScrollView.frame = self.locationsTableView.frame;
    self.paymentDoneView.frame = self.locationsTableView.frame;
    [self.view bringSubviewToFront:self.locationsTableView];
   
    // configure payment controls
    [AppDelegate configurePSTextField:self.firstNameTextField withColor:[UIColor lightGrayColor]];
    [AppDelegate configurePSTextField:self.lastNameTextField withColor:[UIColor lightGrayColor]];
    [AppDelegate configurePSTextField:self.emailTextField withColor:[UIColor lightGrayColor]];
    [AppDelegate configurePSTextField:self.confirmEmailTextField withColor:[UIColor lightGrayColor]];

    self.creditCardNumberTextField.borderStyle = UITextBorderStyleNone;
    self.expiryDateTextField.borderStyle = UITextBorderStyleNone;
    self.cvvTextField.borderStyle = UITextBorderStyleNone;
    self.phoneNumberTextField.borderStyle = UITextBorderStyleNone;
    self.creditCardButton.layer.borderColor = self.creditCardButton.tintColor.CGColor;
    self.cashButton.layer.borderColor = self.cashButton.tintColor.CGColor;
    self.stpCardTextField.borderColor = nil;
    self.selectedCarTypes = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0)]];
  
    [CardIOUtilities preload];
}

-(void)getWellKnownLocations:(NSInteger)locationId forMap:(GMSMapView *)mapView {
    NSDictionary *posDict = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserDefaultLocation"];
    self.fromLocationTextField.text = posDict[@"Name"];
    _userPos = [LatLng modelObjectWithDictionary:posDict];
    Location *cl = [Location new]; cl.identifier = -1; cl.name = @"Current location"; cl.latLng = self.userPos;
    self.currentLocation = cl;
    mapView.mapType = kGMSTypeNormal;
    mapView.settings.myLocationButton = YES;
    mapView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    // todo: remove from here
    CarkyApiClient *api = [CarkyApiClient sharedService];
     // ((NSNumber *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserFleetLocationId"]).integerValue;
    [api GetWellKnownLocations:locationId withBlock:^(NSArray<Location *> *array) {
        [AppDelegate instance].wellKnownLocations = array;
        [self loadLocations:nil];
        
        self.locationMarkers = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(Location * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(obj.latLng.lat,obj.latLng.lng);
            marker.icon = [UIImage imageNamed:@"point-1"];
            marker.userData = obj;
            marker.title = @""; // obj.name;
            marker.tappable = YES;
            marker.map = mapView;
            [self.locationMarkers addObject:marker];
        }];
    }];
    CLLocationCoordinate2D userCoord = CLLocationCoordinate2DMake(_userPos.lat, _userPos.lng);
    mapView.camera = [GMSCameraPosition cameraWithTarget:userCoord zoom: 13.0];
}

-(void)loadLocations:(NSString *)filter {
    AppDelegate *app = [AppDelegate instance];
    NSMutableArray *wklList = [NSMutableArray arrayWithCapacity:app.wellKnownLocations.count+2];
    
    [wklList addObject:self.currentLocation];
    if (filter == nil || filter.length == 0) {
        [wklList addObjectsFromArray:app.wellKnownLocations];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", filter];
        [wklList addObjectsFromArray:[app.wellKnownLocations filteredArrayUsingPredicate:predicate]];
    }
    self.locationsTableView.backgroundColor = self.view.backgroundColor;
    
    self.wellKnownLocationsDataSource = [[TGRArrayDataSource alloc] initWithItems:[wklList copy] cellReuseIdentifier:@"locationCell" configureCellBlock:^(UITableViewCell *cell, Location *item) {
        cell.contentView.backgroundColor = self.view.backgroundColor;
        UIImageView *imageView = [cell.contentView viewWithTag:1];
        imageView.image = [UIImage imageNamed:@"locationPin"];
        if ([item.name rangeOfString:@"Airport"].location != NSNotFound) {
            imageView.image = [UIImage imageNamed:@"airlplane"];
        } else if(item.identifier == -1) {
            imageView.image = [UIImage imageNamed:@"CurrLocation"];
        }
        UILabel *label = [cell.contentView viewWithTag:2];
        label.text = item.name;
    }];
    self.locationsTableView.dataSource = self.wellKnownLocationsDataSource;
    self.locationsTableView.delegate = self;
    
    [self.locationsTableView reloadData];
}
#pragma mark - delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.toLocationTextField) {
        textField.text = @"";
        [self loadLocations:nil];
        [self.view bringSubviewToFront:self.locationsTableView];
    } else {
        self.activeField = textField;
    }
}


- (IBAction)toLocationTextChanged:(UITextField *)textField {
    [self loadLocations:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    TGRArrayDataSource *dataSource = (TGRArrayDataSource *)self.locationsTableView.dataSource;
    NSArray<Location*> *locations = dataSource.items;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",textField.text];
    return [locations filteredArrayUsingPredicate:predicate].count > 0 ? YES : NO;
}

- (void) didSelectLocation:(NSInteger)identifier withValue:(id)value andText:(NSString *)t forMap:(GMSMapView *)mapView {
    self.selectedLocation = (Location *)value;
    self.toLocationTextField.text = self.selectedLocation.name;
    [self.locationMarkers enumerateObjectsUsingBlock:^(GMSMarker *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userData == self.selectedLocation) {
            mapView.selectedMarker = obj;
        }
    }];
    [self getDirectionsFrom:self.userPos to:self.selectedLocation.latLng forMap:mapView];
    [self.toLocationTextField resignFirstResponder];

    //[self.view bringSubviewToFront:self.viewFindDrivers];
}

- (void) didSelectCarCategory:(NSInteger)identifier withValue:(id)value andText:(NSString *)text forMap:(GMSMapView *)mapView  {
    CarkyDriverPositionsRequest *req = [self getDriversRequest:identifier];
    CarkyApiClient *api = [CarkyApiClient sharedService];
    self.selectedCarCategory = value;
    self.totalPrice = self.selectedCarCategory.price;

    [self.driverMarkers enumerateObjectsUsingBlock:^(GMSMarker *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.map = nil;
    }];
    [api FindNearestCarkyDriverPositions:req withBlock:^(NSArray<CarkyDriverPositionsResponse*> *array) {
        self.driverMarkers = [NSMutableArray arrayWithCapacity:array.count];
         [array enumerateObjectsUsingBlock:^(CarkyDriverPositionsResponse * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(obj.latLng.lat,obj.latLng.lng);
            marker.icon = [UIImage imageNamed:@"car copy 3"];
            marker.userData = obj;
             marker.map = mapView;
            //marker.title = obj.d
             [self.driverMarkers addObject:marker];
        }];
    }];
}


-(CarkyDriverPositionsRequest *)getDriversRequest:(NSInteger)carCategory {
    CarkyDriverPositionsRequest *request = [CarkyDriverPositionsRequest new];
    request.carkyCategoryId = carCategory;
    request.position = self.userPos;
    return request;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 
 }
#pragma mark - Hide Keyboard
-(void)addGestureToView{
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    self.tap.enabled = NO;
    [self.view addGestureRecognizer:self.tap];
}
-(void)hideKeyboard{
    [self.view endEditing:YES];
    _tap.enabled = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // keyboard
    [self registerForKeyboardNotifications];
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _paymentsScrollView.contentInset = contentInsets;
    _paymentsScrollView.scrollIndicatorInsets = contentInsets;
    
    //[_paymentsScrollView setContentOffset:CGPointMake(0.0,kbSize.height) animated:YES];

    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGRect frame = [self.activeField.superview convertRect:self.activeField.frame toView:self.view];
    if (!CGRectContainsPoint(aRect, CGPointMake(frame.origin.x, frame.origin.y + CGRectGetHeight(frame)))) {
        CGPoint scrollPoint = CGPointMake(0.0, frame.origin.y-kbSize.height+80);
        [_paymentsScrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _paymentsScrollView.contentInset = contentInsets;
    _paymentsScrollView.scrollIndicatorInsets = contentInsets;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)stepViewControllers {
    // we keep them in an array via an unused tab-bar
    UITabBarController *tb = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    return tb.viewControllers;
}

- (void)finishedAllSteps {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getDirectionsFrom:(LatLng *)origin to:(LatLng *)destination forMap:(GMSMapView *)mapView {
    NSString *baseUrl = [NSString stringWithFormat:URLDirectionsFmt,origin.lat,origin.lng, destination.lat, destination.lng];
    NSURL *url = [NSURL URLWithString:baseUrl];
    dispatch_async(dispatch_get_main_queue(), ^() {
        NSData *directionsData = [NSData dataWithContentsOfURL: url];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:directionsData options:NSJSONReadingMutableContainers error:&error];
        self.polyline.map = nil;
        self.polyline = [AppDelegate showRouteInMap:mapView withResults:dict forMarker:mapView.selectedMarker];
    });
}

// handlers
- (IBAction)gotoBack:(UIButton *)sender {
    UIView *subView = self.view.subviews.lastObject;
    if (subView == self.locationsTableView) {
        [super showPreviousStep];
    } if (subView == self.paymentDoneView) {
        [super showPreviousStep];
    } else {
        UIView *prevView = [self.view viewWithTag:subView.tag-1];
        [self.view bringSubviewToFront:prevView];
    }
    
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

-(void)addOrSubtractCar:(UIButton *)sender {
    UIView *parentView = sender.superview;
    UILabel *numLabel = [parentView viewWithTag:6];
    NSInteger numberValue = numLabel.text.integerValue;
    NSInteger diff = sender.tag == 7 ? 1 : - 1;
    numberValue = numberValue + diff;
    UITableViewCell* cell = [AppDelegate parentTableViewCell:parentView];
    UITableView* table = [AppDelegate parentTableView:cell];
    NSIndexPath* pathOfTheCell = [table indexPathForCell:cell];
    if (numberValue >= 0) {
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)numberValue];
        UILabel *priceLabel = [parentView viewWithTag:8];
        NSInteger price = [priceLabel.text substringFromIndex:1].integerValue;
        self.totalPrice += (price * diff);
        NSInteger value = self.selectedCarTypes[pathOfTheCell.row].integerValue;
        self.selectedCarTypes[pathOfTheCell.row] = @(value + diff);
        [self uiBindWithCard:YES];
    }
}

- (IBAction)confirmClick:(UIButton *)sender {
    if (self.totalPrice > 0) {
        [self.view bringSubviewToFront:self.paymentsScrollView];
    }
}
- (IBAction)flagButton_Click:(UIButton *)sender {
    [self hideKeyboard];
    CountryPhoneCodeVC *vcObj =[[CountryPhoneCodeVC alloc] initWithNibName:@"CountryPhoneCodeVC" bundle:nil];
    vcObj.delegate = self;
    vcObj.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popPresenter = [vcObj popoverPresentationController];
    popPresenter.sourceView = self.flagButton;
    [self presentViewController:vcObj animated:YES completion:nil];
}
// handler for flag did-select
- (void)didSelect:(BOOL)hasSelected {
    NSString *imName = [[SharedInstance sharedInstance].selCountryCode lowercaseString];
    [self.flagButton setImage:[UIImage imageNamed:imName] forState:UIControlStateNormal];
    self.countryPrefixLabel.text = [SharedInstance sharedInstance].selCountryId;
}

- (void)uiBindWithCard:(BOOL)payWithCard {
    _creditCardButton.selected = payWithCard;
    _cashButton.selected = !payWithCard;
    _cashButton.layer.borderWidth = payWithCard ? 0 : 1;
    _creditCardButton.layer.borderWidth = !payWithCard ? 0 : 1;
    _stpCardTextField.hidden = !payWithCard;
    _creditCardLine.hidden = !payWithCard;
    _takePhotoButton.hidden = !payWithCard;
    //confirm & finish buttons
    self.confirmButton.backgroundColor = self.totalPrice > 0 ? [UIColor colorWithRed:0.24 green:0.57 blue:1.0 alpha:1.0] : [UIColor colorWithWhite:0.79 alpha:1.0];
    self.payNowButton.backgroundColor = self.confirmButton.backgroundColor;
    [self.payNowButton setTitle:payWithCard ? [NSString stringWithFormat:@"PAY NOW    Total:€%ld", self.totalPrice] : @"FINISH" forState:UIControlStateNormal];

}

- (IBAction)cashButton_Click:(UIButton *)sender {
    [self uiBindWithCard:NO];
}

- (IBAction)creditCardButton_Click:(UIButton *)sender {
    [self uiBindWithCard:YES];
}

- (void)paymentCardTextFieldDidBeginEditingNumber:(nonnull STPPaymentCardTextField *)textField {
    self.activeField = textField;
}

- (void)paymentCardTextFieldDidChange:(STPPaymentCardTextField *)textField {
    //NSLog(@"Card number: %@ Exp Month: %@ Exp Year: %@ CVC: %@", textField.cardParams.number, @(textField.cardParams.expMonth), @(textField.cardParams.expYear), textField.cardParams.cvc);
    self.payNowButton.enabled = textField.isValid;
}

- (IBAction)payNow_click:(UIButton *)sender {
    [self payWithCreditCard];
}

-(void)payWithCreditCard {
    NSDateFormatter *df = [NSDateFormatter new];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    df.timeZone = timeZone;
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    // send payment to back end
     //self.stpCardTextField.cardParams;
    STPAPIClient *stpClient = [STPAPIClient sharedClient];
    //[self.selectedCarTypes enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //    if (obj.integerValue == 0) { return; } }];
    CarCategory *cCat = self.selectedCarCategory;
    TransferBookingRequest *request = [TransferBookingRequest new];
    //request.userId = self step
    request.dropoffAddress = self.selectedLocation.name;
    request.pickupAddress = self.currentLocation.name;
    request.passengersNumber = cCat.maxPassengers;
    request.dropoffLatLng = self.selectedLocation.latLng;
    request.pickupLatLng = self.currentLocation.latLng; // todo
    request.agreedToTermsAndConditions = YES;
    request.paymentMethod = 1;
    NSDate *currDate = NSDate.date;
    request.dateTime = [df stringFromDate:currDate];
    PickupDateTime *pdt = [PickupDateTime new];
    df.dateFormat = @"yyyy-MM-dd"; pdt.date = [df stringFromDate:currDate];
    df.dateFormat = @"HH:mm:ss"; pdt.date = [df stringFromDate:currDate];
    request.pickupDateTime = pdt;
    request.extras = @[];
    request.carTypeId = cCat.Id;
    request.luggagePiecesNumber = cCat.maxLaggages;
    
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [stpClient createTokenWithCard:self.cardParams completion:^(STPToken *token, NSError *error) {
        if (error) {
            NSString *strDescr = [NSString stringWithFormat: @"Credit card error: %@", error.localizedDescription];
            [self showAlertViewWithMessage:strDescr andTitle:@"Error"];
            return;
        }
        request.stripeCardToken = token.tokenId;
        [api CreateTransferBookingRequest:request withBlock:^(BOOL b) {
            //[self.view bringSubviewToFront:self.paymentDoneView];
            [self showAlertViewWithMessage:@"Payment done" andTitle:@"Success"];
            [self showNextStep];
        }]; // create transfer request
    }]; // create token
}

- (IBAction)takePhoto_click:(UIButton *)sender {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];
}
#pragma mark - CardIOPaymentViewControllerDelegate


- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    self.creditCardNumberTextField.text = info.redactedCardNumber;
    self.expiryDateTextField.text = [NSString stringWithFormat:@"%02lu/%lu", (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear];
    self.cvvTextField.text = info.cvv;
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}


// methods

    

@end
