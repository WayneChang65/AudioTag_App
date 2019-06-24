//
//  Edit_ViewController.m
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Edit_ViewController.h"
#import "Playing_ViewController.h"
#import "AudioTagAppDelegate.h"

@implementation Edit_ViewController

@synthesize imgvStar;
@synthesize txvComment;
@synthesize txfTagName;
//@synthesize txfAkeyValue;
//@synthesize txfBkeyValue;
@synthesize txfLinkedMp3;
@synthesize btnAkeyValue;
@synthesize btnBkeyValue;
@synthesize strAkeyValue;
@synthesize strBkeyValue;
@synthesize lblTagName;
@synthesize lblLinkedMp3;
@synthesize lblAkeyValue;
@synthesize lblBKeyValue;
@synthesize lblComment;
@synthesize numNeedToUpdate_EditVC;

@synthesize curlView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (IBAction)hideSoftKeyboard_touchDown:(id)sender
{
    [self.txvComment resignFirstResponder];
    [self.txfTagName resignFirstResponder];
//    [self.txfAkeyValue resignFirstResponder];
//    [self.txfBkeyValue resignFirstResponder];
    [self.txfLinkedMp3 resignFirstResponder];
    
}

- (IBAction)curl_edit_VC_touchDown:(id)sender
{
    [self do_curl:nil];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
//	[self setTitle:@"Edit"];
    NSLog(@"Edit_ViewController:ViewDidLoad");
	
	// Navigation Control右邊的Button設定
    /*
	UIBarButtonItem *doSaveTag = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave 
                                                                               target:self 
                                                                               action:@selector(do_SaveTag:)];
	self.navigationItem.rightBarButtonItem = doSaveTag;
	*/
    //
    
    txfLinkedMp3.enabled = NO;
    
    self.numNeedToUpdate_EditVC = [NSNumber numberWithBool:YES];
    
//    [self.imgvStar setImage:[UIImage imageNamed:@"star_on.png"]];
    [self.imgvStar setImage:[UIImage imageNamed:@"star2_yellow@2x.png"]];
    CGRect r = self.view.frame;
    r.size.height = r.size.height - 36;
    self.curlView = [[XBCurlView alloc] initWithFrame:r];
    
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];

    // 把上一頁的Playing_ViewController的一些資訊帶進來，準備進行修改
    Playing_ViewController *Playing_VC = appDelegate.viewCon_Playing;
        
    self.strAkeyValue = Playing_VC.lblAKeyValue.text;
    self.strBkeyValue = Playing_VC.lblBKeyValue.text;
    
    [self.btnAkeyValue setTitle:self.strAkeyValue forState:UIControlStateNormal];
    [self.btnBkeyValue setTitle:self.strBkeyValue forState:UIControlStateNormal];
//    self.btnAkeyValue. = Playing_VC.lblAKeyValue.text;
//    self.btnBkeyValue.text = Playing_VC.lblBKeyValue.text;
    self.txfLinkedMp3.text = [NSString stringWithString:appDelegate.mstrPlayingMP3Filename];

    if (appDelegate.viewCon_Edit.numNeedToUpdate_EditVC.boolValue == NO){
        appDelegate.viewCon_Edit.numNeedToUpdate_EditVC = [NSNumber numberWithBool:YES];
    }else{
        if (appDelegate.dataFromSqlite._preferences.last_opened_tag == nil){
            self.txfTagName.text = @"";
        }else{
            self.txfTagName.text = [NSString stringWithString:appDelegate.strPlayingTagName];
        }

        self.txvComment.text = Playing_VC.txvComment.text;
    }
    
///    NSLog(@"gggg");

    [super viewWillAppear:animated];
}


- (void)akey_Pressed:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.viewCon_Edit_BG.isAkeyOrBkeyPressed = [NSNumber numberWithBool:A_Key];
    appDelegate.viewCon_Edit_BG.strABTime = self.btnAkeyValue.currentTitle;
    self.numNeedToUpdate_EditVC = [NSNumber numberWithBool:NO];
    
    [self do_curl:sender];
}

- (void)bkey_Pressed:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.viewCon_Edit_BG.isAkeyOrBkeyPressed = [NSNumber numberWithBool:B_Key];
    appDelegate.viewCon_Edit_BG.strABTime = self.btnBkeyValue.currentTitle;
    self.numNeedToUpdate_EditVC = [NSNumber numberWithBool:NO];    
    [self do_curl:sender];
}


