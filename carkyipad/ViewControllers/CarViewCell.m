//
//  CarViewCell.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 29/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "CarViewCell.h"
@implementation CarViewCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.layer.borderWidth = selected ? 2 : 0;
    self.layer.borderColor = self.tintColor.CGColor;
}
@end
