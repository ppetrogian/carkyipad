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

#define baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
NSString * const URLDirectionsFmt = @"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false";

@interface TransferStepsViewController ()
@property (nonatomic, strong) LatLng* userPos;
@end

@implementation TransferStepsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    _mapView.mapType = kGMSTypeNormal;
    _mapView.settings.myLocationButton = YES;
    // todo: remove from here
    MBProgressHUD *hud = [AppDelegate showProgressNotification:self.view];
    [[AppDelegate instance] fetchInitialData:^(BOOL b) {
        [AppDelegate hideProgressNotification:hud];
        //self.buttonTransfer.hidden = NO;
        //self.buttonCarRental.hidden = NO;
        [self showDirectionsFromUserLocation];
    }];

}

-(void)showDirectionsFromUserLocation {
    CarkyApiClient *api = [[AppDelegate instance] api];
    NSDictionary *posDict = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UserDefaultLocation"];
    _userPos = [LatLng modelObjectWithDictionary:posDict];
    CLLocationCoordinate2D userCoord = CLLocationCoordinate2DMake(_userPos.lat, _userPos.lng);
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:userCoord zoom: 13.0];
    CarkyDriverPositionsRequest *req = [self getDriversRequest];
    
    [api FindNearestCarkyDriverPositions:req withBlock:^(NSArray<CarkyDriverPositionsResponse*> *array) {
        CarkyDriverPositionsResponse *airportRes = array[0];
        LatLng *posDest = airportRes.latLng;
        [self getDirectionsFrom:self.userPos to:posDest];
        [array enumerateObjectsUsingBlock:^(CarkyDriverPositionsResponse * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(obj.latLng.lat,obj.latLng.lng);
            marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]] ;
            //marker.icon=[UIImage imageNamed:@"5.png"];
            //NSArray *locationArray=[[[legRouteArray objectAtIndex:0]valueForKey:@"duration"]valueForKey:@"text"];
            //marker.title=[NSString stringWithFormat:@"%@",[locationArray objectAtIndex:0]];
            marker.map = _mapView;
            _mapView.selectedMarker=marker;
        }];
    }];
}

-(CarkyDriverPositionsRequest *)getDriversRequest {
    CarkyDriverPositionsRequest *request = [CarkyDriverPositionsRequest new];
    request.carkyCategoryId = 1;
    request.position = self.userPos;
    return request;
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
    UIViewController *s0 = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
    s0.step.title = NSLocalizedString(@"Details", nil) ;
    
    UIViewController *s1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Car"];
    s1.step.title =  NSLocalizedString(@"Car", nil) ;
    
    UIViewController *s2 = [self.storyboard instantiateViewControllerWithIdentifier:@"Payment"];
    s2.step.title =  NSLocalizedString(@"Payment", nil) ;
    
    return @[s0, s1, s2];
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
        [self showRouteInMap:dict];
    });
}


// methods
-(void)showRouteInMap:(NSDictionary *)results  {
    NSArray *routes = [results objectForKey:@"routes"];
    if(routes.count == 0) {
        return ;
    }
    GMSMutablePath *path = [GMSMutablePath path];
    NSDictionary *firstRoute = [routes objectAtIndex:0];
    NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
    
    NSMutableArray * legRouteArray=[routes valueForKey:@"legs"];
    //NSMutableString * startLocationLat=[[[legRouteArray valueForKeyPath:@"start_location.lat"] objectAtIndex:0] objectAtIndex:0];
    //NSMutableString * startLocationLong=[[[legRouteArray valueForKeyPath:@"start_location.lng"]objectAtIndex:0] objectAtIndex:0];
    
    NSLog(@"duration %@",[[[legRouteArray objectAtIndex:0]valueForKey:@"duration"]valueForKey:@"text"]);
    NSArray *steps = [leg objectForKey:@"steps"];
    NSLog(@"end address: %@", [leg objectForKey:@"end_address"]);
    int stepIndex = 0;
    CLLocationCoordinate2D stepCoordinates[1  + [steps count] + 1];
    
    for (NSDictionary *step in steps) {
        
        NSDictionary *start_location = [step objectForKey:@"start_location"];
        stepCoordinates[++stepIndex] = [AppDelegate coordinateWithLocation:start_location];
        [path addCoordinate:[AppDelegate coordinateWithLocation:start_location]];
        
        NSString *polyLinePoints = [[step objectForKey:@"polyline"] objectForKey:@"points"];
        GMSPath *polyLinePath = [GMSPath pathFromEncodedPath:polyLinePoints];
        for (int p=0; p<polyLinePath.count; p++) {
            [path addCoordinate:[polyLinePath coordinateAtIndex:p]];
        }
        
        if ([steps count] == stepIndex){
            NSDictionary *end_location = [step objectForKey:@"end_location"];
            stepCoordinates[++stepIndex] = [AppDelegate coordinateWithLocation:end_location];
            [path addCoordinate:[AppDelegate coordinateWithLocation:end_location]];
        }
    }
    
    GMSPolyline *polyline = nil;
    polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blackColor];
    polyline.strokeWidth = 3.f;
    polyline.map = _mapView;
    //show image for starting point and destination point
    for (int i = 0; i<2; i++) {
        
        if (i==0) {
            //                GMSMarker *marker = [[GMSMarker alloc] init];
            //                marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]] ;
            //                marker.position = CLLocationCoordinate2DMake([startLocationLat floatValue], [startLocationLong floatValue]);
            //                marker.map = _mapview;
        }
        else
        {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake(37.822418,23.777935);//destination lat long
            marker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]] ;
            //marker.icon=[UIImage imageNamed:@"5.png"];
            NSArray *locationArray=[[[legRouteArray objectAtIndex:0]valueForKey:@"duration"]valueForKey:@"text"];
            marker.title=[NSString stringWithFormat:@"%@",[locationArray objectAtIndex:0]];
            marker.map = _mapView;
            _mapView.selectedMarker=marker;
        }
    }
}

@end
