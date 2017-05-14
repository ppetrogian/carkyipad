//
//  PlaceDetailsView.h
//  SampleProjectPoc
//
//  Created by Avinash Kashyap on 10/05/17.
//  Copyright © 2017 Avinash Kashyap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceDetailsView : UIView
@property (strong, nonatomic) IBOutlet UIView *xibView;
@property (nonatomic, weak) IBOutlet UIImageView *placeImageView;
@property (nonatomic, weak) IBOutlet UILabel *placeLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateValueLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeValueLabel;
-(void) setPlaceLableText:(NSString *)text andImage:(NSString *)imageName;
-(void) setAllDetails:(NSDictionary *)dict isForPickup:(BOOL)pickup;
@end
