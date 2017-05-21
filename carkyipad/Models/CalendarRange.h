

#import <UIKit/UIKit.h>

@interface CalendarRange : NSObject

@property (nonatomic, copy) NSDateComponents *startDay;
@property (nonatomic, copy) NSDateComponents *endDay;

// Designated initialiser
- (id)initWithStartDay:(NSDateComponents*)start endDay:(NSDateComponents*)end;

- (BOOL)containsDay:(NSDateComponents*)day;
- (BOOL)containsDate:(NSDate*)date;

@end
