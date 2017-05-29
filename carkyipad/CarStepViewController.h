//
//  CarStepViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 29/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
#import "CarTypeSegmentView.h"
#import "PlaceDetailsView.h"
@class ShadowViewWithText;

@interface CarStepViewController : StepViewController<UICollectionViewDelegate, UICollectionViewDataSource, CarSegmentDelegate>
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (nonatomic, weak) IBOutlet CarTypeSegmentView *carSegmentView;
@property (nonatomic, weak) IBOutlet UIView *headerBackView;

@property (weak, nonatomic) IBOutlet UICollectionView *carsCollectionView;

-(void)prepareCarStep;
//--------------
@property (nonatomic, weak) IBOutlet UIView *pickupBackView;
@property (nonatomic, weak) IBOutlet UIView * dropoffBackView;
@property (nonatomic, strong) PlaceDetailsView *pickupPlaceDetailsView;
@property (nonatomic, strong) PlaceDetailsView *dropOffPlaceDetailsView;
@property (nonatomic, assign) NSInteger selCategoryIndex;
-(IBAction) nextButtonAction:(UIButton *)sender;
-(IBAction)backButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeLeftRecognizer;
@property (weak, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeRightRecognizer;
@end
