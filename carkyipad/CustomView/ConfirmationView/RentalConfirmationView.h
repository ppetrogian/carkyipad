//
//  RentalConfirmationVieew.h
//  carkyipad
//
//  Created by Avinash Kashyap on 11/05/17.
//  Copyright © 2017 Nessos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentalConfirmationView : UIView
@property (nonatomic, weak) IBOutlet UIView *headerView;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UILabel *pickupAddressLabel;
@property (nonatomic, weak) IBOutlet UILabel *dropoffAddressLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickupDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *dropoffDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *pickupTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *dropoffTimeLabel;
//-----------
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *reservationLabel;
@property (nonatomic, weak) IBOutlet UILabel *durationLabel;
//-------------------
@property (nonatomic, weak) IBOutlet UILabel *extrasPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *extrasItemsLabel;
@property (nonatomic, weak) IBOutlet UILabel *insurancePriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *insuranceItemsLabel;
@property (nonatomic, weak) IBOutlet UILabel *carPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *carTypeImageView;
@property (weak, nonatomic) IBOutlet UIButton *bookingNewBtn;

@end
