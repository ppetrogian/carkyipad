//
//  HomeViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 12/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GMSMapView;
@interface HomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *buttonCarRental;
@property (weak, nonatomic) IBOutlet UIButton *buttonTransfer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet GMSMapView *homeMapView;
@property (nonatomic, assign) BOOL circularMap;
@end
