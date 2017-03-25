

#import <UIKit/UIKit.h>
@interface MIRadioButtonGroup : UIView {
	NSMutableArray *radioButtons;

}

@property (nonatomic,retain) NSMutableArray *radioButtons;

- (id)initWithFrame:(CGRect)frame andOptions:(NSArray *)options andColumns:(int)columns;
-(IBAction) radioButtonClicked:(UIButton *) sender;
-(void) removeButtonAtIndex:(int)index;
-(void) setSelected:(int) index;
-(void)clearAll;
@end
