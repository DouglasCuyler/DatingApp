//
//  DashboardTableViewCell.h
//  Bopsee
//
//  Created by Admin on 6/14/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblScheduled;
@property (weak, nonatomic) IBOutlet UILabel *lblScheduleState;

@end
