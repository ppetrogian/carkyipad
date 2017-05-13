//
//  CarRentalStepsViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMStepsController.h"
#import "StepSegmentControllerView.h"

@class PSStepButton;
@class ShadowViewWithText;

@interface CarRentalStepsViewController : RMStepsController <RMStepsBarDelegate, RMStepsBarDataSource>
@property (weak, nonatomic) IBOutlet UIStackView *stepButtonsStack;
@property (weak, nonatomic) IBOutlet UIStackView *stepLabelsStack;
@property (weak, nonatomic) IBOutlet ShadowViewWithText *totalView;
- (IBAction)gotoBack:(id)sender;
- (IBAction)gotoNext:(id)sender;
-(void)showAlertViewWithMessage:(NSString *)messageStr andTitle:(NSString *)titleStr;
@property (nonatomic, weak) IBOutlet StepSegmentControllerView *segmentController;
@end
