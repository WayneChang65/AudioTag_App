//
//  Favorite_ViewController.m
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Favorite_ViewController.h"
#import "Playing_ViewController.h"
#import "AudioTagAppDelegate.h"
#import "Favorite_TbvCell.h"
#import "Sandbox_ViewController.h"

@implementation Favorite_ViewController

@synthesize listData;
@synthesize tbvFavoriteDisplay;
@synthesize listData_MP3OrTAG_Status;
@synthesize maryOOFPA;  // OOFPA : Order Of Favorite Playlist Array
@synthesize numIndexOfPlayFavoriteList;

@synthesize strTheNextPlayName;
@synthesize numIsTagTheNextPlay;

@synthesize strThePreviousPlayName;
@synthesize numIsTagThePreviousPlay;

@synthesize tmrRefreshPlayTypeBtn;

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
- (void)do_playType:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *lbbtnTitle_Single, *lbbtnTitle_List;
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            lbbtnTitle_Single = @"SINGLE";
            lbbtnTitle_List = @"LIST";
            break;
        case iChinese_lang:
            lbbtnTitle_Single = @"單曲";
            lbbtnTitle_List = @"列表";
            break;
    }
    
    if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
        appDelegate.dataFromSqlite._preferences.last_opened_playlist = @"temp_playlist";
        [self.navigationItem.leftBarButtonItem setTitle:lbbtnTitle_Single];
    }else{
        appDelegate.dataFromSqlite._preferences.last_opened_playlist = @"favorite_playlist";
        [self.navigationItem.leftBarButtonItem setTitle:lbbtnTitle_List];
    }
    
    
/*    
    if (appDelegate.numPlayType.intValue == PLAYTYPE_SINGLE_SONG) {
        appDelegate.numPlayType = [NSNumber numberWithInt:PLAYTYPE_PLAY_LIST];
        [self.navigationItem.leftBarButtonItem setTitle:@"LIST"];
    }else{
        appDelegate.numPlayType = [NSNumber numberWithInt:PLAYTYPE_SINGLE_SONG];
        [self.navigationItem.leftBarButtonItem setTitle:@"SINGLE"];
    }
*/ 
/*
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    playlist *plistFavorite = appDelegate.dataFromSqlite._favorite_playlist;
    mp3 *aMp3 = [appDelegate.dataFromSqlite._mp3 objectAtIndex:3]; // 隨便找個第三號mp3來掛
    [plistFavorite addOwned_mp3sObject:aMp3];
    
    [appDelegate.dataFromSqlite loadDataFromDBToMemory];
    [self refreshTableView];
*/ 
   
}

- (void)do_goPlaying:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    Playing_ViewController *pVC = appDelegate.viewCon_Playing;
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            [pVC setTitle:@"Playing"]; break;
        case iChinese_lang:
            [pVC setTitle:@"撥放頁"]; break;
    }
    
	pVC.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:pVC animated:YES];
    
}

- (void)playFavoriteListMp3orTag:(NSString *)strPrepareToPlayMp3OrTagName isTag:(BOOL)bIsTag
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (bIsTag == NO){ // MP3
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY-MP3" object:strPrepareToPlayMp3OrTagName];
        // 啟動Favorite的List順序撥放
        //appDelegate.dataFromSqlite._preferences.last_opened_playlist = @"favorite_playlist";
        //
        
       
        //=======切換畫面到Playing_ViewController========//
        Playing_ViewController *pVC = appDelegate.viewCon_Playing;
        
        switch (appDelegate.numLanguage.intValue) {
            case iEnglish_lang:
                [pVC setTitle:@"Playing"]; break;
            case iChinese_lang:
                [pVC setTitle:@"撥放頁"]; break;
        }
        
        pVC.needToPlayNewFile = [NSNumber numberWithInt:YES];
        
        pVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pVC animated:YES];
        
    }else{  // TAG
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY-TAG" object:strPrepareToPlayMp3OrTagName];     
        
        // 這裏要判斷，如果Tag所連結的mp3不存在，就不要再切換到Playing_ViewController了，直接return掉。
        NSArray *tagArray_CoreDataType = appDelegate.dataFromSqlite._tag;
        NSInteger indexOfTag = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Tag_EntityByString:strPrepareToPlayMp3OrTagName];
        tag *aTag = [tagArray_CoreDataType objectAtIndex:indexOfTag];
        
        // 如果被點選的Tag所連結的mp3指標為nil，就直接return，不做任何事。
        if (aTag.linked_mp3 == nil){
            return;
        }else{ 
            //
            // 啟動Favorite的List順序撥放
            //appDelegate.dataFromSqlite._preferences.last_opened_playlist = @"favorite_playlist";
            //
            
            //=======切換畫面到Playing_ViewController========//
            Playing_ViewController *pVC = appDelegate.viewCon_Playing;
            
            switch (appDelegate.numLanguage.intValue) {
                case iEnglish_lang:
                    [pVC setTitle:@"Playing"]; break;
                case iChinese_lang:
                    [pVC setTitle:@"撥放頁"]; break;
            }
            
            pVC.needToPlayNewFile = [NSNumber numberWithInt:YES];
            pVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pVC animated:YES];
        }
    }

}


