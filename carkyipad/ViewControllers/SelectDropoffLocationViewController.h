//
//  SelectDropoffLocationViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 23/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlaces/GooglePlaces.h>
@class Location,RequestRideViewController;

@interface SelectDropoffLocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *toLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromLocationTextField;
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property (weak,nonatomic) RequestRideViewController *delegate;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) GMSCoordinateBounds *locationBounds;
@property (strong,nonatomic) Location *currentLocation;
@end
