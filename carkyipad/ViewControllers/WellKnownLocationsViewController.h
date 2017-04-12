//
//  WellKnownTableViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 12/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Location;

@protocol WellKnownLocationDelegate <NSObject>
@optional
- (void) didSelectLocation:(NSInteger)identifier withValue:(id)value andText:(NSString *)text;
@end

@interface WellKnownLocationsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *locationsTableView;
@property (strong, nonatomic) Location *currentLocation;
@property (weak,nonatomic) id<WellKnownLocationDelegate> delegate;
-(void)loadLocations:(NSString *)filter;
@end