- (int)selectPreviousPlay:(NSString *)currentPlayingName isLoop:(BOOL)loop
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    int currentPlayingIndex = [appDelegate.utility querryIndexOfArrayByString:self.listData givingString:currentPlayingName];
    BOOL currentPlayisTheFirst;
    if (currentPlayingIndex > 0){
        currentPlayisTheFirst = NO;
        currentPlayingIndex--;  // 把index減1，表示上一首
    }else if (currentPlayingIndex == 0){
        currentPlayisTheFirst = YES;
        if (loop == YES){
            currentPlayingIndex = [self.listData count] - 1;    // 傳回最後一首
        }else{
            currentPlayingIndex = -1;    // 沒有上一首了，到頂了，而且又沒有要Loop撥放
        }
    }else{  //currentPlayingIndex < 0 異常！！！
    }
    
    return currentPlayingIndex;
    
}

- (int)selectNextPlay:(NSString *)currentPlayingName isLoop:(BOOL)loop
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    int currentPlayingIndex = [appDelegate.utility querryIndexOfArrayByString:self.listData givingString:currentPlayingName];
    BOOL currentPlayisTheLast;
//    NSString *theNextPlay;
    if (currentPlayingIndex < ([self.listData count] - 1)){
        currentPlayisTheLast = NO;
        currentPlayingIndex++;  // 把index加1，表示下一首
//        theNextPlay = [listDataArray objectAtIndex:currentPlayingIndex];
    }else{
        currentPlayisTheLast = YES;
        if (loop == YES){
            currentPlayingIndex = 0;    // 傳回第一首
//            theNextPlay = [listDataArray objectAtIndex:currentPlayingIndex];
        }else{
            currentPlayingIndex = -1;    // 沒有下一首了，到底了，而且又沒有要Loop撥放
        }
    }
           
    return currentPlayingIndex;
}

- (void)refreshTableView
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    playlist *plistFavorite = appDelegate.dataFromSqlite._favorite_playlist;
    NSSet *ownedMp3s = plistFavorite.owned_mp3s;
    NSSet *ownedTags = plistFavorite.owned_tags;
    
    // 排序 ...用NSSortDescriptor的排序，還是試不出來。呵....算了，我不用了。
    //NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    //NSArray *sortDescriptors = [NSArray arrayWithObjects:sd, nil];
    //self.listData = [ownedMp3s sortedArrayUsingDescriptors:sortDescriptors];
    //self.listData = [ownedMp3s allObjects];
    //
    
    NSMutableArray *favoriteArray = [[NSMutableArray alloc] init];
    
    for (mp3 *aMp3 in ownedMp3s){
        [favoriteArray addObject:aMp3.name];
    }
    
    for (tag *aTag in ownedTags){
        [favoriteArray addObject:aTag.name];
    }
    
    self.listData = [NSMutableArray arrayWithArray:[appDelegate.utility sortMArrayInStringOrder:favoriteArray]];
    
    [self.listData_MP3OrTAG_Status removeAllObjects];
    
    for (int i = 0; i < [self.listData count]; i++){
    //for (NSString *aString in self.listData){
        // 以下這種方式判斷是否為mp3有個風險，就是如果Tag Name裏面有含以下以四種字串型式，都會被判斷為mp3，就有可能造成APP Crash
        NSString *aString = [self.listData objectAtIndex:i];
        NSRange aRange_mp3 = [aString rangeOfString:@".mp3"];
        NSRange aRange_Mp3 = [aString rangeOfString:@".Mp3"];
        NSRange aRange_mP3 = [aString rangeOfString:@".mP3"];
        NSRange aRange_MP3 = [aString rangeOfString:@".MP3"];
        if ((aRange_mp3.length > 0) || (aRange_Mp3.length > 0) || (aRange_mP3.length > 0) || (aRange_MP3.length > 0)){
            // mp3
            [self.listData_MP3OrTAG_Status addObject:[NSNumber numberWithBool:NO]];
        }else{
            // Tag
            [self.listData_MP3OrTAG_Status addObject:[NSNumber numberWithBool:YES]];
        }
    }
    
    [self.tbvFavoriteDisplay reloadData];
}

