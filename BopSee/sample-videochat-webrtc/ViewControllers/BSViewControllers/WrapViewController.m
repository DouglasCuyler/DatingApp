//
//  WrapViewController.m
//  Bopsee
//
//  Created by Admin on 6/15/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "WrapViewController.h"
#import "MachesTableViewCell.h"

@interface WrapViewController (){
    
    NSMutableArray *seeUsers, *guessUsers;
}
@end

@implementation WrapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData{
    seeUsers = [[NSMutableArray alloc] init];
    guessUsers = [[NSMutableArray alloc] init];
    seeUsers = appController.seeUsers;
    guessUsers = appController.guessUsers;
}

- (void) initView{
    
    if([seeUsers count] == 0){
        _viewNo.hidden = NO;
        _viewSee.hidden = YES;
    }
    else{
        _viewNo.hidden = YES;
        _viewSee.hidden = NO;
    }
    if([guessUsers count] == 0){
        _viewGuess.hidden = YES;
    }
    else{
        _viewGuess.hidden = NO;
    }

}

- (IBAction)onSignUpClicked:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChooseSessionViewController* chooseSessionViewViewController =
    (ChooseSessionViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ChooseSessionVC"];
    [self.navigationController pushViewController:chooseSessionViewViewController animated:YES];
}

- (IBAction)onDoneClicked:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DashboardViewController* dashBoardViewController =
    (DashboardViewController*) [storyboard instantiateViewControllerWithIdentifier:@"DashboardVC"];
    [self.navigationController pushViewController:dashBoardViewController animated:YES];
}

- (IBAction)onBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _tableSee){
        return [seeUsers count];
    }
    else{
        return [guessUsers count];
    }
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MachesTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MachesTableViewCell"];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if(tableView == _tableSee){
        dic = [seeUsers objectAtIndex:indexPath.row];
    }
    else{
        dic = [guessUsers objectAtIndex:indexPath.row];
    }
    
    [cell.imgMachedUser setImage:[UIImage imageNamed:[dic objectForKey:@"image"]]];
    
    CGFloat cornerRadius = MAX(cell.imgMachedUser.frame.size.width, cell.imgMachedUser.frame.size.height);
    cell.imgMachedUser.layer.cornerRadius = cornerRadius/2;
    cell.imgMachedUser.layer.borderWidth = 1.0;
    cell.imgMachedUser.layer.borderColor = [UIColor grayColor].CGColor;
    cell.imgMachedUser.clipsToBounds = YES;
    
    cell.lblName.text = [dic objectForKey:@"name"];
    
    cell.btnChat.tag = indexPath.row;
    [cell.btnChat addTarget:self action:@selector(selectedChat:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)selectedChat:(UIButton*) sender {
    
    NSMutableDictionary *chatUser = [[NSMutableDictionary alloc] init];

    MachesTableViewCell* cell = (MachesTableViewCell *)(sender.superview.superview);
    
    if (cell == [_tableSee cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]]) {
        chatUser = [seeUsers objectAtIndex:sender.tag];
    } else{
        chatUser = [guessUsers objectAtIndex:sender.tag];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatViewController* chatViewController =
    (ChatViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ChatVC"];
    chatViewController.receiverInfo = chatUser;
    [self.navigationController pushViewController:chatViewController animated:YES];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
