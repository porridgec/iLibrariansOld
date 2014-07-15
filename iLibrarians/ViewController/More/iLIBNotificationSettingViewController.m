//
//  iLIBNotificationSettingViewController.m
//  iLibrarians
//
//  Created by lanny on 12/6/13.
//  Copyright (c) 2013 Bloodshed. All rights reserved.
//

#import "iLIBNotificationSettingViewController.h"
#import "NSDate+RFC1123.h"
#import "iLIBLocalNotificationManager.h"
#import "iLIBAppDelegate.h"
#import "iLIBEngine.h"
@interface iLIBNotificationSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    CGRect kPickerFrameShow;
    CGRect kPickerFrameHide;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) UIDatePicker *datePicker;
@property (strong,nonatomic) UIPickerView *pickerView;

@property (strong,nonatomic) iLIBEngine *iLibEngine;
@end

@implementation iLIBNotificationSettingViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) initUserInterface{
    [self setTitle:@"提醒设置"];
    CGFloat viewHeight = [UIScreen mainScreen].bounds.size.height;
    kPickerFrameShow = CGRectMake(0, viewHeight - 162, 320, 162);
    kPickerFrameHide = CGRectMake(0, viewHeight, 320, 162);
    
    self.datePicker = [[UIDatePicker alloc] initWithFrame:kPickerFrameHide];
    [self.datePicker setDatePickerMode:UIDatePickerModeTime];
    [self.datePicker setMinuteInterval:15];
    [self setIsPickerShow:NO];
    [self.datePicker addTarget:self action:@selector(didChangeDatePickerValue:) forControlEvents:UIControlEventValueChanged];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.datePicker];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:kPickerFrameHide];
    [self.pickerView setShowsSelectionIndicator:YES];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initUserInterface];
    [self setIsChangedSetting:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.pickerView setDelegate:nil];
    [self.datePicker removeTarget:self action:@selector(didChangeDatePickerValue:) forControlEvents:UIControlEventValueChanged];
    
    [self showPickerWithPicker:self.pickerView toggle:NO animation:YES];
    [self showPickerWithPicker:self.datePicker toggle:NO animation:YES];
    [self.pickerView removeFromSuperview];
    [self.datePicker removeFromSuperview];
    
    
    
    if (self.isChangedSetting) {
        [self settingViewControllerDidChangedSetting];
        
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0){
        return 1;
    }
    else {
        BOOL shouldRemindMe = [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldRemindeMe"];
        if(shouldRemindMe){
            return 4;
        }
        else {
            return 1;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 4;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==0){
        return 47;
    }
    else return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIImageView *background = [[UIImageView alloc] init];
        [background setFrame:CGRectMake(0, 0, 320, 47)];
        [background setBackgroundColor:[UIColor clearColor]];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, 280, 15)];
        [titleLabel setFont:[UIFont systemFontOfSize:9]];
        [titleLabel setTextColor:[UIColor colorWithRed:(125.0 / 255.0) green:(138.0 / 255.0) blue:(149.0 / 255.0) alpha:1]];
        [titleLabel setShadowColor:[UIColor whiteColor]];
        [titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setText:@"请在iPhone的\"设置\"－\"通知\"功能中，找到应用程序进行更改。"];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [background addSubview:titleLabel];
        
        return background;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        static NSString *CellIdentifier = @"FloatNotificationCellIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [[cell textLabel] setText:@"图书漂流消息通知"];
        return cell;
    }
    else {
        if(indexPath.row == 0){
            static NSString *cellIdentifier = @"remindMeIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.textLabel setText:@"提醒我还书"];
                
                UISwitch *reminderSwitch = [[UISwitch alloc] init];
                [cell setAccessoryView:reminderSwitch];
                [reminderSwitch addTarget:self action:@selector(didChangeRemindMeSwitchValue:) forControlEvents:UIControlEventValueChanged];
            }
            
            UISwitch *reminderSwitch = (UISwitch *)cell.accessoryView;
            
            BOOL reminderMe = [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldRemindeMe"];
            [reminderSwitch setOn:reminderMe];
            
            return cell;
        }
        else {
            static NSString *cellIdentifier = @"LocalNotificationSettingCellIdentifier";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            
            if (indexPath.row == 1) {
                NSInteger beforeDays = [[NSUserDefaults standardUserDefaults] integerForKey:@"remindeBeforeDay"];
                [cell.textLabel setText:[NSString stringWithFormat:@"提前%d天提醒我", beforeDays]];
            } else if (indexPath.row == 2) {
                NSInteger everyDays = [[NSUserDefaults standardUserDefaults] integerForKey:@"remindeEveryDay"];
                [cell.textLabel setText:[NSString stringWithFormat:@"每%d天提醒我一次", everyDays]];
            } else if (indexPath.row == 3) {
                NSDate* reminderDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"remindeTime"];
                NSString *reminderTime = [reminderDate stringWithDateFormat:@"HH:mm"];
                [cell.textLabel setText:[NSString stringWithFormat:@"在%@提醒我",  reminderTime]];
            }
            return cell;
        }
    }
    
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
        return ;
    [self setCurrentSelectedRow:indexPath.row];

    
    if (indexPath.row == 0) {
    } else if (indexPath.row == 1) {
        [self.pickerView reloadAllComponents];
        [self showPickerWithPicker:self.pickerView toggle:YES animation:YES];
        [self showPickerWithPicker:self.datePicker toggle:NO animation:NO];
        NSInteger beforeDays = [[NSUserDefaults standardUserDefaults] integerForKey:@"remindeBeforeDay"];
        [self.pickerView selectRow:beforeDays - 1 inComponent:0 animated:YES];
        
    } else if (indexPath.row == 2) {
        [self.pickerView reloadAllComponents];
        [self showPickerWithPicker:self.pickerView toggle:YES animation:YES];
        [self showPickerWithPicker:self.datePicker toggle:NO animation:NO];
        NSInteger everyDays = [[NSUserDefaults standardUserDefaults] integerForKey:@"remindeEveryDay"];
        [self.pickerView selectRow:everyDays - 1 inComponent:0 animated:YES];
    } else if (indexPath.row == 3) {
        [self showPickerWithPicker:self.pickerView toggle:NO animation:NO];
        [self showPickerWithPicker:self.datePicker toggle:YES animation:YES];
    }
}



