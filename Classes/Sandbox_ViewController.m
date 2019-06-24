//
//  Sandbox_ViewController.m
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "Sandbox_ViewController.h"
#import "Playing_ViewController.h"
#import "AVFoundation/AVFoundation.h"
#import "AudioTagAppDelegate.h"
#import "Sandbox_TbvCell.h"

@implementation Sandbox_ViewController


@synthesize listData;
@synthesize needToPlayNewFile;
@synthesize tvbSandboxDisplay;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/
/**
 * @brief 同步Documents目錄與AudioTag內部CoreData Mp3 Entity
 * @details 同步Documents目錄與AudioTag內部CoreData Mp3 Entity。除了同步以外，還針對Tag的連結進行重建。
 * @date 2012-03-10
 * @version V1.0
 * @author Wayne
 * @param None
 * @param None
 * @return None
 */
- (void)syncDocDirWithMp3Entity
{
  	AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	// 取得應用程式沙箱目錄裏的檔案列表
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"SomeDirectoryName"];
	path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@""];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
	//NSArray *filterTypes = [NSArray arrayWithObject:@"mp3"];
    NSArray *filterTypes = [NSArray arrayWithObjects:@"mp3", @"MP3", @"Mp3", @"mP3", nil];
	NSArray *filteredFiles = [directoryContent pathsMatchingExtensions:filterTypes];
	
	//self.listData = filteredFiles;
    self.listData = [NSMutableArray arrayWithArray:filteredFiles]; 
	//
	
    // 存放目前真正磁碟裏mp3檔案列表
    appDelegate.aryAllMP3FilesInSandbox = self.listData;
    
    // 將DB裏的資料載到Memory裏
    //[appDelegate.dataFromSqlite loadDataFromDBToMemory];
    
    
    // 測試..測試..測試..測試..測試..測試..測試..測試..測試..測試..測試..
    /*
     NSMutableArray *temp_listData = [[NSMutableArray alloc] init];
     for (int i = 0; i < [appDelegate.dataFromSqlite._mp3 count]; i++){
     mp3 *aSandboxMp3_mp3 = (mp3 *)[appDelegate.dataFromSqlite._mp3 objectAtIndex:i];
     NSString *strSandBoxMp3 = aSandboxMp3_mp3.name;
     [temp_listData addObject:strSandBoxMp3];
     }
     NSArray *aryDifference = [appDelegate.utility checkDifferenceBetweenDocDirToArray:temp_listData];
     
     NSLog(@"%@", aryDifference);
     */
    //===============================================================    
    
    // 將Sandbox裏面的檔案名稱傳進資料庫儲存管理及使用(進行disk-mp3與sqlie-mp3的同步處理，並做Tag重建的工作)
    // 
    [appDelegate.dataFromSqlite saveSandboxMp3sToDB:self.listData];
    //
    

    //	self.needToPlayNewFile = [NSNumber numberWithInt:YES];
    
}


- (void)do_Edit:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    static UIColor *old_backGroundColor;
    
    [self.tvbSandboxDisplay setEditing:!self.tvbSandboxDisplay.editing animated:YES];
    if (self.tvbSandboxDisplay.editing) {
        switch (appDelegate.numLanguage.intValue) {
            case iEnglish_lang:
                [self.navigationItem.leftBarButtonItem setTitle:@"Done"]; break;
            case iChinese_lang:
                [self.navigationItem.leftBarButtonItem setTitle:@"完成"]; break;
        }
        old_backGroundColor = self.navigationItem.leftBarButtonItem.tintColor;
        [self.navigationItem.leftBarButtonItem setTintColor:RGBA(30, 144, 255, 1)]; //DodgerBlue
    }else{
        switch (appDelegate.numLanguage.intValue) {
            case iEnglish_lang:
                [self.navigationItem.leftBarButtonItem setTitle:@"Edit"]; break;
            case iChinese_lang:
                [self.navigationItem.leftBarButtonItem setTitle:@"編輯"]; break;
        }
        [self.navigationItem.leftBarButtonItem setTintColor:old_backGroundColor];
    }
}

