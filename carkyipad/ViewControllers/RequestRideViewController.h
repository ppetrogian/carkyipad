//
//  RequestRideViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 21/4/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
@class GMSMapView;

@interface RequestRideViewController : StepViewController
@property (weak, nonatomic) IBOutlet UITextField *dropOffLocationTextField;

@property (weak, nonatomic) IBOutlet UIButton *requestRideButton;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UICollectionView *carCategoriesCollectionView;
@property (weak, nonatomic) IBOutlet UIView *dotView;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

- (void)didSelectLocation:(NSInteger)identifier withValue:(id)value andText:(NSString *)t;
@end