- (void)do_curl:(id)sender
{   
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.viewCon_Edit_BG.navigationItem.rightBarButtonItem.enabled = NO;
    appDelegate.viewCon_Edit_BG.navigationItem.hidesBackButton = YES;
    
    CGRect r = self.view.frame;
    double dblCylinderAngle = M_PI/7.2; //25 degrees
    double dblCylinderRadius = 70.0;
    double dblCylinderPosition_X = r.size.width/6.0;
    double dblCylinderPoistion_Y = r.size.height/1.0;  // 1.5 /2.0;
    
    
    
    self.curlView.opaque = NO;//Transparency on the next page (so that the view behind curlView will appear)
    self.curlView.pageOpaque = YES;//The page to be curled has no transparency
     
    [self.curlView curlView:self.view cylinderPosition:CGPointMake(dblCylinderPosition_X, dblCylinderPoistion_Y) cylinderAngle:dblCylinderAngle cylinderRadius:dblCylinderRadius animatedWithDuration:kCurlDuration];
    
    [appDelegate.viewCon_Edit_BG update_pkvABTimeObjects:sender];
//    [appDelegate.viewCon_Edit_BG viewWillAppear:YES];
//    [super viewWillAppear:NO];
}


- (void)do_SaveTag:(id)sender
{
    // 這裏要做一些跟Tag存檔有關的事
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // 檢查Tag Name是否為空字串
    
    NSString *alertTitle_1, *alertTitle_2, *alertTitle_4;
    NSString *alertMsg_1, *alertMsg_2, *alertMsg_3, *alartCancelTitle, *alartCancelTitle_1;
    NSString *tempStr_1;
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            alertTitle_1 = @"Tag Name is Empty";
            alertTitle_2 = @"Tag Name includes .mp3 string.";
//            alertTitle_3 =
            alertTitle_4 = @"Linked Mp3 Error！";
            alertMsg_1 = @"Please input the Tag Name and then save.";
            alertMsg_2 = @"Original Tag will be overwritted.";
            alertMsg_3 = @"Please play a Mp3 and then save Tag.";
            alartCancelTitle = @"OK";
            alartCancelTitle_1 = @"Cancel";
            
            tempStr_1 = @"%@ Exists！";
            break;
        case iChinese_lang:
            alertTitle_1 = @"標籤名稱為空白！";
            alertTitle_2 = @"標籤名稱內含.mp3字串！";
//            alertTitle_3 =
            alertTitle_4 = @"連結的MP3有錯誤！";
            alertMsg_1 = @"請輸入標籤名稱後，再進行儲存！";
            alertMsg_2 = @"原標籤將被覆蓋。";
            alertMsg_3 = @"請重新撥放某個Mp3後，再進行儲存！";
            alartCancelTitle = @"確認";
            alartCancelTitle_1 = @"取消";
            
            tempStr_1 = @"%@已存在！";
            break;
    }

    
    if ([self.txfTagName.text isEqualToString:@""]){
        //NSString *alertTitle = [NSString stringWithFormat:@"Tag Name為空白！", self.txfTagName.text];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle_1 
                                                        message:alertMsg_1 
                                                       delegate:nil 
                                              cancelButtonTitle:alartCancelTitle 
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // 檢查Tag Name是否內含.mp3, .Mp3, .mP3, .MP3。
    NSString *aString = self.txfTagName.text;
    NSRange aRange_mp3 = [aString rangeOfString:@".mp3"];
    NSRange aRange_Mp3 = [aString rangeOfString:@".Mp3"];
    NSRange aRange_mP3 = [aString rangeOfString:@".mP3"];
    NSRange aRange_MP3 = [aString rangeOfString:@".MP3"];
    if ((aRange_mp3.length > 0) || (aRange_Mp3.length > 0) || (aRange_mP3.length > 0) || (aRange_MP3.length > 0)){
        // 有內含.mp3, .Mp3, .mP3, .MP3字串
//        NSString *alertTitle = [NSString stringWithFormat:@"Tag Name內含.mp3字串！", self.txfTagName.text];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle_2 
                                                        message:alertMsg_1 
                                                       delegate:nil 
                                              cancelButtonTitle:alartCancelTitle 
                                              otherButtonTitles:nil];
        [alert show];
        return;        
    }
    
     
    // 由於Tag Name是唯一的索引，所以Tag Name不能重覆。在Tag存檔前先檢查目前的Tag Name是否已經存在？
    for (tag *aWillbeCheckedTag in appDelegate.dataFromSqlite._tag){
        if ([aWillbeCheckedTag.name isEqualToString:self.txfTagName.text]){
            NSString *alertTitle = [NSString stringWithFormat:tempStr_1, self.txfTagName.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle 
                                                            message:alertMsg_2 
                                                           delegate:self 
                                                  cancelButtonTitle:alartCancelTitle_1 
                                                  otherButtonTitles:alartCancelTitle,nil];
            [alert show];
            return;
        }
    }
    
    
    
    // 儲存Tag
    if ([self saveTag:sender] == -1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle_4
                                                        message:alertMsg_3 
                                                       delegate:nil 
                                              cancelButtonTitle:alartCancelTitle
                                              otherButtonTitles:nil];
        [alert show];

        return;
    }
    
    [appDelegate.viewCon_Edit_BG backToPlaying_ViewController:nil];
    