- (void)do_iniSqliteDB:(id)sender
{
	AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//[appDelegate.dataFromSqlite showDataInConsoleFromMemory];
    [appDelegate.dataFromSqlite saveInitialDataToDB_Test];
    //[appDelegate.dataFromSqlite deleteAllObjectsForAllEntitiesFromDB];
}

- (void)do_goPlaying_byBtn:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    //=======切換畫面到Playing_ViewController========//
    Playing_ViewController *pVC = appDelegate.viewCon_Playing;
    
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            [pVC setTitle:@"Playing"]; break;
        case iChinese_lang:
            [pVC setTitle:@"撥放頁"]; break;
    }

	pVC.needToPlayNewFile = self.needToPlayNewFile;
    self.needToPlayNewFile = [NSNumber numberWithInt:NO];
    
	pVC.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:pVC animated:YES];
    //

}

- (void)do_goPlaying:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![sender isKindOfClass:[NSString class]]){
        [appDelegate.utility ErrLog:self.class withFuncName:@"do_goPlaying" withMsg:@"sender is NOT a NSString object!"];
        return;
    }
    
    NSString *strPrepareToPlayMP3Filename = sender;
    NSString *strPlayingMP3Filename = appDelegate.mstrPlayingMP3Filename;
     
    if (appDelegate.dataFromSqlite._preferences.last_opened_tag != nil) {
    // 重撥
        self.needToPlayNewFile = [NSNumber numberWithInt:YES];
        appDelegate.dataFromSqlite._preferences.last_opened_mp3 = strPrepareToPlayMP3Filename;
        appDelegate.mstrPlayingMP3Filename = [NSMutableString stringWithString:strPrepareToPlayMP3Filename];
    }else{
        if ([strPrepareToPlayMP3Filename isEqualToString:strPlayingMP3Filename]) {
            if (appDelegate.isPlay1stTimeFromStartApp.boolValue == YES){
                // 重撥
                // 程式剛開啟的時候特別容易發生這個case。
                // 程式關閉前最後撥放的mp3檔如果跟程式剛開啟的檔案一樣，就會進到這個case。
                self.needToPlayNewFile = [NSNumber numberWithInt:YES];
                appDelegate.dataFromSqlite._preferences.last_opened_mp3 = strPrepareToPlayMP3Filename;
                appDelegate.mstrPlayingMP3Filename = [NSMutableString stringWithString:strPrepareToPlayMP3Filename];            
            }else{
                // 不重撥
                self.needToPlayNewFile = [NSNumber numberWithInt:NO];
            }
        }else{
            // 重撥
            self.needToPlayNewFile = [NSNumber numberWithInt:YES];
            appDelegate.dataFromSqlite._preferences.last_opened_mp3 = strPrepareToPlayMP3Filename;
            appDelegate.mstrPlayingMP3Filename = [NSMutableString stringWithString:strPrepareToPlayMP3Filename];
        }
    }
     
    appDelegate.isPlay1stTimeFromStartApp = [NSNumber numberWithInt:NO];
     
    // 如果是從sandbox撥放mp3的話，last_opened_tag會被設成nil
    // 反之，如果從Tag頁面撥放tag的話，last_opened_tag就會被設成tag.name
    appDelegate.dataFromSqlite._preferences.last_opened_tag = nil;
    //      
}

