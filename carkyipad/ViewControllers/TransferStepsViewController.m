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
#import <Bolts/Bolts.h>

#define baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
NSString * const URLDirectionsFmt = @"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false";

@interface TransferStepsViewController () <UITextFieldDelegate>
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
   
    self.selectedCarTypes = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0)]];
  
    [CardIOUtilities preload];
}

-(void)getWellKnownLocations:(NSInteger)locationId forMap:(GMSMapView *)mapView {
    NSDictionary *posDict = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserDefaultLocation"];
    _userPos = [LatLng modelObjectWithDictionary:posDict];
    Location *cl = [Location new]; cl.identifier = -1; cl.name = @"Current location"; cl.latLng = self.userPos;
    self.currentLocation = cl;
    mapView.mapType = kGMSTypeNormal;
    mapView.settings.myLocationButton = NO;
    mapView.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    // todo: remove from here
    CarkyApiClient *api = [CarkyApiClient sharedService];
     // ((NSNumber *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserFleetLocationId"]).integerValue;
    [api GetWellKnownLocations:locationId withBlock:^(NSArray<Location *> *array) {
        [AppDelegate instance].wellKnownLocations = array;
        self.locationBounds = [self findCoordBounds:array];
        [self loadLocations:nil];
        
        self.locationMarkers = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(Location * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    }];
    CLLocationCoordinate2D positionCenter = CLLocationCoordinate2DMake(_userPos.lat, _userPos.lng);
    if (/* DISABLES CODE */ (1) == 1) {
        UIColor *bluC = [UIColor colorWithRed:0.26 green:0.62 blue:0.77 alpha:1]; //0.26 0.62 0.77
        GMSCircle *circ1 = [GMSCircle circleWithPosition:positionCenter radius:20];
        circ1.fillColor = [UIColor clearColor];
        circ1.strokeColor = bluC;
        circ1.strokeWidth = 4;
        circ1.map = mapView;
        GMSCircle *circ2 = [GMSCircle circleWithPosition:positionCenter radius:400];
        circ2.fillColor = [UIColor clearColor];
        circ2.strokeColor = bluC;
        circ2.strokeWidth = 2;
        circ2.map = mapView;
    } else {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon = [UIImage imageNamed:@"SourceIcon"];
        marker.position = positionCenter;
        marker.map = mapView;
    }
    mapView.camera = [GMSCameraPosition cameraWithTarget:positionCenter zoom: 13.0];
}

-(GMSCoordinateBounds *)findCoordBounds:(NSArray<Location *> *) array {
    GMSCoordinateBounds *bounds;
    CLLocationCoordinate2D neBoundsCorner,swBoundsCorner;
    Location *l0 = array[0];
    //Longitude is a geographic coordinate that specifies the east-west
    __block CLLocationDegrees north=l0.latLng.lat, east=l0.latLng.lng, south=l0.latLng.lat, west=l0.latLng.lng;
    [array enumerateObjectsUsingBlock:^(Location * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.latLng.lng > west)  west = obj.latLng.lng;
        if (obj.latLng.lng < east)  east = obj.latLng.lng;
        if (obj.latLng.lat > north)  north = obj.latLng.lat;
        if (obj.latLng.lat < south)  south = obj.latLng.lat;
    }];
    neBoundsCorner = CLLocationCoordinate2DMake(north, east);
    swBoundsCorner = CLLocationCoordinate2DMake(south, west);
    bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:neBoundsCorner coordinate:swBoundsCorner];
    return bounds;
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
    self.selectedLocation = (Location *)value;
    
    [self.locationMarkers enumerateObjectsUsingBlock:^(GMSMarker *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userData == self.selectedLocation) {
            mapView.selectedMarker = obj;
        }
    }];
    if (mapView.selectedMarker) {
        mapView.selectedMarker.icon = [UIImage imageNamed:@"point-2"];
    }
    [self getDirectionsFrom:self.userPos to:self.selectedLocation.latLng forMap:mapView];
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
    return tb.viewControllers;
}

- (void)finishedAllSteps {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getDirectionsFrom:(LatLng *)origin to:(LatLng *)destination forMap:(GMSMapView *)mapView {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *baseUrl = [NSString stringWithFormat:URLDirectionsFmt,origin.lat,origin.lng, destination.lat, destination.lng];
        NSURL *url = [NSURL URLWithString:baseUrl];
        NSData *directionsData = [NSData dataWithContentsOfURL: url];
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:directionsData options:NSJSONReadingMutableContainers error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.polyline.map = nil;
            self.polyline = [AppDelegate showRouteInMap:mapView withResults:dict forMarker:mapView.selectedMarker];
        });
    });
}

// handlers
- (IBAction)gotoBack:(UIButton *)sender {
    if (self.currentStepIndex < self.stepCount - 1)
        [self showPreviousStep];
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

- (void)paymentCardTextFieldDidBeginEditingNumber:(nonnull STPPaymentCardTextField *)textField {
    self.activeField = textField;
}

-(void)payWithCreditCard:(BlockBoolean)block; {
    NSDateFormatter *df = [NSDateFormatter new];
    // df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    // send payment to back end
    STPAPIClient *stpClient = [STPAPIClient sharedClient];
    //[self.selectedCarTypes enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {  if (obj.integerValue == 0) { return; } }];
    CarCategory *cCat = self.selectedCarCategory;
    TransferBookingRequest *request = [TransferBookingRequest new];
    request.userId = self.userId;
    request.dropoffWellKnownLocationId = self.selectedLocation.identifier;
    request.dropoffAddress = self.selectedLocation.name;
    request.passengersNumber = cCat.maxPassengers;
    request.agreedToTermsAndConditions = YES;
    request.paymentMethod = 1;
    NSDate *currDate = NSDate.date;
    request.dateTime = [df stringFromDate:currDate];
    PickupDateTime *pdt = [PickupDateTime new];
    df.dateFormat = @"yyyy-MM-dd"; pdt.date = [df stringFromDate:currDate];
    df.dateFormat = @"HH:mm"; pdt.time = [df stringFromDate:currDate];
    request.pickupDateTime = pdt;
    request.extras = @[];
    request.carkyCategoryId = cCat.Id;
    request.luggagePiecesNumber = cCat.maxLuggages;
    
    CarkyApiClient *api = [CarkyApiClient sharedService];
    [stpClient createTokenWithCard:self.cardParams completion:^(STPToken *token, NSError *error) {
        if (error) {
            NSString *strDescr = [NSString stringWithFormat: @"Credit card error: %@", error.localizedDescription];
            [self showAlertViewWithMessage:strDescr andTitle:@"Error"];
            block(NO);
            return;
        }
        request.stripeCardToken = token.tokenId;
        [api CreateTransferBookingRequest:request withBlock:^(NSArray *array) {
            TransferBookingResponse *responseObj = array.firstObject;
            if (responseObj.bookingId.length > 0) {
                block(YES);
                self.transferBookingId = responseObj.bookingId;
                [self showNextStep];
            } else {
                block(NO);
                [self showAlertViewWithMessage:responseObj.errorDescription andTitle:@"Error"];
            }
        }]; // create transfer request
    }]; // create token
}


// methods

    

@end
