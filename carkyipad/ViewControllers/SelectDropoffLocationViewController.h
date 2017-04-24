//
//  SelectDropoffLocationViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 23/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Location,RequestRideViewController;

@interface SelectDropoffLocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *toLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *fromLocationTextField;
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property (weak,nonatomic) RequestRideViewController *delegate;

@property (strong,nonatomic) Location *currentLocation;
@end
