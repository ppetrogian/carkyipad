//
//  CarTypeSegmentView.m
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 10/05/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import "CarTypeSegmentView.h"

@implementation CarTypeSegmentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype) initWithFrame:(CGRect)frame withSegmentList:(NSArray *)list{
    self = [super initWithFrame:frame];
    if (self) {
        self.segmentList = list;
        [self defaultSetup];
    }
    return self;
}
-(instancetype) init{
    self = [super init];
    if (self) {
        [self defaultSetup];
    }
    return self;
}
-(void) awakeFromNib{
    [super awakeFromNib];
}
-(void) setAllSegmentList:(NSArray *)list{
    self.segmentList = list;
    [self defaultSetup];
}
-(void) defaultSetup{
    [self addAllSegment];
    [self currentSelectedIndex:KSegmentIndexTagPadding+0];
}
-(void) updateSegmentFrame:(CGRect)frame{
    self.frame = frame;
    [self addAllSegment];
}
-(void) addAllSegment{
    int i = 0;
    CGFloat width = (self.frame.size.width - (self.segmentList.count - 1)*KsegmentSpace)/self.segmentList.count;
    for (NSString *titleText in self.segmentList) {
        UIButton *segmentBtn = [self initializeSegmentButton:i withTitle:titleText];
        segmentBtn.frame = CGRectMake(width*i+KsegmentSpace*i, 0, width, self.frame.size.height);
        [self addUpperCornorToView:segmentBtn];
        [self addSubview:segmentBtn];
        i++;
    }//end for loop
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, self.frame.size.width, 2)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    bottomLineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:bottomLineView];
}
-(UIButton *) initializeSegmentButton:(NSInteger)index withTitle:(NSString *)title{
    UIButton *segButton;
    NSInteger indexTag = KSegmentIndexTagPadding+index;
    segButton = [self getButtonForIndex:indexTag];
    if (segButton==nil) {
        segButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [segButton addTarget:self action:@selector(segmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        segButton.backgroundColor = [UIColor clearColor];
        [segButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        segButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        segButton.tag = indexTag;
        //add shape layer
    }
    [segButton setTitle:title forState:UIControlStateNormal];
    //[self addSubview:segButton];
    return segButton;
}
-(void) addUpperCornorToView:(UIView *)sender{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //shapeLayer.bounds = sender.bounds;
    //set path for CAShapeLayer property's 'path'
    UIBezierPath *shapePath =[UIBezierPath bezierPathWithRoundedRect:sender.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    //set CAShapeLayer Path
    shapeLayer.path = shapePath.CGPath;
    //Add CAShapeLayer to subview
    sender.layer.mask = shapeLayer;
}

-(UIButton *) getSegmentedButtonForIndex:(NSInteger)index{
    return [self getButtonForIndex:index + KSegmentIndexTagPadding];
}

-(UIButton *) getButtonForIndex:(NSInteger)index{
    UIButton *segButton;
    segButton = [self viewWithTag:index];
    return segButton;
}


-(void) segmentButtonAction:(UIButton *)sender{
    if (self.selectedIndex == sender.tag) {
        NSLog(@"Already selected");
        return;
    }
    [self currentSelectedIndex:sender.tag];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSegmentIndex:)]) {
        [self.delegate didSelectedSegmentIndex:sender.tag - KSegmentIndexTagPadding];
    }
}

#pragma mark -
-(void) setSelectedSegmentIndex:(NSInteger)index{
    [self currentSelectedIndex:KSegmentIndexTagPadding+index];
}
-(void) currentSelectedIndex:(NSInteger)index{
    UIButton *segButton;
    for(int i=0; i<self.segmentList.count;i++){
        NSInteger indexTag = KSegmentIndexTagPadding+i;
        segButton = [self getButtonForIndex:indexTag];
        if (indexTag == index) {
            self.selectedIndex = indexTag;
            [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [segButton setBackgroundColor:[UIColor blackColor]];
            [self updateIndicatorForSelectedButtonFrame:segButton.frame];
        }
        else{
            [segButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [segButton setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
}
-(void) updateIndicatorForSelectedButtonFrame:(CGRect)frame{
    UIView *indicatorView = [self viewWithTag:KindicatorTag];
    CGFloat h = 2;
    if (indicatorView == nil) {
        indicatorView = [self initializeIndicatorImageView:indicatorView];
        indicatorView.frame = CGRectMake(0, frame.size.height-h, frame.size.width, h);
    }
    CGFloat x = frame.origin.x + frame.size.width/2;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        indicatorView.center = CGPointMake(x, frame.size.height-h/2);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}
-(UIView *) initializeIndicatorImageView:(UIView *)indicatorView{
    indicatorView = [[UIImageView alloc] init];
    indicatorView.backgroundColor = [UIColor blackColor];
    //imageView.image = [UIImage imageNamed:@"indicator_arrow.png"];
    //imageView.contentMode = UIViewContentModeScaleAspectFit;
    indicatorView.tag = KindicatorTag;
    [self addSubview:indicatorView];
    return indicatorView;
}
@end