- (void)echoNotification:(NSNotification *)notification {
    NSLog(@"PLAY-MP3");
    //取得由NSNotificationCenter送來的訊息
    NSString *strPrepareToPlayMp3Name = [notification object];
    [self do_goPlaying:strPrepareToPlayMp3Name];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
//	NSLog(@"Sandbox_VC--viewDidLoad");
    NSLog(@"Sandbox_ViewController:ViewDidLoad");
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	

    
    // Navigation Control右邊的Button設定
//	UIBarButtonItem *goPlaying = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay 
//																			target:self 
//																			action:@selector(do_goPlaying:)];
    NSString *goPlayingTitle;
    NSString *editTitle;
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            goPlayingTitle = @"Playing";
            editTitle = @"Edit";
            break;
        case iChinese_lang:
            goPlayingTitle = @"撥放頁";
            editTitle = @"編輯";
            break;
    }
    
    
	UIBarButtonItem *goPlaying = [[UIBarButtonItem alloc] initWithTitle:goPlayingTitle
                                                                  style:UIBarButtonItemStylePlain 
                                                                 target:self 
                                                                 action:@selector(do_goPlaying_byBtn:)];
                                  
                                  
    goPlaying.tintColor = RGBA(0, 0, 0, 0);                              
	self.navigationItem.rightBarButtonItem = goPlaying;
	
	
	UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:editTitle 
                                                                    style:UIBarButtonItemStylePlain 
                                                                   target:self 
                                                                   action:@selector(do_Edit:)];
                                                                   //action:@selector(do_iniSqliteDB:)];
	self.navigationItem.leftBarButtonItem = edit;
	//
    
    // 將DB裏的資料載到Memory裏
    [appDelegate.dataFromSqlite loadDataFromDBToMemory];
    
    
    // 正在撥放的檔名初始化
	// 理論上是要把上次開啟的檔名記錄下來，然後這裏初始化再叫回來。目前先給個sandbox裏有的某個檔案預設值
	//[self.mstrPlayingMP3Filename setString:@"NoButs.mp3"];
    if (appDelegate.dataFromSqlite._preferences) {
        [appDelegate.mstrPlayingMP3Filename setString:appDelegate.dataFromSqlite._preferences.last_opened_mp3];
    }else{
        NSLog(@"appDelegate.dataFromSqlite._preferences == NULL");
        [appDelegate.mstrPlayingMP3Filename setString:@""];
    }
    
    NSTimeInterval mp3Duration;
    // 判斷目前的撥放型式是什麼？是MP3？TAG？還是PLT(playlist)？
    if (appDelegate.dataFromSqlite._preferences.last_opened_tag == nil){
        appDelegate.strPlayingTagName = @"";
        mp3Duration = [appDelegate.avPlayerExtension getDurationFromMp3Filename:appDelegate.mstrPlayingMP3Filename];
        appDelegate.aTimeOfLastOpenedTag = 0;
        appDelegate.bTimeOfLastOpenedTag = [NSNumber numberWithDouble:mp3Duration];
        appDelegate.commentOfLastOpenedTag = @"";
    }else{
        appDelegate.strPlayingTagName = [NSString stringWithString:appDelegate.dataFromSqlite._preferences.last_opened_tag];
        NSInteger idx = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Tag_EntityByString:appDelegate.strPlayingTagName];
        
        if (idx != -1){ // last_opened_tag在DB裏面的Tag Entity找不到對應的Element就會回傳-1
            tag *aTag = [appDelegate.dataFromSqlite._tag objectAtIndex:idx];
            appDelegate.aTimeOfLastOpenedTag = [NSNumber numberWithDouble:[aTag.a_time doubleValue]];
            appDelegate.bTimeOfLastOpenedTag = [NSNumber numberWithDouble:[aTag.b_time doubleValue]];
            appDelegate.commentOfLastOpenedTag = [NSString stringWithString:aTag.commet];
        }else{
            appDelegate.aTimeOfLastOpenedTag = [NSNumber numberWithDouble:0];
            appDelegate.bTimeOfLastOpenedTag = [NSNumber numberWithDouble:0];
            appDelegate.commentOfLastOpenedTag = @"";       
        }
    }
    //  
    
    // 訂閱Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(echoNotification:) name:@"PLAY-MP3" object:nil];

    // 在ViewDidLoad後，將tabBarCon切到Tag_ViewController做初始化。這都是為了PLAY-TAG的Notification。
    [appDelegate.tabBarCon_audioTag setSelectedIndex:1];
    
    [super viewDidLoad];	
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	NSLog(@"Sandbox_ViewController--viewDidUnload");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	self.listData = nil;
	self.needToPlayNewFile = nil;
    self.tvbSandboxDisplay = nil;
    
    // 取消訂閱Notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PLAY-MP3" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
