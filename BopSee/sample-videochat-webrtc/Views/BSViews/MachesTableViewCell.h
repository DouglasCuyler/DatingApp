//
//  MachesTableViewCell.h
//  Bopsee
//
//  Created by Admin on 6/14/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MachesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgMachedUser;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnChat;

@end
