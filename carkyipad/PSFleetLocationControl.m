//
//  PSFleetLocationControl.m
//  carkyipad
//
//  Created by Filippos Sakellaropoulos on 25/03/2017.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import "PSFleetLocationControl.h"
#import "PSLocationButton.h"

@interface PSFleetLocationControl ()
@end

@implementation PSFleetLocationControl

BOOL _initialized = NO;

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self == [super initWithCoder:aDecoder]){
        _initialized = NO;
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    _initialized = NO;
    if (self) [self setupView];
    return self;
}


-(void)setupView {
    if (_initialized || !self.locationButtons.count) {
        return;
    }
    for(NSInteger i=0; i<_locationButtons.count; i++) {
        // set the button images
        PSLocationButton *button = self.locationButtons[i];
        //if(!button.onImage) return;
        
        // Setup the button action
        [button addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setSelected:YES];
    };
    _initialized = YES;
}


-(IBAction) radioButtonClicked:(PSLocationButton *) sender {
    [self.locationButtons enumerateObjectsUsingBlock:^(PSLocationButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.highlighted = NO;
        obj.selected = obj.location != sender.location ? NO : YES;
        if (obj.selected) {
            [self.delegate fleetLocationChanged:self withValue:sender.location];
        }
    }];
}
     
-(NSString *)selectedName {
    __block UIButton *buttonTemp;
    [self.locationButtons enumerateObjectsUsingBlock:^(PSLocationButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.selected) {
            *stop = YES;
            buttonTemp = obj;
        }
    }];
    return buttonTemp ? buttonTemp.currentTitle : @"";
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//#if IB_INTERFACE_BUILDER
    // Drawing code
    [self setupView];
}

     

@end
