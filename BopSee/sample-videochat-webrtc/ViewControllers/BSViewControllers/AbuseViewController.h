//
//  AbuseViewController.h
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AbuseViewController : BaseViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imgDate;
@property (weak, nonatomic) IBOutlet UIButton *btnAbuse;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIButton *btnCow;
@property (weak, nonatomic) IBOutlet UIButton *btnBooks;
@property (weak, nonatomic) IBOutlet UIButton *btnArt;
@property (weak, nonatomic) IBOutlet UIButton *btnHiking;

@property (strong, nonatomic) NSMutableDictionary   *dateInfo;
@property (strong, nonatomic) NSString              *dateNumber;
@end
