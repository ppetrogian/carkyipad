//
//  CarTypeSegmentView.h
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 10/05/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KSegmentIndexTagPadding 100
#define KindicatorTag 59
#define KsegmentSpace 5

@protocol CarSegmentDelegate <NSObject>

-(void) didSelectedSegmentIndex:(NSInteger)index;

@end

@interface CarTypeSegmentView : UIView

//an array of string
@property (nonatomic, strong) NSArray *segmentList;
@property (nonatomic, weak) id <CarSegmentDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedIndex;
-(void) setSelectedSegmentIndex:(NSInteger)index;
-(void) setAllSegmentList:(NSArray *)list;
-(void) updateSegmentFrame:(CGRect)frame;
-(void) updateSegmentTitles:(NSArray *)list;
-(instancetype) initWithFrame:(CGRect)frame withSegmentList:(NSArray *)list;
-(UIButton *) getSegmentedButtonForIndex:(NSInteger)index;
@end
