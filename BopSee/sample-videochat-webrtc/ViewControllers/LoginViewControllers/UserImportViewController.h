//
//  UserImportViewController.h
//  Bopsee
//
//  Created by Admin on 6/13/16.
//  Copyright © 2016 John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserImportViewController : UserBaseViewController

@property (weak, nonatomic) IBOutlet UIView *viewUserImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgUser;

@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnDecline;

@property (strong, nonatomic) NSDictionary* userFBInfo;

@end
