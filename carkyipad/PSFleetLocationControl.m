//
//  PSFleetLocationControl.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 25/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PSFleetLocationControl.h"
#import "UIButton+VerticalLayout.h"

@interface PSFleetLocationControl ()
@property (nonatomic,strong) NSArray<UIButton *> *buttons;
@end

@implementation PSFleetLocationControl

@synthesize locationNames = _locationNames;

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]){
        [self setupView];
    }
    return self;
}

- (void)initDefaultValues
{
  self.padding = 10.0;
  self.fontSize = 12.0;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initDefaultValues];
    if (self) {
        [self setupView];
    }
    return self;
}

-(NSString *) locationNames {
    return _locationNames;
}

-(void)setLocationNames:(NSString *)value {
    _locationNames = value;
    [self setupView];
}

-(void)setPadding:(CGFloat)value {
    _padding = value;
    [self setupView];
}

-(void)setFontSize:(CGFloat)value {
    _fontSize = value;
    [self setupView];
}

-(void)setupView {
    // remove existing buttons
    while(self.arrangedSubviews.count > 0) {
        [self removeArrangedSubview:self.arrangedSubviews[0]];
    };
    // create buttons with titles from locations given
    NSArray<NSString *> *parts = [self.locationNames componentsSeparatedByString:@","];
    NSMutableArray* temp = [NSMutableArray arrayWithCapacity:parts.count];
    
    for(NSInteger i=0; i<parts.count; i++) {
        NSString *name = parts[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = 100 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        [button setTitle:name forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"loc_%@", name]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"loc_%@_off", name]] forState:UIControlStateSelected];
        [button centerVerticallyWithPadding:self.padding];
        // Set the accessibility label
        button.accessibilityLabel = name;
        
        // Setup the button action
        [button addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // Add the button to the stack
        [self addArrangedSubview:button];
        
        // Add the new button to the rating button array
        [temp addObject:button];
    };
    self.buttons = temp;
}

-(IBAction) radioButtonClicked:(UIButton *) sender {
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = obj != sender ? NO : YES;
    }];
}
     
-(NSString *)selectedName {
    __block UIButton *buttonTemp;
    [self.buttons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.selected) {
            *stop = YES;
            buttonTemp = obj;
        }
    }];
    return buttonTemp ? buttonTemp.currentTitle : @"";
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
     

@end
