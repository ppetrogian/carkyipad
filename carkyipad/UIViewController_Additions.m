//
//  NSObject+UIViewController_Additions.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/6/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "UIViewController_Additions.h"

@implementation UIViewController (Additions)
- (BOOL)isVisible {
    return [self isViewLoaded] && self.view.window;
}
@end
