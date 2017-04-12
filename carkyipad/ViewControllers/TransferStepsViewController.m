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
#import "WellKnownLocationsViewController.h"
#import "TGRArrayDataSource.h"

#define baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
NSString * const URLDirectionsFmt = @"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false";

@interface TransferStepsViewController () <CLLocationManagerDelegate,GMSMapViewDelegate,WellKnownLocationDelegate, UITextFieldDelegate>
@property (nonatomic, strong) LatLng* userPos;
@property (nonatomic, strong) Location* selectedLocation;
@property (nonatomic, assign) NSInteger userFleetLocationId;
@property (nonatomic,strong) WellKnownLocationsViewController *wellKnownLocationsVc;
@property (nonatomic, strong) GMSPolyline *polyline;
@property (nonatomic, strong) NSMutableArray *locationMarkers;
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
        //self.buttonTransfer.hidden = NO;
        //self.buttonCarRental.hidden = NO;
        [self getWellKnownLocations];
    }];
    NSDictionary *posDict = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserDefaultLocation"];
    self.fromLocationTextField.text = posDict[@"Name"];
    _userPos = [LatLng modelObjectWithDictionary:posDict];
    Location *cl = [Location new]; cl.identifier = -1; cl.name = @"Current location"; cl.latLng = _userPos;
    self.wellKnownLocationsVc.currentLocation = cl;
    [AppDelegate configurePSTextField:self.fromLocationTextField withColor:[UIColor whiteColor]];
    [AppDelegate configurePSTextField:self.toLocationTextField withColor:[UIColor whiteColor]];
    self.driversContainerView.frame = self.locationsContainerView.frame;
    self.driversContainerView.backgroundColor = self.locationsContainerView.backgroundColor;
    self.driversContainerView.alpha = 0;
    self.toLocationTextField.delegate = self;
    [self.view addSubview:self.locationsContainerView];
}

-(void)getWellKnownLocations {
    CarkyApiClient *api = [[AppDelegate instance] api];
    self.userFleetLocationId = ((NSNumber *)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserFleetLocationId"]).integerValue;
    [api GetWellKnownLocations:self.userFleetLocationId withBlock:^(NSArray<Location *> *array) {
        [AppDelegate instance].wellKnownLocations = array;
        [self.wellKnownLocationsVc loadLocations:nil];
        
        self.locationMarkers = [NSMutableArray arrayWithCapacity:array.count];
        [array enumerateObjectsUsingBlock:^(Location * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(obj.latLng.lat,obj.latLng.lng);
            marker.icon = [UIImage imageNamed:@"point-1"];
            marker.userData = obj;
            marker.title = @""; // obj.name;
            marker.tappable = YES;
            marker.map = _mapView;
            [_locationMarkers addObject:marker];
        }];
    }];
    CLLocationCoordinate2D userCoord = CLLocationCoordinate2DMake(_userPos.lat, _userPos.lng);
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:userCoord zoom: 13.0];
    self.mapView.delegate = self;
    CarkyDriverPositionsRequest *req = [self getDriversRequest];
    
    //[api FindNearestCarkyDriverPositions:req withBlock:^(NSArray<CarkyDriverPositionsResponse*> *array) {
        //CarkyDriverPositionsResponse *airportRes = array[0];
        //LatLng *posDest = airportRes.latLng;
        //[self getDirectionsFrom:self.userPos to:posDest];
        //[array enumerateObjectsUsingBlock:^(CarkyDriverPositionsResponse * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      //      GMSMarker *marker = [[GMSMarker alloc] init];
      //      marker.position = CLLocationCoordinate2DMake(obj.latLng.lat,obj.latLng.lng);
     //       marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]] ;
    //    }];
    //}];
}

#pragma mark - delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    TGRArrayDataSource *dataSource = (TGRArrayDataSource *)self.wellKnownLocationsVc.locationsTableView.dataSource;
    NSArray<Location*> *locations = dataSource.items;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",textField.text];
    if ([locations filteredArrayUsingPredicate:predicate].count > 0) {
        Location *selectedLocation = [[locations filteredArrayUsingPredicate:predicate] objectAtIndex:0];
        [self didSelectLocation:selectedLocation.identifier withValue:selectedLocation andText:selectedLocation.name];
    }
}

- (IBAction)toLocationTextChanged:(UITextField *)textField {
    [self.wellKnownLocationsVc loadLocations:textField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    TGRArrayDataSource *dataSource = (TGRArrayDataSource *)self.wellKnownLocationsVc.locationsTableView.dataSource;
    NSArray<Location*> *locations = dataSource.items;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",textField.text];
    return [locations filteredArrayUsingPredicate:predicate].count > 0 ? YES : NO;
}

- (void) didSelectLocation:(NSInteger)identifier withValue:(id)value andText:(NSString *)text {
    self.selectedLocation = (Location *)value;
    self.toLocationTextField.text = text;
    [self.locationMarkers enumerateObjectsUsingBlock:^(GMSMarker *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userData == self.selectedLocation) {
            _mapView.selectedMarker = obj;
        }
    }];
    [self getDirectionsFrom:self.userPos to:self.selectedLocation.latLng];
    [self.toLocationTextField resignFirstResponder];
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    Location *loc = marker.userData;
    _mapView.selectedMarker = marker;
    [self didSelectLocation:loc.identifier withValue:loc andText:loc.name];
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    // your code
    Location *loc = marker.userData;
    _mapView.selectedMarker = marker;
    [self didSelectLocation:loc.identifier withValue:loc andText:loc.name];
}

-(CarkyDriverPositionsRequest *)getDriversRequest {
    CarkyDriverPositionsRequest *request = [CarkyDriverPositionsRequest new];
    request.carkyCategoryId = 1;
    request.position = self.userPos;
    return request;
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"wellKnownLocationsSegue"]) {
         self.wellKnownLocationsVc = segue.destinationViewController;
         self.wellKnownLocationsVc.delegate = self;
         self.wellKnownLocationsVc.view.backgroundColor = self.locationsContainerView.backgroundColor;
     }
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
    UIViewController *s0 = [self.storyboard instantiateViewControllerWithIdentifier:@"wellKnownLocations"];
    s0.step.title = NSLocalizedString(@"Details", nil) ;
//    UIViewController *s1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Car"];
//    s1.step.title =  NSLocalizedString(@"Car", nil) ;
//    UIViewController *s2 = [self.storyboard instantiateViewControllerWithIdentifier:@"Payment"];
//    s2.step.title =  NSLocalizedString(@"Payment", nil) ;
    
    return @[s0];
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
    [super showPreviousStep];
}

// methods

    

@end
