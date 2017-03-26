//
//  PSInputBox.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 26/3/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PSInputBox.h"
@interface PSInputBox ()
@property (nonatomic,strong) UIView *myView;
@property (nonatomic,weak) PSTextField *txtField;
@property (nonatomic,weak) UIButton *hintButton;
@property (nonatomic,weak) UIView *borderView;
@end

@implementation PSInputBox

-(void)xibSetup {
    self.myView = [PSInputBox view];
    self.hintButton = (UIButton *)[self.myView viewWithTag:1];
    self.txtField =  (PSTextField *)[self.myView viewWithTag:2];
    self.borderView = (UIView *)[self.myView viewWithTag:3];
    // use bounds not frame or it'll be offset
    self.myView.frame = self.bounds;
    self.hintButton.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0);
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
        nib = [UINib nibWithNibName:@"PSInputBox" bundle:bundle];
    });
    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    return nibObjects.firstObject;
}

-(void)setHintText:(NSString *)value {
    _hintText = value;
    [self.hintButton setTitle:self.hintText forState:UIControlStateDisabled];
}

-(void)setHintIcon:(UIImage *)value {
    _hintIcon = value;
    [self.hintButton setImage:value forState:UIControlStateDisabled];
}

-(void)setHideBorder:(BOOL)value {
    _hideBorder = value;
    self.borderView.hidden = value;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        // Initialise properties
        [self xibSetup];
    }
    return self;
}

-(PSTextField *)textField {
    return self.txtField;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.subviews.count == 0) {
        [self xibSetup];
    }
    [self setHintText:self.hintText];
    [self setHintIcon:self.hintIcon];
    [self setHideBorder:self.hideBorder];
}


@end
