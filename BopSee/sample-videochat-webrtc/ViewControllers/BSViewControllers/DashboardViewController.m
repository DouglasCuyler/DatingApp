//
//  DashboardViewController.m
//  Bopsee
//
//  Created by Admin on 6/13/16.
//  Copyright © 2016 Brani. All rights reserved.
//

#import "DashboardViewController.h"
#import "DashboardTableViewCell.h"



@interface DashboardViewController (){
    NSMutableArray* scheduledSessions;
    NSString* sm_id;
    int deletsessionIndex;
}

@property (strong, nonatomic) Settings *settings;

@end

@implementation DashboardViewController

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
    scheduledSessions = appController.scheduledSessions;
    if([scheduledSessions count] < 1){
        
        if(self.isLoadingBase) return;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentTime = [format stringFromDate:[NSDate date]];
        [dic setObject:currentTime forKey:@"current_date"];
        
        self.isLoadingBase = YES;
        [JSWaiter ShowWaiter:self.view title:nil type:0];
        [NSThread detachNewThreadSelector:@selector(requestSessions:) toTarget:self withObject:dic];
    }
}

#pragma mark - request scheduled sessions
- (void) requestSessions:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_SCHEDULED_SESSIONS withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            NSMutableArray *sessions = [[NSMutableArray alloc] init];
            sessions = [result objectForKey:@"scheduled_sessions"];
            scheduledSessions = sessions;
            appController.scheduledSessions = scheduledSessions;
            if([scheduledSessions count] == 0){
                [commonUtils showAlert:@"Warning" withMessage:@"There is no scheduled sessions. Please create the sessions"];
            }
            [_tableScheduledSessions reloadData];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"We can't found the scheduled sessions";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}

- (void) initView{
    //Alert View
    _viewAlertCon.layer.cornerRadius = 3.0f;
    _btnYes.layer.cornerRadius = 15.0f;
    _viewAlert.hidden = YES;
    
    //Alert View
    _viewAlertConD.layer.cornerRadius = 3.0f;
    _btnYesD.layer.cornerRadius = 13.0f;
    _btnNoD.layer.cornerRadius = 13.0f;
    _viewAlertD.hidden = YES;
}


- (IBAction)onClickedSetting:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingsViewController* settingsViewViewController =
    (SettingsViewController*) [storyboard instantiateViewControllerWithIdentifier:@"SettingsVC"];
    [self.navigationController pushViewController:settingsViewViewController animated:YES];
}

- (IBAction)onClickedHeart:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MachesViewController* matchesViewController =
    (MachesViewController*) [storyboard instantiateViewControllerWithIdentifier:@"MatchesVC"];
    [self.navigationController pushViewController:matchesViewController animated:YES];
}

- (IBAction)onClickedPluse:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChooseSessionViewController* chooseSessionViewViewController =
    (ChooseSessionViewController*) [storyboard instantiateViewControllerWithIdentifier:@"ChooseSessionVC"];
    [self.navigationController pushViewController:chooseSessionViewViewController animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [scheduledSessions count];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DashboardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DashboardTableViewCell"];
    
    NSMutableDictionary *dic = [scheduledSessions objectAtIndex:indexPath.row];
    
    NSString *dateString = [dic objectForKey:@"datetime"];
    [cell.lblScheduled setText:[commonUtils convertTimeFormat:dateString]];
    
    NSString* sessionState = @" ";
    UIColor*  txtColor = [UIColor whiteColor];
    switch ([[dic objectForKey:@"session_state"] intValue]) {
        
        case SESSION_STATE_CONFIRM:
            
            sessionState = @"Confirmed";
            txtColor = UIColorFromRGB(0x4CAB00);
            
            break;
            
        case SESSION_STATE_PENDING:

            sessionState = @"Pending";
            txtColor = UIColorFromRGB(0xff9c00);
            break;

        case SESSION_STATE_CANCEL:
        
            sessionState = @"Cancelled";
            txtColor = UIColorFromRGB(0x888888);
            break;

        default:
            break;
    }
    
    [cell.lblScheduleState setText:sessionState];
    cell.lblScheduleState.textColor = txtColor;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSMutableDictionary *dic = [scheduledSessions objectAtIndex:indexPath.row];
//    if([[dic objectForKey:@"session_state"] isEqualToString:@"2"]) return NO;
//    else return YES;
    return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        UITableViewRowAction *action;
    action =[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"    Cancel  " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
    }];
    action.backgroundColor = UIColorFromRGB(0x5bb000);
    
    [self performSelector:@selector(delay:) withObject:indexPath afterDelay:0.5];
    return @[action];
    
}

-(void) delay:(NSIndexPath *) indexPath {
    _viewAlertD.hidden = NO;
    deletsessionIndex = (int)indexPath.row;
}

- (IBAction)onClickedNoD:(id)sender {
    _viewAlertD.hidden = YES;
    [_tableScheduledSessions reloadData];
}

- (IBAction)onClickedYesD:(id)sender {
    _viewAlertD.hidden = YES;
    [self sessionDelete];
}

- (void) sessionDelete{
    
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    NSString *deleteSessionid = [[scheduledSessions objectAtIndex:deletsessionIndex] objectForKey:@"session_id"];
    [dic setObject:deleteSessionid forKey:@"session_id"];
    
    [scheduledSessions removeObjectAtIndex:deletsessionIndex];
    [_tableScheduledSessions reloadData];
    
    self.isLoadingBase = YES;
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [NSThread detachNewThreadSelector:@selector(requestDeleteSession:) toTarget:self withObject:dic];

}
#pragma mark - request delete session
- (void) requestDeleteSession:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_DELETE_SESSION withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"We can't delete the session";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
     NSMutableDictionary *dic = [scheduledSessions objectAtIndex:indexPath.row];
    if([[dic objectForKey:@"session_state"] isEqualToString:@"2"]){
        sm_id = [dic objectForKey:@"sm_id"];
        appController.sm_id = sm_id;
        NSString *session_time = [commonUtils convertTimeFormat:[dic objectForKey:@"datetime"]];
        _lblAlert.text = [NSString stringWithFormat:@"Your seesion will start on %@", session_time];
        _viewAlert.hidden = NO;
    }
    else{
        
        if([[dic objectForKey:@"session_state"] isEqualToString:@"1"]){
            _lblAlert.text = @"Based on your preferences there are not enough people for your session.";
            _viewAlert.hidden = NO;
        }
        else{
            _lblAlert.text = @"Based on your preferences there were not enough people for your session.";
            _viewAlert.hidden = NO;
        }
    }
}

- (IBAction)onClickedOK:(id)sender {
    
    if ([_lblAlert.text rangeOfString:@"start"].location == NSNotFound){
            _viewAlert.hidden = YES;
    }
    else{
        _viewAlert.hidden = YES;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WaitingRoomViewController* waitingRoomViewController =
        (WaitingRoomViewController*) [storyboard instantiateViewControllerWithIdentifier:@"WatingRoomVC"];
        waitingRoomViewController.sm_id = sm_id;
        appController.sm_id = sm_id;
        [self.navigationController pushViewController:waitingRoomViewController animated:YES];

    }
}

@end