- (void)echoNotification_FavoritePrevious:(NSNotification *)notification {
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    // 取得由NSNotificationCenter送來的訊息
    // NSString *strFormObjectClass = [notification object];
    NSString *aMsg = @"Previous Play.";
    [appDelegate.utility MsgLog:self.class withFuncName:@"echoNoti_FavoPrev" withMsg:aMsg];
    NSString *currentPlayName = [notification object];
    int singleOrLoop = [appDelegate.dataFromSqlite._preferences.single_or_loop intValue];
    NSString *thePreviousPlayName;
    NSNumber *isTagThePreviousPlay;
    int idx_thePreviousPlayName = 0;
    
    if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"temp_playlist"]){
        return;    // 如果是單曲撥放模式，就直接跳離
    }else{
        // 撥放上一首    
        idx_thePreviousPlayName = [self selectPreviousPlay:currentPlayName isLoop:singleOrLoop];
        if (idx_thePreviousPlayName < 0){
            thePreviousPlayName = nil;  // 第一首，但沒有Loop撥放，所以上一首是回傳nil
            isTagThePreviousPlay = nil;
        }else{
            if (idx_thePreviousPlayName < self.listData.count){
                thePreviousPlayName = [self.listData objectAtIndex:idx_thePreviousPlayName];
                isTagThePreviousPlay = [self.listData_MP3OrTAG_Status objectAtIndex:idx_thePreviousPlayName];
            }else{
                thePreviousPlayName = nil;  
                isTagThePreviousPlay = nil;                
            }
        }
        self.strThePreviousPlayName = thePreviousPlayName;
        self.numIsTagThePreviousPlay = isTagThePreviousPlay;
        aMsg = [NSString stringWithFormat:@"%@---%d", thePreviousPlayName, isTagThePreviousPlay.intValue];
        [appDelegate.utility MsgLog:self.class withFuncName:@"echoNoti_FavoPrev" withMsg:aMsg];        
    }

}

- (void)echoNotification_FavoriteNext:(NSNotification *)notification {
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    // 取得由NSNotificationCenter送來的訊息
    // NSString *strFormObjectClass = [notification object];
    NSString *aMsg = @"A MP3/TAG Finished.";
    [appDelegate.utility MsgLog:self.class withFuncName:@"echoNoti_FavoNext" withMsg:aMsg];
    NSString *currentPlayName = [notification object];
    int singleOrLoop = [appDelegate.dataFromSqlite._preferences.single_or_loop intValue];
    NSString *theNextPlayName;
    NSNumber *isTagTheNextPlay;
    int idx_theNextPlayName = 0;
    
    //if ([appDelegate.numPlayType intValue] == PLAYTYPE_SINGLE_SONG){ 
    if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"temp_playlist"]){
        return;    // 如果是單曲撥放模式，就直接跳離
    }else{
    // 撥放下一首    
        idx_theNextPlayName = [self selectNextPlay:currentPlayName isLoop:singleOrLoop];
        if (idx_theNextPlayName < 0){
            theNextPlayName = nil;  // 最後一首，但沒有Loop撥放，所以下一首是回傳nil
            isTagTheNextPlay = nil;
        }else{
            if (idx_theNextPlayName < self.listData.count){
                theNextPlayName = [self.listData objectAtIndex:idx_theNextPlayName];
                isTagTheNextPlay = [self.listData_MP3OrTAG_Status objectAtIndex:idx_theNextPlayName];
            }else{
                theNextPlayName = nil;  
                isTagTheNextPlay = nil;                
            }
        }
        self.strTheNextPlayName = theNextPlayName;
        self.numIsTagTheNextPlay = isTagTheNextPlay;
        aMsg = [NSString stringWithFormat:@"%@---%d", theNextPlayName, isTagTheNextPlay.intValue];
        [appDelegate.utility MsgLog:self.class withFuncName:@"echoNoti_FavoNext" withMsg:aMsg];        
    }
}

