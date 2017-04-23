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
@property (nonatomic, assign) NSInteger totalPrice;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic,assign) NSInteger selectedCarType;
@property (weak, nonatomic) IBOutlet UICollectionView *carCategoriesCollectionView;
@end
