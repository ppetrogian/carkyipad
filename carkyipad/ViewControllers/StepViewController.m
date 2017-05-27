//
//  StepViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 15/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
#import "AppDelegate.h"
#import "CarRentalStepsViewController.h"
#import "ShadowViewWithText.h"
NSString *const kResultsTotalPrice = @"TotalPrice";
NSString *const kResultsTotalPriceCar = @"TotalPriceCar";
NSString *const kResultsTotalPriceExtras = @"TotalPriceExtras";
NSString *const kResultsTotalPriceInsurance = @"TotalPriceInsurance";
NSString *const kResultsBookingId = @"BookingId";

@interface StepViewController ()

@end

@implementation StepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // hide back view may be remove before release
    UIImageView *backView = (UIImageView *)[self.view viewWithTag:1];
    if (backView) {
        backView.hidden = YES;
        [backView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
