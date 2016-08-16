//
//  ChooseSessionViewController.m
//  Bopsee
//
//  Created by Admin on 6/14/16.
//  Copyright © 2016 Brani. All rights reserved.
//

 
#import "ChooseSessionTableViewCell.h"

@interface ChooseSessionViewController (){
    NSMutableArray* availabilitySessions, *joinstate;
    NSString* selectedSessionDay, *selectedDay;
}

@property (nonatomic, strong) CalendarView * calendarView;

@end

@implementation ChooseSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    joinstate = [[NSMutableArray alloc] init];
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initData{
    
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init] ;
    [fomatter setDateFormat:@"yyyy-MM-dd"];
    selectedSessionDay = [fomatter stringFromDate:[NSDate date]];
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEE"];
    selectedDay = [dayFormatter stringFromDate:[NSDate date]];
    [self getAvailability:selectedSessionDay day:selectedDay];
}

- (void) getAvailability:(NSString*)date day:(NSString*)day{
    
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [dic setObject:date forKey:@"date"];
    [dic setObject:day forKey:@"day"];

    self.isLoadingBase = YES;
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [NSThread detachNewThreadSelector:@selector(requestAvailability:) toTarget:self withObject:dic];
    
}

#pragma mark - request availability times
- (void) requestAvailability:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_AVAILABILITY_TIME withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            NSMutableArray *availabilitys = [[NSMutableArray alloc] init];
            joinstate = availabilitys;
            availabilitys = [result objectForKey:@"availability"];
            availabilitySessions = availabilitys;
            for(NSMutableDictionary *session in availabilitys){
                if([[session objectForKey:@"join"] isEqualToString:@"1"]){
                    [joinstate addObject:@"1"];
                }
                else{
                    [joinstate addObject:@"0"];
                }
            }
            [_tableAvailability reloadData];
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please check selected date";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}


- (void) initView{
    
    //Alert View
    _viewAlertCon.layer.cornerRadius = 3.0f;
    _btnYes.layer.cornerRadius = 13.0f;
    _btnNo.layer.cornerRadius = 13.0f;
    _viewAlert.hidden = YES;
    
    //Calendar init
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"Default Calendar";
    _calendarView = [[CalendarView alloc]initWithFrame:CGRectMake(0, 80, [[UIScreen mainScreen] bounds].size.width - 20, [[UIScreen mainScreen] bounds].size.height - 280)];
    NSLog(@"Hight ------------------> %d", (int)[[UIScreen mainScreen] bounds].size.height);
    _calendarView.delegate    = self;
    _calendarView.datasource  = self;
    _calendarView.calendarDate = [NSDate date];
    _calendarView.monthAndDayTextColor        = [UIColor darkGrayColor];
    _calendarView.dayBgColorWithoutData       = [UIColor clearColor];
    _calendarView.dayBgColorSelected          = UIColorFromRGB(0xd51755);
    _calendarView.dayTxtColorWithoutData      = [UIColor darkGrayColor];
    _calendarView.dayTxtColorSelected         = [UIColor whiteColor];
    _calendarView.dayTxtColorEvent            = [UIColor redColor];;
    _calendarView.borderColor                 = [UIColor clearColor];
    
    _calendarView.allowsChangeMonthByDayTap   = YES;
    _calendarView.allowsChangeMonthByButtons  = YES;
    _calendarView.keepSelDayWhenMonthChange   = YES;
    _calendarView.nextMonthAnimation          = UIViewAnimationOptionTransitionFlipFromRight;
    _calendarView.prevMonthAnimation          = UIViewAnimationOptionTransitionFlipFromLeft;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.view addSubview:_calendarView];
        _calendarView.center = CGPointMake(self.view.center.x, _calendarView.center.y);
    });
    
}

- (IBAction)onBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSubmitClicked:(id)sender {
    BOOL isItem;
    isItem = NO;
    for(NSMutableDictionary *session in availabilitySessions){
        if([[session objectForKey:@"join"] isEqualToString:@"1"]){
            isItem = YES;
        }
    }
    if(isItem == YES){
        _viewAlert.hidden = NO;
        [self.view bringSubviewToFront:_viewAlert];
    }
    else{
        [commonUtils showVAlertSimple:@"Warning!" body:@"Please Choose Availability Sessions." duration:1.0];
    }
}

