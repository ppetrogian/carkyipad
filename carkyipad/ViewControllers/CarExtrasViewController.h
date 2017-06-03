//
//  CarExtrasViewController.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "StepViewController.h"
#import "PlaceDetailsView.h"

@interface CarExtrasViewController : StepViewController<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) IBOutlet UICollectionView *extrasCollectionView;
@property (nonatomic, weak) IBOutlet UIView *headerBackView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//--------------
@property (nonatomic, weak) IBOutlet UIView *pickupBackView;
@property (nonatomic, weak) IBOutlet UIView * dropoffBackView;
@property (nonatomic, weak) PlaceDetailsView *pickupPlaceDetailsView;
@property (nonatomic, weak) PlaceDetailsView *dropOffPlaceDetailsView;
-(IBAction) nextButtonAction:(UIButton *)sender;
-(IBAction)backButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;


@end
