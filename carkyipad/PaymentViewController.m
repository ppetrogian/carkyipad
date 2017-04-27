//
//  PaymentViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PaymentViewController.h"
#import "ShadowViewWithText.h"
#import "StepViewController.h"
#import "RMStepsController.h"
#import "CarRentalStepsViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableDictionary *res = self.stepsController.results;
    NSInteger totalprice = ((NSNumber *)res[kResultsTotalPrice]).integerValue;
    self.totalPriceButton.text = [NSString stringWithFormat:@"%@     %@: %ld€", NSLocalizedString(@"PAY NOW", nil), NSLocalizedString(@"Total", nil), totalprice];
    CarRentalStepsViewController *parentVc = (CarRentalStepsViewController *)self.stepsController;
    parentVc.totalView.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)payNow:(id)sender {
    [self.stepsController showNextStep];
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