//  NSLog(@"Sandbox_ViewController---viewWillAppear");
    
    [self syncDocDirWithMp3Entity];
    if (self.tvbSandboxDisplay) [self.tvbSandboxDisplay reloadData];
	[super viewWillAppear:animated];
}

- (void)dealloc {
	NSLog(@"Sandbox_ViewController--dealloc");
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

#pragma mark Table View Data Source Methods
// TableView類別本身需要知道每一個section到底要show幾個rows，所以需要靠delegate讓使用TableView的類別將數值傳回TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tvbSandboxDisplay = tableView;
	return [self.listData count];
}

// 描述TablewView的每個cell要長成什麼樣子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString *SimpleTableIdentifier = @"Sandbox_TableIdentifier";
    
    Sandbox_TbvCell *cell = nil;
    cell = (Sandbox_TbvCell *)[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    NSString *mp3Name = [self.listData objectAtIndex:indexPath.row];
//    UIImage *starOFF = [UIImage imageNamed:@"star_off.png"];
    UIImage *starOFF = [UIImage imageNamed:@"star2@2x.png"];
    //UIImage *starON = [UIImage imageNamed:@"star_on.png"];
    UIImage *starON = [UIImage imageNamed:@"star2_yellow@2x.png"];
    NSTimeInterval mp3Duration = [appDelegate.avPlayerExtension getDurationFromMp3Filename:mp3Name];
    
    if (!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Sandbox_TbvCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects){
            if([currentObject isKindOfClass:[Sandbox_TbvCell class]]){
                cell = (Sandbox_TbvCell *)currentObject;
                break;
            }
        }
    }
    
    // 先把每個cell通通設成暗星星。
    [cell.btnStar setImage:starOFF forState:UIControlStateNormal];
    [cell.btnStar setImage:starOFF forState:UIControlStateSelected];
    cell.btnStar.selected = NO;
    // 把_mp3 Entity的index傳進cell裏的button，用以判斷是哪個cell被按到
    cell.btnStar.tag = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Mp3_EntityByString:mp3Name];     
    
    
    // 依照每個Mp3去檢查是否有被Favorite playlist連結到，如果有就顯示亮星星，否則就是暗星星
    NSNumber *isErr = [NSNumber numberWithBool:YES];
    mp3 *aMp3;
    for (aMp3 in appDelegate.dataFromSqlite._mp3){
        if ([aMp3.name isEqualToString:mp3Name]){
            if (aMp3.playlist_owner == nil){    // mp3沒有被任何playlist連結
                [cell.btnStar setImage:starOFF forState:UIControlStateNormal];
            }else{                              // mp3有被playlist連結
                for (playlist *aPlaylist in aMp3.playlist_owner){
                    if ([aPlaylist.name isEqualToString:@"favorite_playlist"]){
                        [cell.btnStar setImage:starON forState:UIControlStateNormal];
                        [cell.btnStar setImage:starON forState:UIControlStateSelected];
                        cell.btnStar.selected = YES;
                        break;
                    }else{
                        [cell.btnStar setImage:starOFF forState:UIControlStateNormal];
                        [cell.btnStar setImage:starOFF forState:UIControlStateSelected];
                        cell.btnStar.selected = NO;
                    }
                }
            }
            isErr = [NSNumber numberWithBool:NO];
            break;
        }
    }
    if (isErr.boolValue == YES){
        NSString *aMsg = @"Can NOT find mp3 in dataFromSqlite._mp3!";
        [appDelegate.utility ErrLog:self.class withFuncName:@"cellForRowAtIndexPath" withMsg:aMsg];
    }
    //
    
    //[cell.btnStar setImage:star forState:UIControlStateNormal];
    cell.lblMp3Name.text = mp3Name;
    cell.lblTotalDuration.text = [NSString stringWithFormat:@"%d:%02d", (int)mp3Duration / 60, (int)mp3Duration % 60, nil];

