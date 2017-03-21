//
//  RMStep.m
//  RMStepsController
//
//  Created by Roland Moers on 14.11.13.
//  Copyright (c) 2013 Roland Moers
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RMStep.h"

@interface RMStep ()

@end

@implementation RMStep



- (void)setTitle:(NSString *)newTitle {
    if(_title != newTitle) {
        _title = newTitle;
        
        self.titleLabel.text = newTitle;
    }
}

- (UIColor *)selectedBarColor {
    if(!_selectedBarColor) {
        self.selectedBarColor = [UIColor colorWithRed:23./255. green:220./255. blue:108./255. alpha:1];
    }
    
    return _selectedBarColor;
}

- (UIColor *)enabledBarColor {
    if(!_enabledBarColor) {
        self.enabledBarColor = [UIColor colorWithWhite:142./255. alpha:0.5];
    }
    
    return _enabledBarColor;
}

- (UIColor *)disabledBarColor {
    if(!_disabledBarColor) {
        self.disabledBarColor = [UIColor clearColor];
    }
    
    return _disabledBarColor;
}

- (UIColor *)selectedTextColor {
    if(!_selectedTextColor) {
        self.selectedTextColor = [UIColor colorWithWhite:1 alpha:1];
    }
    
    return _selectedTextColor;
}

- (UIColor *)enabledTextColor {
    if(!_enabledTextColor) {
        self.enabledTextColor = [UIColor colorWithWhite:1 alpha:1];
    }
    
    return _enabledTextColor;
}

- (UIColor *)disabledTextColor {
    if(!_disabledTextColor) {
        self.disabledTextColor = [UIColor colorWithWhite:0.75 alpha:1];
    }
    
    return _disabledTextColor;
}



@end
