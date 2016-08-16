//
//  ChatViewController.h
//  Bopsee
//
//  Created by Admin on 6/14/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgReceiverUser;
@property (weak, nonatomic) IBOutlet UILabel *lblReceiverName;

@property (weak, nonatomic) IBOutlet UIView         *viewBack;
@property (weak, nonatomic) IBOutlet UITableView    *chatHistoryTable;
@property (weak, nonatomic) IBOutlet UITextView     *txtMessage;
@property (weak, nonatomic) IBOutlet UIButton       *btnSend;

@property (strong, nonatomic) NSMutableDictionary   *receiverInfo;

@end
