//
//  CarStepViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 29/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
@class ShadowViewWithText;
@class MBSegmentedControl;

@interface CarStepViewController : StepViewController

@property (weak, nonatomic) IBOutlet UICollectionView *carsCollectionView;
@property (weak, nonatomic) IBOutlet MBSegmentedControl *carTypesSegmented;
- (IBAction)carTypeChanged:(MBSegmentedControl *)sender;
-(void)prepareCarStep;
@end
