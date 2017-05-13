//
//  CheckMarkButton.m
//  QRCodeProject
//
//  Created by Curious-ios on 8/20/14.
//  Copyright (c) 2014 Avinash. All rights reserved.
//

#import "CheckMarkButton.h"

@implementation CheckMarkButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self defaultSetup];
    }
    return self;
}
-(void) awakeFromNib{
    [super awakeFromNib];
    [self defaultSetup];
}
-(void) defaultSetup{
    [self setDefaultImage:@"agree_check.png" SelectedImage:@"agree_uncheck.png"];
}
-(void) setDefaultImage:(NSString *)defaultImage SelectedImage:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:defaultImage];
    self.unCheckedImage = image;//[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setImage:self.unCheckedImage
          forState:UIControlStateNormal];
    image = [UIImage imageNamed:imageName];
    self.checkedImage = image;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) setIsChecked:(BOOL)isChecked{
    
    _isChecked = isChecked;
    
    if (isChecked==YES) {
        [self setImage:self.checkedImage
              forState:UIControlStateNormal];
    }
    else{
        [self setImage:self.unCheckedImage
              forState:UIControlStateNormal];
    }
}
@end
