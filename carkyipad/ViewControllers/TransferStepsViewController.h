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
@class Location;

@interface TransferStepsViewController : CarRentalStepsViewController
@property (weak, nonatomic) IBOutlet UIView *viewFindDrivers;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *fromLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *toLocationTextField;
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property (strong, nonatomic) Location *currentLocation;
@property (weak, nonatomic) IBOutlet UITableView *carCategoriesTableView;
-(void)loadCarCategories;
-(void)loadLocations:(NSString *)filter;
// methods
-(void)getDirectionsFrom:(LatLng *)origin to:(LatLng *)destination;

@end
