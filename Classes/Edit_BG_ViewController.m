//
//  Edit_BG_ViewController.m
//  AudioTag
//
//  Created by Chang Wayne on 12/9/4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Edit_BG_ViewController.h"
#import "AudioTagAppDelegate.h"

@interface Edit_BG_ViewController ()

@end

@implementation Edit_BG_ViewController

@synthesize edit_VC;
@synthesize pkvABTime;
@synthesize maryABMinute;
@synthesize maryABSecond;
@synthesize isAkeyOrBkeyPressed;
@synthesize strABTime;
@synthesize numMaxMinute;
@synthesize btnABKeySign;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    edit_VC = appDelegate.viewCon_Edit = [[Edit_ViewController alloc] initWithNibName:@"Edit_ViewController" bundle:[NSBundle mainBundle]];
    [self.view addSubview:edit_VC.view];
    
    // Navigation Control右邊的Button設定
	UIBarButtonItem *doSaveTag = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                                               target:self 
                                                                               action:@selector(do_SaveTag:)];
    
	self.navigationItem.rightBarButtonItem = doSaveTag;
	//

    self.isAkeyOrBkeyPressed = [NSNumber numberWithBool:A_Key];
    
    self.numMaxMinute = 0;
    
    //
    pkvABTime.dataSource = self;
    pkvABTime.delegate = self;
    pkvABTime.showsSelectionIndicator = YES;
    
    maryABMinute = [[NSMutableArray alloc] init];
    maryABSecond = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.numMaxMinute.intValue + 1; i++){
        [maryABMinute addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    for (int j = 0; j < 60; j++){
//        [maryABMinute addObject:[NSString stringWithFormat:@"%d", j]];
        [maryABSecond addObject:[NSString stringWithFormat:@"%d", j]];
    }
    
}
- (void)backToPlaying_ViewController:(id)sender
{
    // Tag儲存後，畫面切回Playing_ViewController
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)do_SaveTag:(id)sender
{
    [self.edit_VC do_SaveTag:sender];
    
    // Tag儲存後，畫面切回Playing_ViewController
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIImage *imgAkey = [UIImage imageNamed:@"07-map-marker_deepgreen_A@2x.png"];
    UIImage *imgBkey = [UIImage imageNamed:@"07-map-marker_deepred_B@2x.png"];
    
    NSInteger minute_row = [appDelegate.utility MinuteTimePartWithFormatString:self.strABTime]; 
    NSInteger second_row = [appDelegate.utility SecondTimePartWithFormatString:self.strABTime];

    NSTimeInterval playingMp3Duration = appDelegate.viewCon_Playing.strPlayingMp3Duration.doubleValue;
    NSString *strPlayingMp3Duration = [NSString stringWithFormat:@"%d:%02d", (int)playingMp3Duration / 60, (int)playingMp3Duration % 60, nil];
    
    NSInteger max_minute_row = [appDelegate.utility MinuteTimePartWithFormatString:strPlayingMp3Duration];

    
    self.numMaxMinute = [NSNumber numberWithInt:max_minute_row];
    
    [maryABMinute removeAllObjects];
    for (int i = 0; i < self.numMaxMinute.intValue + 1; i++){
        [maryABMinute addObject:[NSString stringWithFormat:@"%d", i]];
    }
    [self.pkvABTime reloadAllComponents];
    
    [self.pkvABTime selectRow:minute_row inComponent:0 animated:NO];    // 分鐘
    [self.pkvABTime selectRow:second_row inComponent:1 animated:NO];    // 秒鐘
    
    if (self.isAkeyOrBkeyPressed.boolValue == A_Key){
        [self.btnABKeySign setImage:imgAkey forState:UIControlStateNormal];
        [self.btnABKeySign setTitle:@"A" forState:UIControlStateNormal];
        [self.btnABKeySign setTitleColor:RGBA(0, 114, 0, 1) forState:UIControlStateNormal];
    }else{
        [self.btnABKeySign setImage:imgBkey forState:UIControlStateNormal];        
        [self.btnABKeySign setTitle:@"B" forState:UIControlStateNormal];
        [self.btnABKeySign setTitleColor:RGBA(119, 34, 34, 1) forState:UIControlStateNormal];
    }

    [self.edit_VC viewWillAppear:animated];
   
}

- (void)update_pkvABTimeObjects:(id)sender
{
    [self viewWillAppear:NO];
}


- (void)do_uncurl:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.hidesBackButton = NO;
    [self.edit_VC.curlView uncurlAnimatedWithDuration:kCurlDuration];
}