/*    
    NSString *aMp3WillBeTagged = appDelegate.mstrPlayingMP3Filename;
    NSInteger indexInMp3Entity = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Mp3_EntityByString:aMp3WillBeTagged]; 
    
    mp3 *aMp3 = (mp3 *) [appDelegate.dataFromSqlite._mp3 objectAtIndex:indexInMp3Entity];
    tag *aTag = (tag *) [NSEntityDescription insertNewObjectForEntityForName:@"tag"
                                                      inManagedObjectContext:appDelegate.managedObjectContext];
    aTag.name = [NSString stringWithString:self.txfTagName.text];
    aTag.commet = [NSString stringWithString:self.txvComment.text];
    aTag.a_time = [NSString stringWithFormat:@"%f", [appDelegate.utility timeIntervalWithFormatString:self.txfAkeyValue.text]];
    aTag.b_time = [NSString stringWithFormat:@"%f", [appDelegate.utility timeIntervalWithFormatString:self.txfBkeyValue.text]];
    aTag.linked_mp3 = aMp3;
    aTag.linked_mp3filename = [NSString stringWithString:aMp3WillBeTagged];

    [appDelegate.dataFromSqlite loadDataFromDBToMemory];
    [appDelegate saveContext];

 
    // 通知Tag_ViewController更新TableView
    appDelegate.isTagSaved = [NSNumber numberWithBool:YES];
           
    // Tag儲存後，畫面切回Playing_ViewController
    [self.navigationController popViewControllerAnimated:YES];
*/

}

