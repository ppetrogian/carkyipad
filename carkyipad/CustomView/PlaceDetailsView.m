//
//  PlaceDetailsView.m
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 10/05/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import "PlaceDetailsView.h"
#import "StepViewController.h"

@implementation PlaceDetailsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PlaceDetailsView" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}
-(instancetype) init{
    self = [super init];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PlaceDetailsView" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}
-(void) awakeFromNib{
    [super awakeFromNib];
}
-(void) setPlaceLableText:(NSString *)text andImage:(NSString *)imageName{
    self.placeLabel.text = text;
    self.placeImageView.image = [UIImage imageNamed:imageName];
}
-(void) setAllDetails:(NSDictionary *)dict isForPickup:(BOOL)pickup {
    self.placeValueLabel.text = dict[pickup ? kResultsPickupLocationName : kResultsDropoffLocationName];
    self.dateValueLabel.text = dict[pickup ? kResultsPickupDate : kResultsDropoffDate];
    self.timeValueLabel.text = dict[pickup ? kResultsPickupTime : kResultsDropoffTime];
}
@end
