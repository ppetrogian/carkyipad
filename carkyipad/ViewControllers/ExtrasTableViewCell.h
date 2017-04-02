//
//  ExtrasTableViewCell.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarExtraBaseTableViewCell.h"

@interface ExtrasTableViewCell : CarExtraBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *extraImageView;
@property (weak, nonatomic) IBOutlet UILabel *extraTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricePerDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectLabel;

@end
