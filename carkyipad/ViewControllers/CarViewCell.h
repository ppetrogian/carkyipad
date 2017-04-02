//
//  CarViewCell.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 29/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *carDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *orSimilarLabel;
@property (weak, nonatomic) IBOutlet UIButton *automaticButton;
@property (weak, nonatomic) IBOutlet UIButton *dieselButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carImage;

@end
