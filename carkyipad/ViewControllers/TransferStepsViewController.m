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
#import <GooglePlaces/GooglePlaces.h>
#import <CoreLocation/CoreLocation.h>
#import "TGRArrayDataSource.h"
#import "CountryPhoneCodeVC.h"
#import "SharedInstance.h"
#import <CardIO/CardIO.h>
#import <Stripe/Stripe.h>
#import "InitViewController.h"
#import "StepViewController.h"
#import "CalendarRange.h"

#define kLastPayment @"LastPayment"
#define baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
NSString * const URLDirectionsFmt = @"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false";

@interface TransferStepsViewController () <UITextFieldDelegate, MBProgressHUDDelegate, InitViewController>
@property (nonatomic, strong) LatLng* userPos;

@property (nonatomic, assign) NSInteger userFleetLocationId;
@property (nonatomic, strong) GMSPolyline *polyline;
@property (nonatomic, strong) GMSMarker *targetMarker;
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
   
    self.selectedCarTypes = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0)]];
    self.targetMarker = [[GMSMarker alloc] init];
    [CardIOUtilities preload];
}

-(void)initControls {
    UIViewController *firstStepViewController = self.childViewControllers[0];
    [self showViewController:firstStepViewController sender:nil];
}

-(void)getWellKnownLocations:(NSInteger)locationId forMap:(GMSMapView *)mapView {
    AppDelegate *app = [AppDelegate instance];
    //NSDictionary *posDict = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserDefaultLocation"]; [LatLng modelObjectWithDictionary:posDict];
    _userPos = app.clientConfiguration.location.latLng;
    self.currentLocation = app.clientConfiguration.location;
    self.currentLocation.name = self.currentLocation.address;
    mapView.mapType = kGMSTypeNormal;
    mapView.settings.myLocationButton = NO;
    mapView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self loadLocations:nil];
    
    self.locationMarkers = [NSMutableArray arrayWithCapacity:app.wellKnownLocations.count];
    [app.wellKnownLocations enumerateObjectsUsingBlock:^(Location * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(obj.latLng.lat,obj.latLng.lng);
        marker.position = position;
        marker.icon = [UIImage imageNamed:@"point-1"];
        marker.userData = obj;
        marker.title = @""; // obj.name;
        marker.tappable = YES;
        marker.map = mapView;
        [self.locationMarkers addObject:marker];
    }];
    
    CLLocationCoordinate2D positionCenter = CLLocationCoordinate2DMake(_userPos.lat, _userPos.lng);
    if (/* DISABLES CODE */ (1) == 1) {
        UIColor *bluC = [UIColor colorWithRed:0.26 green:0.62 blue:0.77 alpha:1]; //0.26 0.62 0.77
        GMSCircle *circ1 = [GMSCircle circleWithPosition:positionCenter radius:25];
        circ1.fillColor = [UIColor clearColor];
        circ1.strokeColor = bluC;
        circ1.strokeWidth = 6;
        circ1.map = mapView;
        GMSCircle *circ2 = [GMSCircle circleWithPosition:positionCenter radius:400];
        circ2.fillColor = [UIColor clearColor];
        circ2.strokeColor = bluC;
        circ2.strokeWidth = 4;
        circ2.map = mapView;
    } else {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon = [UIImage imageNamed:@"SourceIcon"];
        marker.position = positionCenter;
        marker.map = mapView;
    }
    mapView.camera = [GMSCameraPosition cameraWithTarget:positionCenter zoom: 13.0];
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
}


- (IBAction)toLocationTextChanged:(UITextField *)textField {
    [self loadLocations:textField.text];
}

- (void) didSelectLocation:(NSInteger)identifier withValue:(id)value andText:(NSString *)t forMap:(GMSMapView *)mapView {
    self.selectedDropoffLocation = (Location *)value;
    self.selectedDropoffLocation.address = self.selectedDropoffLocation.name;
    mapView.selectedMarker = nil;
    [self.locationMarkers enumerateObjectsUsingBlock:^(GMSMarker *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userData == self.selectedDropoffLocation) {
            mapView.selectedMarker = obj;
        }
    }];
    if (mapView.selectedMarker) {
        mapView.selectedMarker.icon = [UIImage imageNamed:@"point-2"];
        self.targetMarker.map = nil;
    } else {
        self.targetMarker.map = mapView;
        self.targetMarker.icon = [UIImage imageNamed:@"point-2"];
        self.targetMarker.position = CLLocationCoordinate2DMake(self.selectedDropoffLocation.latLng.lat, self.selectedDropoffLocation.latLng.lng);
    }
    [self getDirectionsFrom:self.userPos to:self.selectedDropoffLocation.latLng forMap:mapView andMarker:mapView.selectedMarker ? mapView.selectedMarker : self.targetMarker];
    [[AppDelegate instance] hideProgressNotification];
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
    if (![AppDelegate instance].clientConfiguration.booksLater) {
        NSMutableArray *vcs = [NSMutableArray arrayWithArray:tb.viewControllers];
        [vcs removeObjectAtIndex:1];
        return vcs;
    }
    return tb.viewControllers;
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getDirectionsFrom:(LatLng *)origin to:(LatLng *)destination forMap:(GMSMapView *)mapView andMarker:(GMSMarker *)targetMarker {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *baseUrl = [NSString stringWithFormat:URLDirectionsFmt,origin.lat,origin.lng, destination.lat, destination.lng];
        NSURL *url = [NSURL URLWithString:baseUrl];
        NSData *directionsData = [NSData dataWithContentsOfURL: url];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:directionsData options:NSJSONReadingMutableContainers error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.polyline.map = nil;
            self.polyline = [AppDelegate showRouteInMap:mapView withResults:dict forMarker:targetMarker];
        });
    });
}

