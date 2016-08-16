//
//  MachesViewController.m
//  Bopsee
//
//  Created by Admin on 6/14/16.
//  Copyright © 2016 Brani. All rights reserved.
//

 
#import "MachesTableViewCell.h"

@interface MachesViewController (){
    NSMutableArray* matchedUsers;
}


@end

@implementation MachesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData{
    
    matchedUsers = [[NSMutableArray alloc] init];
    matchedUsers = appController.matchedUsers;
    if([matchedUsers count] < 1){
        
        if(self.isLoadingBase) return;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
        
        self.isLoadingBase = YES;
        [JSWaiter ShowWaiter:self.view title:nil type:0];
        [NSThread detachNewThreadSelector:@selector(requestMatchedUsers:) toTarget:self withObject:dic];
    }

}

#pragma mark - request scheduled sessions
- (void) requestMatchedUsers:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_MATCH_USERS withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            matchedUsers = [result objectForKey:@"matched_users"];
            appController.matchedUsers = matchedUsers;
            [_tableMaches reloadData];
        
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Sorry, We can't found the matched users";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}

- (void) initView{
    
}

- (IBAction)onBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [matchedUsers count];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MachesTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MachesTableViewCell"];
    
    NSMutableDictionary *dic = [matchedUsers objectAtIndex:indexPath.row];
    
    NSString *imageUrl = [dic objectForKey:@"user_photo_url"];
    if ([imageUrl isEqual:[NSNull null]]){
        [cell.imgMachedUser setImage:[UIImage imageNamed:@"person1"]];
    }else{
        [commonUtils setImageViewAFNetworking:cell.imgMachedUser withImageUrl:imageUrl withPlaceholderImage:[UIImage imageNamed:@"person1"]];
    }

    CGFloat cornerRadius = MAX(cell.imgMachedUser.frame.size.width, cell.imgMachedUser.frame.size.height);
    cell.imgMachedUser.layer.cornerRadius = cornerRadius/2;
    cell.imgMachedUser.layer.borderWidth = 1.0;
    cell.imgMachedUser.layer.borderColor = [UIColor grayColor].CGColor;
    cell.imgMachedUser.clipsToBounds = YES;

    cell.lblName.text = [dic objectForKey:@"user_full_name"];
    
    cell.btnChat.tag = indexPath.row;
    [cell.btnChat addTarget:self action:@selector(selectedChat:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)selectedChat:(UIButton*) sender{
    
    NSMutableDictionary *chatUser = [matchedUsers objectAtIndex:sender.tag];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController* chatViewController =
    (ChatViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
    chatViewController.receiverInfo = chatUser;
    [self.navigationController pushViewController:chatViewController animated:YES];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *action;
        action =[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"    DELETED  " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
        }];
        action.backgroundColor = UIColorFromRGB(0x5bb000);
        
        [self performSelector:@selector(delay:) withObject:indexPath afterDelay:2.0];
    return @[action];
}

-(void) delay:(NSIndexPath *) indexPath {
    [matchedUsers removeObjectAtIndex:indexPath.row];
    appController.matchedUsers = matchedUsers;
   // [_selectedContacts removeObjectAtIndex:indexPath.row];
    [_tableMaches reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

@end