- (NSInteger)saveTag:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *aMp3WillBeTagged = appDelegate.mstrPlayingMP3Filename;
        
    NSInteger indexInMp3Entity = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Mp3_EntityByString:aMp3WillBeTagged]; 
    
    // indexInMp3Entity == -1 表示欲存的Tag其中Linked Mp3是在目前Sqilte資料庫的Mp3裏找不到的，
    // 或者是Linked_mp3是nil或空字串""。總之就是沒有正確的Linked mp3。
    // 這種情況有可能發生在剛安裝AudioTag APP時，還沒有發放過任何mp3檔就想存Tag。
    // MSG：Linked MP3 do NOT exist.
    if (indexInMp3Entity == -1){
        return -1;
    }else{
        mp3 *aMp3 = (mp3 *) [appDelegate.dataFromSqlite._mp3 objectAtIndex:indexInMp3Entity];
        tag *aTag = (tag *) [NSEntityDescription insertNewObjectForEntityForName:@"tag"
                                                      inManagedObjectContext:appDelegate.managedObjectContext];
        aTag.name = [NSString stringWithString:self.txfTagName.text];
        aTag.commet = [NSString stringWithString:self.txvComment.text];
       
        aTag.a_time = [NSString stringWithFormat:@"%f", [appDelegate.utility timeIntervalWithFormatString:self.btnAkeyValue.currentTitle]];
        aTag.b_time = [NSString stringWithFormat:@"%f", [appDelegate.utility timeIntervalWithFormatString:self.btnBkeyValue.currentTitle]];

    
        aTag.linked_mp3 = aMp3;
        aTag.linked_mp3filename = [NSString stringWithString:aMp3WillBeTagged];
    
        [appDelegate.dataFromSqlite loadDataFromDBToMemory];
        [appDelegate saveContext];
    
        // 通知Tag_ViewController更新TableView
        appDelegate.isTagSaved = [NSNumber numberWithBool:YES];
        return 0;
    }

    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    switch (buttonIndex) {
        case 0: // Cancel Button
            NSLog(@"Cancel Button Pressed");
            break;
        case 1: // OK Button
            NSLog(@"Button 1 Pressed");
            NSString *strPrepareToDeleteTagName = self.txfTagName.text;
            
            // *** 先刪除舊的同名Tag *** //
            // 刪除CoreData裏面的_Tag
            NSInteger deleteIndex = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Tag_EntityByString:strPrepareToDeleteTagName];
            tag *aNeedToDelTag_tag = (tag *)[appDelegate.dataFromSqlite._tag objectAtIndex:deleteIndex];
            [appDelegate.managedObjectContext deleteObject:aNeedToDelTag_tag];
            
            // 再從DB找把資料載到Memory。主要是更新_mp3以及_tag，但_preference...也會一併被更新
            [appDelegate.dataFromSqlite loadDataFromDBToMemory];
            [appDelegate saveContext];               

            
            // *** 再將新的同名Tag儲存 ***//
            [self saveTag:nil];
            
            // 因為同一個Tag的資料被更新(AB Time or...)，所以必需靠這個flag通知Tag_ViewController重撥tag
            appDelegate.isTheSameNameTag_Update = [[NSNumber alloc] initWithBool:YES];
            
            // 這裏儲存正常，但是Playing_ViewController的資訊還是之前舊同名Tag資料。
            //appDelegate.viewCon_Playing.needToPlayNewFile = [NSNumber numberWithInt:YES];
            
            [appDelegate.viewCon_Edit_BG backToPlaying_ViewController:nil];
            
            break;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    int views_ShiftDistance = 160;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    //設定動畫開始時的狀態為目前畫面上的樣子
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y - views_ShiftDistance, textView.frame.size.width, textView.frame.size.height);
    
    self.txfTagName.frame = CGRectMake(self.txfTagName.frame.origin.x, self.txfTagName.frame.origin.y - views_ShiftDistance, self.txfTagName.frame.size.width, self.txfTagName.frame.size.height);
    
    self.txfLinkedMp3.frame = CGRectMake(self.txfLinkedMp3.frame.origin.x, self.txfLinkedMp3.frame.origin.y - views_ShiftDistance, self.txfLinkedMp3.frame.size.width, self.txfLinkedMp3.frame.size.height);
    
//    self.txfAkeyValue.frame = CGRectMake(self.txfAkeyValue.frame.origin.x, self.txfAkeyValue.frame.origin.y - views_ShiftDistance, self.txfAkeyValue.frame.size.width, self.txfAkeyValue.frame.size.height);
    
//    self.txfBkeyValue.frame = CGRectMake(self.txfBkeyValue.frame.origin.x, self.txfBkeyValue.frame.origin.y - views_ShiftDistance, self.txfBkeyValue.frame.size.width, self.txfBkeyValue.frame.size.height);

    self.btnAkeyValue.frame = CGRectMake(self.btnAkeyValue.frame.origin.x, self.btnAkeyValue.frame.origin.y - views_ShiftDistance, self.btnAkeyValue.frame.size.width, self.btnAkeyValue.frame.size.height);
    
    self.btnBkeyValue.frame = CGRectMake(self.btnBkeyValue.frame.origin.x, self.btnBkeyValue.frame.origin.y - views_ShiftDistance, self.btnBkeyValue.frame.size.width, self.btnBkeyValue.frame.size.height);
    
    
    self.lblTagName.frame = CGRectMake(self.lblTagName.frame.origin.x, self.lblTagName.frame.origin.y - views_ShiftDistance, self.lblTagName.frame.size.width, self.lblTagName.frame.size.height);

    self.lblLinkedMp3.frame = CGRectMake(self.lblLinkedMp3.frame.origin.x, self.lblLinkedMp3.frame.origin.y - views_ShiftDistance, self.lblLinkedMp3.frame.size.width, self.lblLinkedMp3.frame.size.height);
    
    self.lblAkeyValue.frame = CGRectMake(self.lblAkeyValue.frame.origin.x, self.lblAkeyValue.frame.origin.y - views_ShiftDistance, self.lblAkeyValue.frame.size.width, self.lblAkeyValue.frame.size.height);

    self.lblBKeyValue.frame = CGRectMake(self.lblBKeyValue.frame.origin.x, self.lblBKeyValue.frame.origin.y - views_ShiftDistance, self.lblBKeyValue.frame.size.width, self.lblBKeyValue.frame.size.height);

    self.lblComment.frame = CGRectMake(self.lblComment.frame.origin.x, self.lblComment.frame.origin.y - views_ShiftDistance, self.lblComment.frame.size.width, self.lblComment.frame.size.height);

    
    [UIView commitAnimations];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    int views_ShiftDistance = 160;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    
    //設定動畫開始時的狀態為目前畫面上的樣子
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y + views_ShiftDistance, textView.frame.size.width, textView.frame.size.height);
    
    self.txfTagName.frame = CGRectMake(self.txfTagName.frame.origin.x, self.txfTagName.frame.origin.y + views_ShiftDistance, self.txfTagName.frame.size.width, self.txfTagName.frame.size.height);
    
    self.txfLinkedMp3.frame = CGRectMake(self.txfLinkedMp3.frame.origin.x, self.txfLinkedMp3.frame.origin.y + views_ShiftDistance, self.txfLinkedMp3.frame.size.width, self.txfLinkedMp3.frame.size.height);
    