#pragma mark - picker view methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.currentSelectedRow == 1) {
        return 15;
    } else {
        return 5;
    }
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.currentSelectedRow == 1) {
        return [NSString stringWithFormat:@"提前%d天提醒我", row + 1];
    } else {
        return [NSString stringWithFormat:@"每%d天提醒我一次", row + 1];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self setIsChangedSetting:YES];
    if (self.currentSelectedRow == 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:row + 1 forKey:@"reminderBeforeDay"];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        [cell.textLabel setText:[NSString stringWithFormat:@"提前%d天提醒我", row + 1]];
    } else {
        [[NSUserDefaults standardUserDefaults] setInteger:row + 1 forKey:@"reminderEveryDay"];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        [cell.textLabel setText:[NSString stringWithFormat:@"每%d天提醒我一次", row + 1]];
    }
}

- (void)didChangeRemindMeSwitchValue:(id)sender{
    UISwitch *toggle = (UISwitch *)sender;
    [[NSUserDefaults standardUserDefaults] setBool:toggle.on forKey:@"shouldRemindeMe"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self showPickerWithPicker:self.pickerView toggle:NO animation:YES];
    [self showPickerWithPicker:self.datePicker toggle:NO animation:YES];
    
    
    [self setIsChangedSetting:YES];
}

- (void)didChangeDatePickerValue:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setValue:self.datePicker.date forKey:@"reminderTime"];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    NSString *reminderTime = [self.datePicker.date stringWithDateFormat:@"HH:mm"];
    [cell.textLabel setText:[NSString stringWithFormat:@"在%@提醒我",  reminderTime]];
    
    [self setIsChangedSetting:YES];
}

- (void)showPickerWithPicker:(id)picker toggle:(BOOL)toggle animation:(BOOL)animation
{
    if (toggle) {
        if (animation) {
            [UIView animateWithDuration:0.3 animations:^{
                [picker setFrame:kPickerFrameShow];
            }];
        } else {
            [picker setFrame:kPickerFrameShow];
        }
        [self setIsPickerShow:YES];
    } else {
        if (animation) {
            [UIView animateWithDuration:0.3 animations:^{
                [picker setFrame:kPickerFrameHide];
            }];
        } else {
            [picker setFrame:kPickerFrameHide];
        }
        [self setIsPickerShow:NO];
    }
}

- (void)settingViewControllerDidChangedSetting
{
    [self updateLocalNotification];
}

- (void)updateLocalNotification
{
    BOOL reminderMe = [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldRemindeMe"];
    [iLIBLocalNotificationManager cancelAllLocalNotifications];
    
    if (reminderMe) {
        
        self.iLibEngine = [iLIBAppDelegate sharedDelegate].iLibEngine;
        [self.iLibEngine requestLoanBooks:^(NSArray *bookArray) {
            NSArray *borrowedBooks = [NSArray arrayWithArray:bookArray];
            NSLog(@"BorrowedBooks:%@",borrowedBooks);
            [iLIBLocalNotificationManager scheduleLocalNoticationWithBookItems:borrowedBooks];
        } onError:^(NSError *engineError) {
            NSLog(@"Request borrowedBooks error");
        }];
    }
}


@end
