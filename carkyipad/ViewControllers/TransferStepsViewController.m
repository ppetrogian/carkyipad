//
//  TransferStepsViewController
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "TransferStepsViewController.h"

@interface TransferStepsViewController ()

@end

@implementation TransferStepsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)stepViewControllers {
    UIViewController *s0 = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
    s0.step.title = NSLocalizedString(@"Details", nil) ;
    
    UIViewController *s1 = [self.storyboard instantiateViewControllerWithIdentifier:@"Car"];
    s1.step.title =  NSLocalizedString(@"Car", nil) ;
    
    UIViewController *s2 = [self.storyboard instantiateViewControllerWithIdentifier:@"Payment"];
    s2.step.title =  NSLocalizedString(@"Payment", nil) ;
    
    return @[s0, s1, s2];
}

- (void)finishedAllSteps {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
