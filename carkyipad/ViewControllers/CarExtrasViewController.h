//
//  CarExtrasViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"

@interface CarExtrasViewController : StepViewController
-(void)prepareCarStep;
@property (weak, nonatomic) IBOutlet UITableView *carExtrasTableView;
@end
