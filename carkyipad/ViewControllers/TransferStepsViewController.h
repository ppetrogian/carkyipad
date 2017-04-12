//
//  CarRentalStepsViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMStepsController.h"
#import "CarRentalStepsViewController.h"
#import <GoogleMaps/GoogleMaps.h>
@class LatLng;

@interface TransferStepsViewController : CarRentalStepsViewController<CLLocationManagerDelegate,GMSMapViewDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

// methods
-(void)showRouteInMap:(NSDictionary *)results;
-(void)getDirectionsFrom:(LatLng *)origin to:(LatLng *)destination;

@end
