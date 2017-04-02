//
//  CarRentalStepsViewController.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 14/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarRentalStepsViewController.h"
#import "PSStepButton.h"
#import "CircleLineButton.h"
#import "StepViewController.h"
#import "AppDelegate.h"
#import "DetailsStepViewController.h"
#import "CarStepViewController.h"
#import "ShadowViewWithText.h"
#import "CarExtrasViewController.h"

@interface CarRentalStepsViewController ()

@end

@implementation CarRentalStepsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // hide back view may be remove before release
    UIImageView *backView = (UIImageView *)[self.view viewWithTag:1];
    if (backView)  backView.hidden = YES;
    
    self.stepsBar.barStyle = UIBarStyleBlack;
    self.stepsBar.backgroundColor = [UIColor blackColor];
    
    for (NSInteger i = 0; i < self.stepViewControllers.count; i++) {
        RMStep *step = [self stepsBar:self.stepsBar stepAtIndex:i];
        step.stepView = (CircleLineButton *)self.stepButtonsStack.arrangedSubviews[i];
        step.titleLabel = (UILabel *)self.stepLabelsStack.arrangedSubviews[i];
        step.titleLabel.text = step.title;
        step.stepView.enabled = i == 0;
    }

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
    StepViewController *firstStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
    firstStep.step.title = NSLocalizedString(@"Details", nil) ;
    
    StepViewController *secondStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Car"];
    secondStep.step.title =  NSLocalizedString(@"Car", nil) ;
    
    StepViewController *thirdStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Extras"];
    thirdStep.step.title =  NSLocalizedString(@"Extras", nil) ;
    
    StepViewController *fourthStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Payment"];
    fourthStep.step.title =  NSLocalizedString(@"Payment", nil) ;
    
    return @[firstStep, secondStep, thirdStep, fourthStep];
}

- (void)finishedAllSteps {
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {        
    }];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Wizard finish",nil) message:NSLocalizedString(@"Payment done", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:actionYes];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)canceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showPreviousStep {
    if ([self.currentStepViewController isKindOfClass:CarStepViewController.class]) {
        self.totalView.hidden = YES;
    }
    [super showPreviousStep];
}

-(void)showNextStep {
    if ([self.currentStepViewController isKindOfClass:DetailsStepViewController.class]) {
        self.totalView.hidden = YES;
        CarStepViewController *carVc = self.childViewControllers[1];
        [carVc prepareCarStep];
    } else if ([self.currentStepViewController isKindOfClass:CarStepViewController.class]) {
        CarExtrasViewController *carExtrasVc = self.childViewControllers[2];
        [carExtrasVc prepareCarStep];
    }
    [super showNextStep];
}

- (IBAction)gotoBack:(id)sender {
    [self showPreviousStep];
}
- (IBAction)gotoNext:(id)sender {
    [self showNextStep];
}
@end
