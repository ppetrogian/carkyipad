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
    return CGRectInset(bounds, self.insetLeft, 0);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, self.insetLeft, 0);
}

@end
