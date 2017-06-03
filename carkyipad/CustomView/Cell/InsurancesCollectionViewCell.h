//
//  InsurancesCollectionViewCell.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 15/05/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "ExtrasCollectionViewCell.h"

@interface InsurancesCollectionViewCell : ExtrasCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *insuranceDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceImageHiddenLabel;
@end
