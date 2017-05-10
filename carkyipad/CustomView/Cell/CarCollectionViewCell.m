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
        /*
        self.contentView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
        [self.contentView.layer setBorderWidth:1.0];
        self.contentView.layer.cornerRadius=6;
        self.contentView.clipsToBounds=YES;*/
    }
    return self;
}
@end