// handlers
- (IBAction)gotoBack:(UIButton *)sender {
    if (self.currentStepIndex < self.stepCount - 1)
        [self showPreviousStep];
}

- (void)paymentCardTextFieldDidBeginEditingNumber:(nonnull STPPaymentCardTextField *)textField {
    self.activeField = textField;
}

-(NSDate *)getPickupDateTime {
    AppDelegate *app = [AppDelegate instance];
    if (!app.clientConfiguration.booksLater) {
        return NSDate.date;
    }
    else {
        CalendarRange *range = self.results[kResultsDayRange];
        return range.startDay.date;
    }
}
    
-(TransferBookingRequest *)getPaymentRequestWithCC:(BOOL)forCC orWithCash:(BOOL)withCash {
    AppDelegate *app = [AppDelegate instance];
    NSDateFormatter *df = [NSDateFormatter new];
    // df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    CarCategory *cCat = self.selectedCarCategory;
    TransferBookingRequest *request = [TransferBookingRequest new];
    request.userId = self.userId;
    if(self.selectedDropoffLocation.identifier > 0) {
        request.dropoffWellKnownLocationId = self.selectedDropoffLocation.identifier;
    }
    else {
        request.dropoffLocation = self.selectedDropoffLocation;
    }
    request.passengersNumber = cCat.maxPassengers;
    request.agreedToTermsAndConditions = YES;
    request.paymentMethod = withCash ? 1 : (forCC ? 3 : 2); //1  cash, 3 credit card, paypal 2
    NSDate *pickupDate = [self getPickupDateTime];
    request.dateTime = [df stringFromDate:pickupDate];
    DateTime *pdt = [DateTime modelObjectWithDate:pickupDate];
    request.pickupDateTime = pdt;
    request.extras = @[]; // no extras for transfer
    request.carkyCategoryId = cCat.Id;
    request.luggagePiecesNumber = cCat.maxLuggages;
    request.payPalPaymentResponse = @"";
    request.payPalPayerId = @"";
    if (app.clientConfiguration.booksLater)
        request.notes = self.results[kResultsPickupNotes];
    return request;
}

- (void)MakeTransferRequest:(BlockString)block request:(TransferBookingRequest *)request {
    CarkyApiClient *api = [CarkyApiClient sharedService];
    AppDelegate *app = [AppDelegate instance];
    if (app.clientConfiguration.booksLater) {
        [api CreateTransferBookingForLater:request withBlock:^(NSArray *array) {
            [[AppDelegate instance] hideProgressNotification];
            if ([array.firstObject isKindOfClass:TransferBookingForLaterResponse.class]) {
                TransferBookingForLaterResponse *responseObj = array.firstObject;
                block(responseObj.internalBaseClassDescription);
            } else {
                [self showAlertViewWithMessage:array.firstObject andTitle:@"Error"];
                block(@"-1");
            }
        }];
    }
    else {
        [api CreateTransferBooking:request withBlock:^(NSArray *array) {
            [[AppDelegate instance] hideProgressNotification];
            if ([array.firstObject isKindOfClass:TransferBookingResponse.class]) {
                TransferBookingResponse *responseObj = array.firstObject;
                if (responseObj.bookingId.length > 0) {
                    self.transferBookingId = responseObj.bookingId;
                    block(responseObj.bookingId);
                } else {
                    [self showAlertViewWithMessage:responseObj.errorDescription andTitle:@"Error"];
                    block(@"0");
                }
            } else {
                [self showAlertViewWithMessage:array.firstObject andTitle:@"Error"];
                block(@"-1");
            }
        }];
    }
}

- (void)hudWasHidden {

}

-(void)payTransferWithCash:(BlockString)block {
    TransferBookingRequest *request = [self getPaymentRequestWithCC:NO orWithCash:YES];
    [self MakeTransferRequest:block request:request]; // create transfer request
}

-(void)payTransferWithCreditCard:(BlockString)block {
    TransferBookingRequest *request = [self getPaymentRequestWithCC:YES orWithCash:NO];
    request.stripeCardToken = self.stripeCardToken;
    [self MakeTransferRequest:block request:request]; // create transfer request
}
    
-(void)payTransferWithPaypal:(NSString *)confirmation withBlock:(BlockString)block {
    TransferBookingRequest *request = [self getPaymentRequestWithCC:NO orWithCash:NO];
    request.payPalPaymentResponse = confirmation;
    NSString* identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    request.payPalPayerId = identifier;
    [self MakeTransferRequest:^(NSString *bookingId) {
        self.transferBookingId = bookingId;
        block(bookingId);
    } request:request]; // create transfer request
}



// methods

    

@end
