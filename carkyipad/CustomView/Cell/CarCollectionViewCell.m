//
//  CarCollectionViewCell.m
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 10/05/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import "CarCollectionViewCell.h"

@implementation CarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CarCollectionViewCell" owner:self options:nil];;
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}
@end