- (NSArray *)getPreviousPlayInfo:(NSString *)currentPlayName {
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *thePreviousPlayName = self.strThePreviousPlayName;
    NSNumber *isTagThePreviousPlay = self.numIsTagThePreviousPlay;
    NSArray *result;
    NSString *aMsg = [NSString stringWithFormat:@"%@---%d", thePreviousPlayName, isTagThePreviousPlay.intValue];
    [appDelegate.utility MsgLog:self.class withFuncName:@"getPreviousPlayInfo" withMsg:aMsg];
    
    if (thePreviousPlayName != nil && isTagThePreviousPlay != nil){
        result = [NSArray arrayWithObjects:thePreviousPlayName, isTagThePreviousPlay, nil];
    }else{
        result = nil;
    }
    return result;
}
    
- (NSArray *)getNextPlayInfo:(NSString *)currentPlayName {
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
/*
    int singleOrLoop = [appDelegate.dataFromSqlite._preferences.single_or_loop intValue];
    int idx_theNxtPlayName = 0;

    // 撥放下一首    
    idx_theNxtPlayName = [self selectNextPlay:currentPlayName isLoop:singleOrLoop];
    if (idx_theNxtPlayName < 0){
        theNextPlayName = nil;  // 最後一首，但沒有Loop撥放，所以下一首是回傳nil
    }else{
        theNextPlayName = [self.listData objectAtIndex:idx_theNxtPlayName];
        isTagTheNextPlay = [self.listData_MP3OrTAG_Status objectAtIndex:idx_theNxtPlayName];
    }
*/  
    NSString *theNextPlayName = self.strTheNextPlayName;
    NSNumber *isTagTheNextPlay = self.numIsTagTheNextPlay;
    NSArray *result;
    NSString *aMsg = [NSString stringWithFormat:@"%@---%d", theNextPlayName, isTagTheNextPlay.intValue];
    [appDelegate.utility MsgLog:self.class withFuncName:@"getNextPlayInfo" withMsg:aMsg];
    
    if (theNextPlayName != nil && isTagTheNextPlay != nil){
        result = [NSArray arrayWithObjects:theNextPlayName, isTagTheNextPlay, nil];
    }else{
        result = nil;
    }
    return result;
}

- (void)echoNotification:(NSNotification *)notification {
    
    //取得由NSNotificationCenter送來的訊息
    NSString *strFromObjectClass = [notification object];
    //NSArray *anyArray = [notification object];
    //NSLog(@"%@", [anyArray componentsJoinedByString:@"\n"]);
    
    if ([strFromObjectClass isEqualToString:@"Favorite_TbvCell"]){
        [self refreshTableView];
    }
}

- (void)refreshPlayTypeBtn {
    static uint old_listdata_count = 0;
    if (self.listData.count != old_listdata_count){
        [self viewDidAppear:YES];
    }
    old_listdata_count = self.listData.count;
}

/*
#pragma mark Elements Order of Playlist Methods
// OOFPA : Order Of Favorite Playlist Array

- (NSMutableArray *)Load_OOFPA_fromCoredataEntity {
    //AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSString *strOOFPA = appDelegate.dataFromSqlite._preferences.elements_order_of_playlist;
    NSString *strOOFPA = @"abc1.mp3,abc2.mp3,tag1,tag2,abc3.mp3,tag10,tag02,gg.mp3,";
    NSString *strCommaSign = @",";
    NSMutableArray *maryOOFPA = [NSMutableArray arrayWithArray:[strOOFPA componentsSeparatedByString:strCommaSign]];
    
    return maryOOFPA;
}
*/