- (IBAction)onClickedYes:(id)sender {
    _viewAlert.hidden = YES;
    
    NSMutableArray *joinSessions = [[NSMutableArray alloc] init];
    int ix = 0;
    for(NSMutableDictionary *session in availabilitySessions){
        if([[session objectForKey:@"join"] isEqualToString:@"1"]){
            NSMutableArray *newSession = [[NSMutableArray alloc] init];
            [newSession addObject:[session objectForKey:@"datetime"]];
            [newSession addObject:@"1"];
            [joinSessions addObject:newSession];
        }
        else{
            if([[joinstate objectAtIndex:ix] isEqualToString:@"1"]){
                NSMutableArray *newSession = [[NSMutableArray alloc] init];
                [newSession addObject:[session objectForKey:@"datetime"]];
                [newSession addObject:@"0"];
                [joinSessions addObject:newSession];
            }
        }
        ix++;
    }
    
    if(self.isLoadingBase) return;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[appController.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [dic setObject:joinSessions forKey:@"join_sessions"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [format stringFromDate:[NSDate date]];
    [dic setObject:currentTime forKey:@"current_date"];
    
    self.isLoadingBase = YES;
    [JSWaiter ShowWaiter:self.view title:nil type:0];
    [NSThread detachNewThreadSelector:@selector(requestAvailabilitySubmit:) toTarget:self withObject:dic];

}

#pragma mark - request availability times submit
- (void) requestAvailabilitySubmit:(id) params {
    NSDictionary *resObj = nil;
    resObj = [commonUtils httpJsonRequest:API_URL_AVAILABILITY_SUBMIT  withJSON:params];
    
    self.isLoadingBase = NO;
    [JSWaiter HideWaiter];
    if (resObj != nil) {
        NSDictionary *result = (NSDictionary *)resObj;
        NSDecimalNumber *status = [result objectForKey:@"status"];
        if([status intValue] == 1) {
            
            appController.scheduledSessions = [[NSMutableArray alloc] init];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DashboardViewController* dashboardViewController =
            (DashboardViewController*) [storyboard instantiateViewControllerWithIdentifier:@"DashboardVC"];
            [self.navigationController pushViewController:dashboardViewController animated:YES];
            
            
        } else {
            NSString *msg = (NSString *)[resObj objectForKey:@"msg"];
            if([msg isEqualToString:@""]) msg = @"Please check selected date";
            [commonUtils showAlert:@"Warning" withMessage:msg];
        }
    } else {
        [commonUtils showAlert:@"Connection Error" withMessage:@"Please check your internet connection status"];
    }
}


- (IBAction)onClickedNo:(id)sender {
    _viewAlert.hidden = YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [availabilitySessions count];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChooseSessionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseSessionTableViewCell"];
    
    NSMutableDictionary *dic = [availabilitySessions objectAtIndex:indexPath.row];
    NSString *dateString = [dic objectForKey:@"datetime"];
  
    [cell.lblSessionDate setText:[commonUtils convertTimeFormat:dateString]];
    
    NSString* sessionState;
    UIColor*  txtColor;
    if([[dic objectForKey:@"join"] isEqualToString:@"1"])
    {
        sessionState = @"JOIN";
        txtColor = UIColorFromRGB(0x4CAB00);
        cell.imgJOIN.highlighted = NO;
    }
    else{
        sessionState = @" ";
        txtColor = [UIColor clearColor];
        cell.imgJOIN.highlighted = YES;
    }
    
    [cell.lblJOIN setText:sessionState];
    cell.lblJOIN.textColor = txtColor;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dic = [availabilitySessions objectAtIndex:indexPath.row];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myDate = [format dateFromString:[dic objectForKey:@"datetime"]];
    
    if ([myDate compare:[NSDate date]] == NSOrderedAscending) {
        [commonUtils showAlert:@"Warning" withMessage:@"Please check selected session and current time"];
        NSLog(@"selected Date is EARLIER than today");
    } else{
    
        if([[dic objectForKey:@"join"] isEqualToString:@"1"])
        {
            [dic setObject:@"0" forKey:@"join"];
        }
        else{
            [dic setObject:@"1" forKey:@"join"];
        }
        [availabilitySessions setObject:dic atIndexedSubscript:indexPath.row];
        [_tableAvailability reloadData];
    }
}

#pragma mark - CalendarDelegate protocol conformance

-(void)dayChangedToDate:(NSDate *)selectedDate
{
    NSLog(@"dayChangedToDate %@",selectedDate);
    
    NSDateFormatter *fomatter = [[NSDateFormatter alloc] init] ;
    [fomatter setDateFormat:@"yyyy-MM-dd"];
    selectedSessionDay = [fomatter stringFromDate:selectedDate];
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEE"];
    selectedDay = [dayFormatter stringFromDate:selectedDate];
    
    [self getAvailability:selectedSessionDay day:selectedDay];
    
    [_tableAvailability reloadData];
}


#pragma mark - CalendarDataSource protocol conformance

-(BOOL)isDataForDate:(NSDate *)date
{
   return NO;
}

- (BOOL) canSwipeToDate:(NSDate *)date {
    return YES;
}

@end
