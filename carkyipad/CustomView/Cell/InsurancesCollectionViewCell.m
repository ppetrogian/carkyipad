//
//  InsurancesCollectionViewCell.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 15/05/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "InsurancesCollectionViewCell.h"
#import "UIController.h"

@implementation InsurancesCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"InsurancesCollectionViewCell" owner:self options:nil];;
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        [[UIController sharedInstance] addShadowToView:self.containerView withOffset:CGSizeMake(0, 2) shadowRadius:3 shadowOpacity:0.2];
    }
    return self;
}
@end