#pragma mark System Default Methods
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    NSLog(@"Favorite_ViewController:ViewDidLoad");
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *goPlayingTitle;
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            goPlayingTitle = @"Playing"; break;
        case iChinese_lang:
            goPlayingTitle = @"撥放頁"; break;
    }

    
    
    // OOFPA : Order Of Favorite Playlist Array
    //NSString *strOOFPA = @"abc1.mp3,abc2.mp3,tag1,tag2,abc3.mp3,tag10,tag02,gg.mp3,";
    NSString *strOOFPA = appDelegate.dataFromSqlite._preferences.elements_order_of_playlist;
    NSString *strCommaSign = @",";
    self.maryOOFPA = [NSMutableArray arrayWithArray:[strOOFPA componentsSeparatedByString:strCommaSign]];

    self.listData_MP3OrTAG_Status = [[NSMutableArray alloc] init];
//    self.numPlayType = [[NSNumber alloc] initWithInt:PLAYTYPE_SINGLE_SONG];
    self.numIndexOfPlayFavoriteList = [[NSNumber alloc] initWithInt:0];
    
    // Navigation Control右邊的Button設定
	UIBarButtonItem *goPlaying = [[UIBarButtonItem alloc] initWithTitle:goPlayingTitle 
                                                                  style:UIBarButtonItemStylePlain 
                                                                 target:self
                                                                 action:@selector(do_goPlaying:)];
    goPlaying.tintColor = RGBA(0, 0, 0, 0);
	self.navigationItem.rightBarButtonItem = goPlaying;
	//	

/*    
    // Navigation Control左邊的Button設定
    NSString *strPlayType;
    if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
        strPlayType = @"LIST";
    }else{
        strPlayType = @"SINGLE";
    }
	UIBarButtonItem *playType = [[UIBarButtonItem alloc] initWithTitle:strPlayType 
                                                             style:UIBarButtonItemStylePlain 
                                                            target:self 
                                                            action:@selector(do_playType:)];
    //action:@selector(do_iniSqliteDB:)];
	self.navigationItem.leftBarButtonItem = playType;
*/    
    
    self.strTheNextPlayName = nil;
    self.numIsTagTheNextPlay = nil;
    
    self.strThePreviousPlayName = nil;
    self.numIsTagThePreviousPlay = nil;
    
    self.tmrRefreshPlayTypeBtn = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(refreshPlayTypeBtn) userInfo:nil repeats:YES];
    
    [self refreshTableView];
    
    // 訂閱Notification
    // -當PlayViewController撥放完成某Favorite Playlist裏的任一首mp3/tag時，就會發出此Notification。
    // 通知Favorite_ViewController選擇下一首mp3/tag，並通知Sandbox_ViewController或Tag_ViewController撥放。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(echoNotification_FavoriteNext:) name:@"FAVORITE-NEXT" object:nil];
    
    // 訂閱Notification
    // 上一首撥放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(echoNotification_FavoritePrevious:) name:@"FAVORITE-PREVIOUS" object:nil];
    
    
    // 訂閱Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(echoNotification:) name:@"REFRESH-TABLEVIEW" object:nil];
    
    // Tag_ViewController初始化完成，tabBarCon再切回Sandbox_ViewController
    [appDelegate.tabBarCon_audioTag setSelectedIndex:0];
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    //AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[appDelegate.utility showNSStringArrayInConsole:[self Load_OOFPA_fromCoredataEntity]];
    [self refreshTableView];
                     
	[super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString *lbbtnTitle_Single, *lbbtnTitle_List;
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            lbbtnTitle_Single = @"SINGLE";
            lbbtnTitle_List = @"LIST";
            break;
        case iChinese_lang:
            lbbtnTitle_Single = @"單曲";
            lbbtnTitle_List = @"列表";
            break;
    }

    
    if (self.listData.count == 0){  // 表示Favorite_ViewController裏的TableView沒有任何項目
        appDelegate.dataFromSqlite._preferences.last_opened_playlist = @"temp_playlist";
        [self.navigationItem.leftBarButtonItem setTitle:lbbtnTitle_Single];
        self.navigationItem.leftBarButtonItem.enabled = NO;
    }else{
        if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
            [self.navigationItem.leftBarButtonItem setTitle:lbbtnTitle_List];
        }else{
            [self.navigationItem.leftBarButtonItem setTitle:lbbtnTitle_Single];
        }
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.listData = nil;
    self.tbvFavoriteDisplay = nil;
    self.listData_MP3OrTAG_Status = nil;
