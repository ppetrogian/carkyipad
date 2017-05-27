//
//  CarCollectionViewCell.h
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 10/05/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *carImageView;
@property (nonatomic, weak) IBOutlet UIImageView *modeImageView;
@property (nonatomic, weak) IBOutlet UILabel *modeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *typeImageView;
@property (nonatomic, weak) IBOutlet UILabel *typeLabel;
@property (nonatomic, weak) IBOutlet UIView *priceBackView;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageHiddenLabel;

@end
