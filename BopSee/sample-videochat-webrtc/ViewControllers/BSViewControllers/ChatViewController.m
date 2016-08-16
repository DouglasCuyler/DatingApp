//
//  ChatViewController.m
//  Bopsee
//
//  Created by Admin on 6/14/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageTableViewCell.h"

@interface ChatViewController (){
    
    NSMutableArray *_chatHistoryArray;
    NSString *_limit, *_allcount;
}

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self registerNotifications];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    
    _txtMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtMessage.layer.borderWidth = 2.0f;
    _txtMessage.layer.cornerRadius = 3.0f;
    self.chatHistoryTable.delegate = self;
    self.chatHistoryTable.dataSource = self;
    _txtMessage.delegate = self;
    [self.btnSend setImage:[UIImage imageNamed:@"ic_send_disabled"] forState:UIControlStateNormal];
    self.btnSend.userInteractionEnabled = NO;
    
    NSString *imageUrl = [_receiverInfo objectForKey:@"user_photo_url"];
    if ([imageUrl isEqual:[NSNull null]]){
        [_imgReceiverUser setImage:[UIImage imageNamed:@"person1"]];
    }else{
        [commonUtils setImageViewAFNetworking:_imgReceiverUser withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"person1"]];
    }
    
    CGFloat cornerRadius = MAX(_imgReceiverUser.frame.size.width, _imgReceiverUser.frame.size.height);
    _imgReceiverUser.layer.cornerRadius = cornerRadius/2;
    _imgReceiverUser.clipsToBounds = YES;
    
    _lblReceiverName.text = [_receiverInfo objectForKey:@"user_full_name"];
    
}

- (void)initData {
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy, hh:mm a"];
    
    _chatHistoryArray = [[NSMutableArray alloc] init];
    
}

- (IBAction)onBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSendSuccess {
    
    //send message api call
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy, hh:mm a"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    NSMutableDictionary* sendMessage = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Me", @"Sender",
                                        _txtMessage.text, @"Message",
                                        dateString, @"SentOn", nil];
    
    [_chatHistoryArray insertObject:sendMessage atIndex:0];
    [self.chatHistoryTable reloadData];
    [self scrollToNewestMessage];
    _txtMessage.text = @" ";
    [self textViewDidChange:_txtMessage];
    
}

- (IBAction)sendClicked:(id)sender {
    
    [_txtMessage resignFirstResponder];
    if (_txtMessage.text.length > 0 && ![_txtMessage.text isEqualToString:@" "]) {
        [self scrollToNewestMessage];
        [self performSelector:@selector(onSendSuccess) withObject:nil afterDelay:0.5];
    }
    
}

- (void) scrollToNewestMessage
{
    // The newest message is at the bottom of the table
    if (_chatHistoryArray.count > 0)
    {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(_chatHistoryArray.count - 1) inSection:0];
        [self.chatHistoryTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return _chatHistoryArray.count ;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"MessageCellIdentifier";
    NSString *cellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    MessageTableViewCell* cell = (MessageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.clipsToBounds = YES;
    cell.contentView.clipsToBounds = YES;
    
    [cell setMessage:[_chatHistoryArray objectAtIndex:_chatHistoryArray.count - indexPath.row -1 ]];
    
    
    return cell;
}

#pragma mark -
#pragma mark UITableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat heightCell;
    NSDictionary *message = [_chatHistoryArray objectAtIndex:_chatHistoryArray.count - indexPath.row -1];
    NSString* messagetxt = [message objectForKey:@"Message"];
    
    // if([[message objectForKey:@"Message"] rangeOfString:@"http://"].location == NSNotFound){
    if(messagetxt == nil) messagetxt = @" ";
    CGSize bubbleSize = [SpeechBubbleView sizeForText:messagetxt];
    heightCell = bubbleSize.height + 26;
    //}
    //    else{
    //        heightCell = 100;
    //    }
    return heightCell;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        [self.btnSend setImage:[UIImage imageNamed:@"ic_send_disabled"] forState:UIControlStateNormal];
        self.btnSend.userInteractionEnabled = NO;
    } else {
        [self.btnSend setImage:[UIImage imageNamed:@"ic_send_enabled"] forState:UIControlStateNormal];
        self.btnSend.userInteractionEnabled = YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}


// Setting up keyboard notifications.
- (void)registerNotifications
{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(receiveMessage:)
//                                                 name:APP_DidReceiveMessagePush object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGPoint viewOrigin = self.viewBack.frame.origin;
    CGSize viewSize = self.viewBack.frame.size;
    viewSize.height = [[UIScreen mainScreen] bounds].size.height - viewOrigin.y - kbSize.height;
    [self.viewBack setFrame:CGRectMake(viewOrigin.x, viewOrigin.y, viewSize.width, viewSize.height)];
    [self scrollToNewestMessage];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    CGPoint viewOrigin = self.viewBack.frame.origin;
    CGSize viewSize = self.viewBack.frame.size;
    viewSize.height = [[UIScreen mainScreen] bounds].size.height - viewOrigin.y;
    [self.viewBack setFrame:CGRectMake(viewOrigin.x, viewOrigin.y, viewSize.width, viewSize.height)];
}


@end


