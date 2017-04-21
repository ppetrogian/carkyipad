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

#define baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
NSString * const URLDirectionsFmt = @"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false";

@interface TransferStepsViewController () <CLLocationManagerDelegate, GMSMapViewDelegate, CardIOPaymentViewControllerDelegate, STPPaymentCardTextFieldDelegate, SelectDelegate, UITextFieldDelegate, UITableViewDelegate>
@property (nonatomic, strong) LatLng* userPos;
@property (nonatomic, strong) Location* selectedLocation;
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
    _mapView.mapType = kGMSTypeNormal;
    _mapView.settings.myLocationButton = YES;
    _mapView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    // todo: remove from here
    MBProgressHUD *hud = [AppDelegate showProgressNotification:self.view];
    [[AppDelegate instance] fetchInitialData:^(BOOL b) {
        [AppDelegate hideProgressNotification:hud];
        
        [self getWellKnownLocations];
    }];
    NSDictionary *posDict = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserDefaultLocation"];
    self.fromLocationTextField.text = posDict[@"Name"];
    _userPos = [LatLng modelObjectWithDictionary:posDict];
    Location *cl = [Location new]; cl.identifier = -1; cl.name = @"Current location"; cl.latLng = self.userPos;
    self.currentLocation = cl;
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

-(void)getWellKnownLocations {
    CarkyApiClient *api = [[AppDelegate instance] api];
    self.userFleetLocationId = ((NSNumber *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserFleetLocationId"]).integerValue;
    [api GetWellKnownLocations:self.userFleetLocationId withBlock:^(NSArray<Location *> *array) {
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
            marker.map = _mapView;
            [self.locationMarkers addObject:marker];
        }];
    }];
    CLLocationCoordinate2D userCoord = CLLocationCoordinate2DMake(_userPos.lat, _userPos.lng);
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:userCoord zoom: 13.0];
    self.mapView.delegate = self;

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.locationsTableView) {
        Location *loc = self.wellKnownLocationsDataSource.items[indexPath.row];
        [self didSelectLocation:loc.identifier withValue:loc andText:loc.name];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } else {
        CarCategory *cCat = self.carCategoriesDataSource.items[indexPath.row];
        [self didSelectCarCategory:cCat.Id withValue:cCat andText:cCat.Description];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    TGRArrayDataSource *dataSource = (TGRArrayDataSource *)self.locationsTableView.dataSource;
    NSArray<Location*> *locations = dataSource.items;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",textField.text];
    if ([locations filteredArrayUsingPredicate:predicate].count > 0) {
        Location *selectedLocation = [[locations filteredArrayUsingPredicate:predicate] objectAtIndex:0];
        [self didSelectLocation:selectedLocation.identifier withValue:selectedLocation andText:selectedLocation.name];
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

- (void) didSelectLocation:(NSInteger)identifier withValue:(id)value andText:(NSString *)t {
    self.selectedLocation = (Location *)value;
    self.toLocationTextField.text = self.selectedLocation.name;
    [self.locationMarkers enumerateObjectsUsingBlock:^(GMSMarker *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userData == self.selectedLocation) {
            _mapView.selectedMarker = obj;
        }
    }];
    [self getDirectionsFrom:self.userPos to:self.selectedLocation.latLng];
    [self.toLocationTextField resignFirstResponder];

    [self.view bringSubviewToFront:self.viewFindDrivers];
}

- (void) didSelectCarCategory:(NSInteger)identifier withValue:(id)value andText:(NSString *)text {
    CarkyDriverPositionsRequest *req = [self getDriversRequest:identifier];
    CarkyApiClient *api = [CarkyApiClient sharedService];
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
             marker.map = _mapView;
            //marker.title = obj.d
             [self.driverMarkers addObject:marker];
        }];
    }];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    id loc = marker.userData;
    if ([loc isKindOfClass:[Location class]]) {
        _mapView.selectedMarker = marker;
        [self didSelectLocation:0 withValue:loc andText:nil];
    }
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    // your code
    id loc = marker.userData;
    if ([loc isKindOfClass:[Location class]]) {
        _mapView.selectedMarker = marker;
        [self didSelectLocation:0 withValue:loc andText:nil];
    }
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
    UITabBarController *tb = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBar"]; //requestRide
    //s0.step.title = NSLocalizedString(@"payment", nil) ;
    
    return tb.viewControllers;
}

- (void)finishedAllSteps {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getDirectionsFrom:(LatLng *)origin to:(LatLng *)destination {
    NSString *baseUrl = [NSString stringWithFormat:URLDirectionsFmt,origin.lat,origin.lng, destination.lat, destination.lng];
    NSURL *url = [NSURL URLWithString:baseUrl];
    dispatch_async(dispatch_get_main_queue(), ^() {
        NSData *directionsData = [NSData dataWithContentsOfURL: url];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:directionsData options:NSJSONReadingMutableContainers error:&error];
        self.polyline.map = nil;
        self.polyline = [AppDelegate showRouteInMap:_mapView withResults:dict forMarker:_mapView.selectedMarker];
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
    NSDateFormatter *df = [NSDateFormatter new];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    df.timeZone = timeZone;
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    // send payment to back end
    STPCardParams *cardParams = self.stpCardTextField.cardParams;
    STPAPIClient *stpClient = [STPAPIClient sharedClient];
    [self.selectedCarTypes enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.integerValue == 0) {
            return;
        }
        CarCategory *cCat = self.carCategoriesDataSource.items[idx];
        TransferBookingRequest *request = [TransferBookingRequest new];
        request.dropoffAddress = self.toLocationTextField.text;
        request.pickupAddress = self.fromLocationTextField.text;
        request.passengersNumber = obj.integerValue * cCat.maxPassengers;
        request.dropoffLatLng = self.selectedLocation.latLng;
        request.pickupLatLng = self.userPos;
        request.agreedToTermsAndConditions = YES;
        request.dateTime = [df stringFromDate:[NSDate date]];
        request.extras = @[];
        request.carTypeId = cCat.Id;
        request.luggagePiecesNumber = obj.integerValue * cCat.maxLaggages;
        AccountBindingModel *acc = [AccountBindingModel new];
        acc.phoneNumber = self.phoneNumberTextField.text;
        acc.email = self.emailTextField.text;
        acc.confirmEmail = self.confirmEmailTextField.text;
        acc.firstName = self.firstNameTextField.text;
        acc.lastName = self.lastNameTextField.text;
        acc.phoneNumberCountryCode = self.countryPrefixLabel.text;
        request.accountBindingModel = acc;
        
        CarkyApiClient *api = [CarkyApiClient sharedService];
        [stpClient createTokenWithCard:cardParams completion:^(STPToken *token, NSError *error) {
            if (error) {
                NSLog(@"Error occured in create token: %@", error.localizedDescription);
                return;
            }
            request.stripeCardToken = token.tokenId;
            [api CreateTransferBookingRequest:request withBlock:^(NSString *string) {
                NSLog(@"Response: %@", string);
                [self.view bringSubviewToFront:self.paymentDoneView];
            }]; // create transfer request
        }]; // create token
    }];

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