//    self.txfAkeyValue.frame = CGRectMake(self.txfAkeyValue.frame.origin.x, self.txfAkeyValue.frame.origin.y + views_ShiftDistance, self.txfAkeyValue.frame.size.width, self.txfAkeyValue.frame.size.height);
    
//    self.txfBkeyValue.frame = CGRectMake(self.txfBkeyValue.frame.origin.x, self.txfBkeyValue.frame.origin.y + views_ShiftDistance, self.txfBkeyValue.frame.size.width, self.txfBkeyValue.frame.size.height);

    self.btnAkeyValue.frame = CGRectMake(self.btnAkeyValue.frame.origin.x, self.btnAkeyValue.frame.origin.y + views_ShiftDistance, self.btnAkeyValue.frame.size.width, self.btnAkeyValue.frame.size.height);
    
    self.btnBkeyValue.frame = CGRectMake(self.btnBkeyValue.frame.origin.x, self.btnBkeyValue.frame.origin.y + views_ShiftDistance, self.btnBkeyValue.frame.size.width, self.btnBkeyValue.frame.size.height);
    
    
    self.lblTagName.frame = CGRectMake(self.lblTagName.frame.origin.x, self.lblTagName.frame.origin.y + views_ShiftDistance, self.lblTagName.frame.size.width, self.lblTagName.frame.size.height);
    
    self.lblLinkedMp3.frame = CGRectMake(self.lblLinkedMp3.frame.origin.x, self.lblLinkedMp3.frame.origin.y + views_ShiftDistance, self.lblLinkedMp3.frame.size.width, self.lblLinkedMp3.frame.size.height);
    
    self.lblAkeyValue.frame = CGRectMake(self.lblAkeyValue.frame.origin.x, self.lblAkeyValue.frame.origin.y + views_ShiftDistance, self.lblAkeyValue.frame.size.width, self.lblAkeyValue.frame.size.height);
    
    self.lblBKeyValue.frame = CGRectMake(self.lblBKeyValue.frame.origin.x, self.lblBKeyValue.frame.origin.y + views_ShiftDistance, self.lblBKeyValue.frame.size.width, self.lblBKeyValue.frame.size.height);
    
    self.lblComment.frame = CGRectMake(self.lblComment.frame.origin.x, self.lblComment.frame.origin.y + views_ShiftDistance, self.lblComment.frame.size.width, self.lblComment.frame.size.height);
    
    [UIView commitAnimations];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	NSLog(@"Edit_ViewController--viewDidUnload");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.imgvStar = nil;
    self.txvComment = nil;
    self.txfTagName = nil;
//    self.txfAkeyValue = nil;
//    self.txfBkeyValue = nil;
    self.txfLinkedMp3 = nil;
    self.btnAkeyValue = nil;
    self.btnBkeyValue = nil;
    self.strAkeyValue = nil;
    self.strBkeyValue = nil;
    self.lblTagName = nil;
    self.lblLinkedMp3 = nil;
    self.lblAkeyValue = nil;
    self.lblBKeyValue = nil;
    self.lblComment = nil;
    self.numNeedToUpdate_EditVC = nil;
    self.curlView = nil;

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

- (void)dealloc {
	NSLog(@"Edit_ViewController--dealloc");    
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



@end
