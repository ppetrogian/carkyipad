//
//  CarCalendarViewCell.m

 
#import "CarCalendarViewCell.h"
#import "FSCalendar.h"
#import "FSCalendarExtensions.h"

@implementation CarCalendarViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // gray selection layer
        CAShapeLayer *selectionLayer = [[CAShapeLayer alloc] init];
        self.selectionLayer.strokeColor = nil;
        self.selectionLayer.fillColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0].CGColor;
        selectionLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:selectionLayer below:self.titleLabel.layer];
        self.selectionLayer = selectionLayer;
        self.shapeLayer.hidden = YES;
        // circle layer for begin-end
        CAShapeLayer *circleLayer = [[CAShapeLayer alloc] init];
        circleLayer.strokeColor = [UIColor colorWithRed:0.22 green:0.75 blue:0.76 alpha:1.0].CGColor;
        circleLayer.fillColor = nil;
        circleLayer.actions = @{@"hidden":[NSNull null]};
        [self.contentView.layer insertSublayer:circleLayer below:self.titleLabel.layer];
        self.circleLayer = circleLayer;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.fs_top += 4;
    self.backgroundView.frame = CGRectInset(self.bounds, 1, 1);
   
    self.selectionLayer.frame = self.bounds;
    self.circleLayer.frame = self.bounds;
    CGFloat dx = MIN(self.selectionLayer.fs_height, self.selectionLayer.fs_width)-5;
    CGFloat dy = dx;
    
    if (self.selectionType == SelectionTypeMiddle) {
        self.circleLayer.hidden = YES;
        // middle
        self.selectionLayer.fillColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0].CGColor;
        self.selectionLayer.path = [UIBezierPath bezierPathWithRect: CGRectOffset(CGRectInset(self.selectionLayer.bounds, 0, 8), 0, 0) ].CGPath;
     } else if (self.selectionType == SelectionTypeLeftBorder || self.selectionType == SelectionTypeRightBorder) {
        // single
        self.circleLayer.hidden = NO;
        self.selectionLayer.fillColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0].CGColor;
        self.circleLayer.strokeColor = [UIColor colorWithRed:0.22 green:0.75 blue:0.76 alpha:1.0].CGColor;
        self.circleLayer.fillColor = [UIColor whiteColor].CGColor;
        NSInteger xOffset = self.selectionType == SelectionTypeLeftBorder ? self.contentView.fs_width/2+2 : 0;
        CGRect halfBounds = CGRectMake(xOffset, 0, self.selectionLayer.bounds.size.width/2, self.selectionLayer.bounds.size.height);
        self.selectionLayer.path = [UIBezierPath bezierPathWithRect: CGRectOffset(CGRectInset(halfBounds, 0, 8), 0, 0) ].CGPath;
        self.circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.contentView.fs_width/2-dx/2, self.contentView.fs_height/2-dy/2, dx, dy)].CGPath;
    }
}

- (void)configureAppearance
{
    [super configureAppearance];
    // Override the build-in appearance configuration
    if (self.isPlaceholder) {
        self.titleLabel.textColor = [UIColor lightGrayColor];
        self.eventIndicator.hidden = YES;
    }
}

- (void)setSelectionType:(SelectionType)selectionType
{
    if (_selectionType != selectionType) {
        _selectionType = selectionType;
        [self setNeedsLayout];
    }
}



@end
