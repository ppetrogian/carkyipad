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
#import "StepViewController.h"
#import <Stripe/Stripe.h>

@interface CarRentalStepsViewController ()<StepDelegate>

@end

@implementation CarRentalStepsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.stepsBar.barStyle = UIBarStyleBlack;
    self.stepsBar.backgroundColor = [UIColor blackColor];
    
    for (NSInteger i = 0; i < self.stepViewControllers.count; i++) {
        RMStep *step = [self stepsBar:self.stepsBar stepAtIndex:i];
        step.stepView = (CircleLineButton *)self.stepButtonsStack.arrangedSubviews[i];
        step.titleLabel = (UILabel *)self.stepLabelsStack.arrangedSubviews[i];
        step.titleLabel.text = step.title;
        step.stepView.enabled = i == 0;
    }

    [self configureSegmentController];
}
-(void) configureSegmentController{
    self.segmentController.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
    [self.segmentController setAllSegmentList:@[NSLocalizedString(@"1. Details", nil), NSLocalizedString(@"2. Car", nil), NSLocalizedString(@"3. Extras", nil), NSLocalizedString(@"4. Payment", nil)]];
    [self.segmentController setSelectedSegmentIndex:0];
}


-(void)showAlertViewWithMessage:(NSString *)messageStr andTitle:(NSString *)titleStr {
    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:titleStr  message: messageStr preferredStyle:UIAlertControllerStyleAlert];
    [myAlertController addAction: [self dismissAlertView_OKTapped:myAlertController]];
    [self presentViewController:myAlertController animated:YES completion:nil];
}

-(UIAlertAction *)dismissAlertView_OKTapped:(UIAlertController *)myAlertController {
    return [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)  {
        [myAlertController dismissViewControllerAnimated:YES completion:nil];
    }];
}
#pragma mark -
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)numberOfStepsInStepsBar:(RMStepsBar *)bar {
    return 4;
}

- (NSArray *)stepViewControllers {
    StepViewController *firstStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Details"];
    firstStep.step.title = NSLocalizedString(@"Details", nil) ;
    firstStep.stepDelegate = self;
    StepViewController *secondStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Car"];
    secondStep.step.title =  NSLocalizedString(@"Car", nil);
    secondStep.stepDelegate = self;
    
    StepViewController *thirdStep = [self.storyboard instantiateViewControllerWithIdentifier:@"Extras"];
    thirdStep.step.title =  NSLocalizedString(@"Extras", nil);
    thirdStep.stepDelegate = self;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Transfer" bundle:nil];
    UITabBarController *tabbarController = [storyboard instantiateViewControllerWithIdentifier:@"tabBar"];
    
    StepViewController *vc4 = [self.storyboard instantiateViewControllerWithIdentifier:@"Payment"];
    vc4.stepDelegate = self;
    
    return @[firstStep, secondStep, thirdStep, tabbarController.viewControllers[1], tabbarController.viewControllers[2]];
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
    [self.segmentController setSelectedSegmentIndex:self.segmentController.selectedIndex-1];
    [super showPreviousStep];
}

-(void)showNextStep {
    if ([self.currentStepViewController isKindOfClass:DetailsStepViewController.class]) {
        self.totalView.hidden = YES;
        CarStepViewController *carVc = self.childViewControllers[self.currentStepIndex + 1];
        [carVc prepareCarStep];
    } else if ([self.currentStepViewController isKindOfClass:CarStepViewController.class]) {
        CarExtrasViewController *carExtrasVc = self.childViewControllers[self.currentStepIndex + 1];
        [carExtrasVc prepareCarStep];
    }
    [self.segmentController setSelectedSegmentIndex:self.segmentController.selectedIndex+1];
    [super showNextStep];
    
}

-(void)payWithCreditCard:(BlockBoolean)b {
    // send payment to back end
    STPAPIClient *stpClient = [STPAPIClient sharedClient];
    
    [stpClient createTokenWithCard:self.cardParams completion:^(STPToken *token, NSError *error) {
        if (error) {
            NSString *strDescr = [NSString stringWithFormat: @"Credit card error: %@", error.localizedDescription];
            [self showAlertViewWithMessage:strDescr andTitle:@"Error"];
            return;
        }
        b(YES);
        //TransferBookingRequest *request = [self getPaymentRequestWithCC:YES];
        //request.stripeCardToken = token.tokenId;
        //[self MakeTransferRequest:block request:request]; // create transfer request
    }]; // create token
}

- (IBAction)gotoBack:(id)sender {
    [self showPreviousStep];
}
- (IBAction)gotoNext:(id)sender {
    [self showNextStep];
}
#pragma mark - Step Delegate
-(void) didSelectedNext:(UIButton *)sender{
    [self showNextStep];
}
-(void) didSelectedBack:(UIButton *)sender{
    [self showPreviousStep];
}
@end
