//
//  StepSegmentControllerView.h
//  carkyipad
//
//  Created by Avinash Kashyap on 11/05/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarTypeSegmentView.h"

@interface StepSegmentControllerView : UIView
{

}
//an array of string
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *segmentList;
//@property (nonatomic, weak) id <CarSegmentDelegate> delegate;
-(void) setSelectedSegmentIndex:(NSInteger)index;
-(void) setAllSegmentList:(NSArray *)list;
-(void) updateSegmentFrame:(CGRect)frame;
-(void) updateSegmentTitles:(NSArray *)list;
-(instancetype) initWithFrame:(CGRect)frame withSegmentList:(NSArray *)list;
-(UIButton *)getButtonForIndex:(NSInteger)index;
@end