//    self.numPlayType = nil;
    self.numIndexOfPlayFavoriteList = nil;
    self.maryOOFPA = nil;
    
    self.strTheNextPlayName = nil;
    self.numIsTagTheNextPlay = nil;
    
    self.strThePreviousPlayName = nil;
    self.numIsTagThePreviousPlay = nil;
    
    self.tmrRefreshPlayTypeBtn = nil;
    
    // 取消訂閱Notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FAVORITE-NEXT" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FAVORITE-PREVIOUS" object:nil];
    
    // 取消訂閱Notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REFRESH-TABLEVIEW" object:nil];

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
	return [self.listData count];
}

// 描述TablewView的每個cell要長成什麼樣子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	playlist *plistFavorite = appDelegate.dataFromSqlite._favorite_playlist;
    static NSString *SimpleTableIdentifier = @"Favorite_TableIdentifier";
    Favorite_TbvCell *cell = nil;
    NSString *mp3OrTagName = [self.listData objectAtIndex:indexPath.row];
    // 依照效率問題，mp3OrTagDuration應該要用GCD來處理
    NSTimeInterval mp3OrTagDuration = 0;
    cell = (Favorite_TbvCell *)[self.tbvFavoriteDisplay dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    //UIImage *starON = [UIImage imageNamed:@"star_on.png"];
    UIImage *starON = [UIImage imageNamed:@"star2_yellow@2x.png"];
    tag *aTag = nil;
    
    if (!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Favorite_TbvCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects){
            if([currentObject isKindOfClass:[Favorite_TbvCell class]]){
                cell = (Favorite_TbvCell *)currentObject;
                break;
            }
        }
    }
    
    cell.lblTotalDuration.text = @"?:??";
    
    // 以下這種方式判斷是否為mp3有個風險，就是如果Tag Name裏面有含以下以四種字串型式，都會被判斷為mp3，就有可能造成APP Crash
    NSRange aRange_mp3 = [mp3OrTagName rangeOfString:@".mp3"];
    NSRange aRange_Mp3 = [mp3OrTagName rangeOfString:@".Mp3"];
    NSRange aRange_mP3 = [mp3OrTagName rangeOfString:@".mP3"];
    NSRange aRange_MP3 = [mp3OrTagName rangeOfString:@".MP3"];
    if ((aRange_mp3.length > 0) || (aRange_Mp3.length > 0) || (aRange_mP3.length > 0) || (aRange_MP3.length > 0)){
        // mp3
        cell.lblMp3OrTag.textColor = [UIColor blackColor];
        cell.lblMp3OrTag.text = @"MP3";
        cell.lblMp3OrTag.backgroundColor = RGBA(135, 206, 250, 0.5);
        
        // 把_mp3 Entity的index傳進cell裏的button，用以判斷是哪個cell被按到
        cell.btnStar.tag = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Mp3_EntityByString:mp3OrTagName]; 
        
        mp3OrTagDuration = [appDelegate.avPlayerExtension getDurationFromMp3Filename:mp3OrTagName];
        cell.lblTotalDuration.text = [NSString stringWithFormat:@"%d:%02d", (int)mp3OrTagDuration / 60, (int)mp3OrTagDuration % 60, nil];
        
        cell.imgvUnlinkedTag.hidden = YES;
    }else{
        // tag
        cell.lblMp3OrTag.textColor = [UIColor blackColor];
        cell.lblMp3OrTag.text = @"TAG";
        cell.lblMp3OrTag.backgroundColor = RGBA(193, 255, 193, 1.0);
        // 把_mp3 Entity的index傳進cell裏的button，用以判斷是哪個cell被按到
        cell.btnStar.tag = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Tag_EntityByString:mp3OrTagName]; 
        
        aTag = [appDelegate.dataFromSqlite._tag objectAtIndex:cell.btnStar.tag];
        double a_time = [aTag.a_time doubleValue];
        double b_time = [aTag.b_time doubleValue];
        mp3OrTagDuration = b_time - a_time;
        cell.lblTotalDuration.text = [NSString stringWithFormat:@"%d:%02d", (int)mp3OrTagDuration / 60, (int)mp3OrTagDuration % 60, nil];
        
        if (aTag.linked_mp3 == nil){
            cell.imgvUnlinkedTag.hidden = NO;
            [plistFavorite removeOwned_tagsObject:aTag];
            //[appDelegate.dataFromSqlite loadDataFromDBToMemory];
            //[self.listData delete:[self.listData objectAtIndex:indexPath.row]]; // 刪除沒有連結到mp3的tag
            [self refreshTableView];
            //[self.tbvFavoriteDisplay reloadData];
        }else{
            cell.imgvUnlinkedTag.hidden = YES;
        }
    }
    
    // 先把每個cell通通設成亮星星。
    [cell.btnStar setImage:starON forState:UIControlStateNormal];
    cell.btnStar.selected = YES;
    
    cell.lblFavoriteItemName.text = [NSString stringWithString:mp3OrTagName];
    cell.lblSimpleDescription.text = aTag.commet;
    
	return cell;
}

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog([NSString stringWithFormat:@"%d", indexPath.row], nil);
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *strPrepareToPlayMp3OrTagName = [NSString stringWithString:[self.listData objectAtIndex:indexPath.row]];
    NSNumber *isTag = [self.listData_MP3OrTAG_Status objectAtIndex:indexPath.row];
    if (isTag.boolValue == NO){ // MP3
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY-MP3" object:strPrepareToPlayMp3OrTagName];
        // 啟動Favorite的List順序撥放
        //appDelegate.dataFromSqlite._preferences.last_opened_playlist = @"favorite_playlist";
        //
        //=======切換畫面到Playing_ViewController========//
        Playing_ViewController *pVC = appDelegate.viewCon_Playing;
        switch (appDelegate.numLanguage.intValue) {
            case iEnglish_lang:
                [pVC setTitle:@"Playing"]; break;
            case iChinese_lang:
                [pVC setTitle:@"撥放頁"]; break;
        }
        
        pVC.needToPlayNewFile = [NSNumber numberWithInt:YES];
        
        pVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pVC animated:YES];
        
    }else{                      // TAG
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY-TAG" object:strPrepareToPlayMp3OrTagName];     
        
        // 這裏要判斷，如果Tag所連結的mp3不存在，就不要再切換到Playing_ViewController了，直接return掉。
        NSArray *tagArray_CoreDataType = appDelegate.dataFromSqlite._tag;
        NSInteger indexOfTag = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Tag_EntityByString:strPrepareToPlayMp3OrTagName];
        tag *aTag = [tagArray_CoreDataType objectAtIndex:indexOfTag];
        
        // 如果被點選的Tag所連結的mp3指標為nil，就直接return，不做任何事。
        if (aTag.linked_mp3 == nil){
            return;
        }else{ 
        //
            // 啟動Favorite的List順序撥放
            //appDelegate.dataFromSqlite._preferences.last_opened_playlist = @"favorite_playlist";
            //
            
            //=======切換畫面到Playing_ViewController========//
            Playing_ViewController *pVC = appDelegate.viewCon_Playing;
            switch (appDelegate.numLanguage.intValue) {
                case iEnglish_lang:
                    [pVC setTitle:@"Playing"]; break;
                case iChinese_lang:
                    [pVC setTitle:@"撥放頁"]; break;
            }
        
            pVC.needToPlayNewFile = [NSNumber numberWithInt:YES];
            pVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pVC animated:YES];
        }
    }
}


@end
