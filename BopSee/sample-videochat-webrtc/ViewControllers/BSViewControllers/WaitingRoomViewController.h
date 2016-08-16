//
//  WaitingRoomViewController.h
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WaitingRoomViewController : BaseViewController 

@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;
@property (weak, nonatomic) IBOutlet UILabel *lblAwait;
@property (weak, nonatomic) IBOutlet UIView *viewDate1;
@property (weak, nonatomic) IBOutlet UIImageView *imgDate1;
@property (weak, nonatomic) IBOutlet UIView *viewDate2;
@property (weak, nonatomic) IBOutlet UIImageView *imgDate2;
@property (weak, nonatomic) IBOutlet UIView *viewDate3;
@property (weak, nonatomic) IBOutlet UIImageView *imgDate3;
@property (weak, nonatomic) IBOutlet UIView *viewDate4;
@property (weak, nonatomic) IBOutlet UIImageView *imgDate4;
@property (weak, nonatomic) IBOutlet UIView *viewDate5;
@property (weak, nonatomic) IBOutlet UIImageView *imgDate5;
@property (weak, nonatomic) IBOutlet UIView *viewDate6;
@property (weak, nonatomic) IBOutlet UIImageView *imgDate6;

@property (strong, nonatomic) NSString* sm_id;
@end
