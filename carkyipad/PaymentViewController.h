//
//  PaymentViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
@class ShadowViewWithText;

@interface PaymentViewController : StepViewController
@property (weak, nonatomic) IBOutlet ShadowViewWithText *totalPriceButton;

@end
