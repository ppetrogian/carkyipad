//
//  CarRentalStepsViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMStepsController.h"
@class PSStepButton;

@interface CarRentalStepsViewController : RMStepsController
@property (weak, nonatomic) IBOutlet PSStepButton *buttonBack;
@property (weak, nonatomic) IBOutlet PSStepButton *buttonNext;
- (IBAction)gotoBack:(id)sender;
- (IBAction)gotoNext:(id)sender;
@end
