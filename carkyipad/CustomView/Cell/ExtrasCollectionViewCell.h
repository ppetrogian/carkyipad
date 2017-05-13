//
//  ExtrasCollectionViewCell.h
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 10/05/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtrasCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UILabel *extraNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *extraImageView;
@property (nonatomic, weak) IBOutlet UIImageView *selectionImageView;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *widthConstraint;
@end