//	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
//	if (cell == nil){
//		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
//	}
//	NSUInteger row = [indexPath row];
//	cell.textLabel.text = [self.listData objectAtIndex:row];
//	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

// 當TableView的某個RowCell被按下之後，就會呼叫這個函式
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog([NSString stringWithFormat:@"%d", indexPath.row], nil);
	AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
        
    NSString *strPrepareToPlayMP3Filename = [appDelegate.aryAllMP3FilesInSandbox objectAtIndex:[indexPath row]];
    // 切換到正在撥放(Playing)這個頁面
	[self do_goPlaying:strPrepareToPlayMP3Filename];
	//

    // 關閉Favorite的List順序撥放
    appDelegate.dataFromSqlite._preferences.last_opened_playlist = @"temp_playlist";
    //
    
    //=======切換畫面到Playing_ViewController========//
    Playing_ViewController *pVC = appDelegate.viewCon_Playing;
    
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            [pVC setTitle:@"Playing"]; break;
        case iChinese_lang:
            [pVC setTitle:@"撥放頁"]; break;
    }

    
	pVC.needToPlayNewFile = self.needToPlayNewFile;
    self.needToPlayNewFile = [NSNumber numberWithInt:NO];
    
	pVC.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:pVC animated:YES];
    
}

// 設定UITableView可以被編輯(移位、刪除、新增)
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *alertTitle, *alertMsg, *alartCancelTitle;
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            alertTitle = @"File Deletion Failed";
            alertMsg = @"File %@ not found.";
            alartCancelTitle = @"OK";
            break;
        case iChinese_lang:
            alertTitle = @"檔案刪除錯誤";
            alertMsg = @"找不到 %@ 檔案.";
            alartCancelTitle = @"確認";
            break;
    }

    
    //判斷編輯表格的類型為「刪除」
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 刪除檔案
        NSString *strPrepareToDeleteMP3Filename = [self.listData objectAtIndex:[indexPath row]];
        // 找出filename_mp3對應的URL
        NSError *error;
        NSString *path_without_filename, *path_with_filename;
        NSArray *paths;
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path_without_filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@""];
        path_with_filename = [path_without_filename stringByAppendingPathComponent:strPrepareToDeleteMP3Filename];
        // 刪除檔案
        if (![[NSFileManager defaultManager] removeItemAtPath:path_with_filename error:&error]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                message:[NSString stringWithFormat:alertMsg, strPrepareToDeleteMP3Filename]
                                                               delegate:self 
                                                      cancelButtonTitle:alartCancelTitle otherButtonTitles:nil];
            [alertView show];
        }else{
            // 刪除對應的陣列元素
            [self.listData removeObjectAtIndex:indexPath.row];
            
            // 刪除CoreData裏面的_mp3
            // 因為Mp3 Entity Array裏面的資料並沒有排序是亂的，所以必需靠querryIndexOfObjectOfArray_Mp3_EntityByString函式找出位置。
            NSInteger deleteIndex = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Mp3_EntityByString:strPrepareToDeleteMP3Filename];
            mp3 *aNeedToDelMp3_mp3 = (mp3 *)[appDelegate.dataFromSqlite._mp3 objectAtIndex:deleteIndex];
            [appDelegate.managedObjectContext deleteObject:aNeedToDelMp3_mp3];          
                      
            // 刪除對應的表格項目
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
            
            // 再從DB找把資料載到Memory。主要是更新_mp3以及_tag，但基本上_preference...都會被更新
            [appDelegate.dataFromSqlite loadDataFromDBToMemory];
            
            [appDelegate saveContext];
            
        }
    }
}
@end
