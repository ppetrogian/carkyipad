//
//  CarRentalStepsViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarRentalStepsViewController.h"
#import "PSStepButton.h"
#import "StepViewController.h"

@interface CarRentalStepsViewController ()

@end

@implementation CarRentalStepsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // hide back view may be remove before release
    UIImageView *backView = (UIImageView *)[self.view viewWithTag:1];
    if (backView)  backView.hidden = YES;
    
    self.stepsBar.showArrows = NO;
    self.stepsBar.barStyle = UIBarStyleBlack;
    self.stepsBar.backgroundColor = [UIColor blackColor];
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
    UIViewController *firstStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
    firstStep.step.title = NSLocalizedString(@"Details", nil) ;
    
    UIViewController *secondStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Car"];
    secondStep.step.title =  NSLocalizedString(@"Car", nil) ;
    
    UIViewController *thirdStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Extras"];
    thirdStep.step.title =  NSLocalizedString(@"Extras", nil) ;
    
    UIViewController *fourthStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Payment"];
    fourthStep.step.title =  NSLocalizedString(@"Payment", nil) ;
    
    return @[firstStep, secondStep, thirdStep, fourthStep];
}

- (void)finishedAllSteps {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)gotoBack:(id)sender {
    [self showPreviousStep];
}
- (IBAction)gotoNext:(id)sender {
    [self showNextStep];
}
@end
