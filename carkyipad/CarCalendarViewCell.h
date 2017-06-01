//
//  CarCalendarViewCell.h


#import <UIKit/UIKit.h>
#import "FSCalendar.h"

typedef NS_ENUM(NSUInteger, SelectionType) {
    SelectionTypeNone,
    SelectionTypeSingle,
    SelectionTypeLeftBorder,
    SelectionTypeMiddle,
    SelectionTypeRightBorder
};

@interface CarCalendarViewCell : FSCalendarCell

@property (weak, nonatomic) UIImageView *circleImageView;
@property (weak, nonatomic) CAShapeLayer *selectionLayer;
@property (weak, nonatomic) CAShapeLayer *circleLayer;
@property (assign, nonatomic) SelectionType selectionType;

@end
