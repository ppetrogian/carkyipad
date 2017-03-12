//
//  HomeViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 12/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseViewController;
@class FlatPillButton;
@interface HomeViewController : BaseViewController
@property (weak, nonatomic) IBOutlet FlatPillButton *buttonCarRental;
@property (weak, nonatomic) IBOutlet FlatPillButton *buttonTransfer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@end
