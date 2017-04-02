//
//  InsuranceTableViewCell.h
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "ExtrasTableViewCell.h"

@interface InsuranceTableViewCell : ExtrasTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *insuranceTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *insurancePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *insuranceSelectLabel;

@end
