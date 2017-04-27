//
//  PSInsetTextField.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 27/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PSInsetTextField.h"

@implementation PSInsetTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + self.insetLeft, bounds.origin.y, bounds.size.width-self.insetLeft, bounds.size.height);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + self.insetLeft, bounds.origin.y, bounds.size.width-self.insetLeft, bounds.size.height);
}

@end
