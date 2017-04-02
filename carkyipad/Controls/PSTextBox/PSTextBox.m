//
//  PSTextBox.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 02/04/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PSTextBox.h"

@interface PSTextBox ()
@property (nonatomic,strong) UIView *myView;
@property (nonatomic,strong) UILabel *hintLabel;
@end

@implementation PSTextBox

-(void)xibSetup {
    self.myView = [PSTextBox view];
    self.hintLabel = (UILabel *)[self.myView viewWithTag:1];
    self.textField = (UITextField *)[self.myView viewWithTag:2];
    // use bounds not frame or it'll be offset
    self.myView.frame = self.bounds;
    // Make the view stretch with containing view
    self.myView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    // Adding custom subview on top of our view (over any custom drawing > see note below)
    [self addSubview:self.myView];
}

// Designated initialiser
+ (id)view {
    static UINib *nib;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSBundle *bundle = [NSBundle bundleForClass:self.class];
        nib = [UINib nibWithNibName:@"PSTextBox" bundle:bundle];
    });
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    return nibObjects.firstObject;
}

-(NSString *)text {
    return self.textField.text;
}
-(void)setText:(NSString *)text {
    self.textField.text = text;
}

-(void)setHintText:(NSString *)value {
    _hintText = value;
    self.hintLabel.text = value;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // Drawing code
    if (self.subviews.count == 0) {
        [self xibSetup];
    }
    [self setHintText:self.hintText];
}


@end