- (void)ok_pressed:(id)sender
{
    // 檢查AB Time Range的二個變數
    NSString *aTime_Checking;
    NSString *bTime_Checking;
    //
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (self.isAkeyOrBkeyPressed.boolValue == A_Key){
        strATime = [NSString stringWithString:self.strABTime];
        aTime_Checking = [NSString stringWithString:strABTime];
        if(strBTime != nil){
            bTime_Checking = [NSString stringWithString:strBTime];
        }else{
            bTime_Checking = [NSString stringWithString:self.edit_VC.btnBkeyValue.currentTitle];
        }
    }else{
        strBTime = [NSString stringWithString:self.strABTime];
        bTime_Checking = [NSString stringWithString:self.strABTime];
        if(strATime != nil){
            aTime_Checking = [NSString stringWithString:strATime];
        }else{
            aTime_Checking = [NSString stringWithString:self.edit_VC.btnAkeyValue.currentTitle];
        }
    }
    
    // 檢查AB Time的Range。如果A Time比B Time後面，或是B Time比 A Time前面，就發Alarm Msg.
    // 然後停留在原畫面等待修改或是點選Cancel
    NSTimeInterval ti_aTime = [appDelegate.utility timeIntervalWithFormatString:aTime_Checking];
    NSTimeInterval ti_bTime = [appDelegate.utility timeIntervalWithFormatString:bTime_Checking];
    if (ti_aTime > ti_bTime){
        if (self.isAkeyOrBkeyPressed.boolValue == A_Key){
            strATime = nil;
            
            NSString *org_aTime;
            NSTimeInterval ti_org_aTime;
            org_aTime = [NSString stringWithString:self.edit_VC.btnAkeyValue.currentTitle];
            ti_org_aTime = [appDelegate.utility timeIntervalWithFormatString:org_aTime];
            if (ti_org_aTime > ti_bTime) strBTime = nil;
            
        }else{
            strBTime = nil;
            
            NSString *org_bTime;
            NSTimeInterval ti_org_bTime;
            org_bTime = [NSString stringWithString:self.edit_VC.btnBkeyValue.currentTitle];
            ti_org_bTime = [appDelegate.utility timeIntervalWithFormatString:org_bTime];
            if (ti_org_bTime < ti_aTime) strATime = nil;
        }
        
        NSString *alertTitle, *alertMsg, *alartCancelTitle;
        switch (appDelegate.numLanguage.intValue) {
            case iEnglish_lang:
                alertTitle = @"A Time > B Time！";
                alertMsg = @"Please set a time again.";
                alartCancelTitle = @"OK";
                break;
            case iChinese_lang:
                alertTitle = @"A Time 大於 B Time！";
                alertMsg = @"請重新設定時間！";
                alartCancelTitle = @"確認";
                break;
        }

        
        
        //NSString *alertTitle = [NSString stringWithFormat:@"A Time 大於 B Time！"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle 
                                                        message:alertMsg 
                                                       delegate:nil 
                                              cancelButtonTitle:alartCancelTitle 
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (self.isAkeyOrBkeyPressed.boolValue == A_Key){
        [self.edit_VC.btnAkeyValue setTitle:self.strABTime forState:UIControlStateNormal];
        strATime = [NSString stringWithString:self.strABTime];
        if(strBTime != nil){
            [self.edit_VC.btnBkeyValue setTitle:strBTime forState:UIControlStateNormal];
        }else{}
    }else{
        [self.edit_VC.btnBkeyValue setTitle:self.strABTime forState:UIControlStateNormal];
        strBTime = [NSString stringWithString:self.strABTime];
        if(strATime != nil){
            [self.edit_VC.btnAkeyValue setTitle:strATime forState:UIControlStateNormal];
        }else{}
    }

    
    [self do_uncurl:sender];
}

- (IBAction)uncurl_edit_VC_touchDown:(id)sender
{
    if(strATime != nil){
        [self.edit_VC.btnAkeyValue setTitle:strATime forState:UIControlStateNormal];
    }
    if(strBTime != nil){
        [self.edit_VC.btnBkeyValue setTitle:strBTime forState:UIControlStateNormal];
    }
    
    [self do_uncurl:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.edit_VC = nil;
    self.pkvABTime = nil;
    self.maryABMinute = nil;
    self.maryABSecond = nil;
    self.isAkeyOrBkeyPressed = nil;
    self.strABTime = nil;
    self.numMaxMinute = nil;
    self.btnABKeySign = nil;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Remote Control Methods
//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event 
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    //    NSString *aMsg = @".";
    //    [appDelegate.utility MsgLog:self.class withFuncName:@"remoteControlReceivedWithEvent" withMsg:aMsg];
    [appDelegate.viewCon_Playing remoteControlReceivedWithEvent:event];
}


#pragma mark Picker View Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    // picker 要顯示幾欄資料
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // 欄位有多少比資料 同常回傳資料矩陣的筆數
    switch (component) {
        case 0:
            return [maryABMinute count];
            break;
        case 1:
            return [maryABSecond count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    // 這邊是在抓取 picker 要顯示的資料
    
    switch (component) {
        case 0:
            return [maryABMinute objectAtIndex:row];
            break;
        case 1:
            return [maryABSecond objectAtIndex:row];
            break;
        default:
            return 0;
            break;
    }
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger iMinute = [self.pkvABTime selectedRowInComponent:0];
    NSInteger iSecond = [self.pkvABTime selectedRowInComponent:1];
    self.strABTime = [NSString stringWithFormat:@"%d:%02d", iMinute, iSecond, nil];
    
    NSLog(@"component:%d, row:%d, %@", component, row, self.strABTime);
                      
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat fWidth;
    switch (component) {
        case 0:
            fWidth = (CGFloat)100;
            break;
        case 1:
            fWidth = (CGFloat)80;
            break;
    }
    return fWidth;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
    
}

@end
