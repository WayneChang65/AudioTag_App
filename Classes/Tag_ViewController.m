//
//  Tag_ViewController.m
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Tag_ViewController.h"
#import "Playing_ViewController.h"

#import "AudioTagAppDelegate.h"
#import "Tag_TbvCell.h"
@implementation Tag_ViewController

@synthesize listData;
@synthesize needToPlayNewFile;
@synthesize tbvTagDispaly;


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
// addTag_Pressed這個函式，只是一個測試函式。App正常運行時，不會用到這個函式。
- (IBAction)addTag_Pressed:(id)sender
{
    int whichMp3WillBeTagged = 3; // 這裏一定要確定3是有東西的，不然絕對會當機
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *aMp3WillBeTagged = [appDelegate.aryAllMP3FilesInSandbox objectAtIndex:whichMp3WillBeTagged];
    NSInteger indexInMp3Entity = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Mp3_EntityByString:aMp3WillBeTagged]; 
    
    mp3 *aMp3 = (mp3 *) [appDelegate.dataFromSqlite._mp3 objectAtIndex:indexInMp3Entity];
    
    tag *aTag = (tag *) [NSEntityDescription insertNewObjectForEntityForName:@"tag"
                                                      inManagedObjectContext:appDelegate.managedObjectContext];
    aTag.name = @"myTag4";
    aTag.commet = @"Test 4";
    //aTag.linked_mp3filename = [appDelegate.aryAllMP3FilesInSandbox lastObject];
    aTag.linked_mp3filename = aMp3WillBeTagged;
    aTag.a_time = [NSString stringWithFormat:@"%f",(double)12.0];
    aTag.b_time = [NSString stringWithFormat:@"%f",(double)20.0];
    aTag.linked_mp3 = aMp3;
    
    [appDelegate.dataFromSqlite loadDataFromDBToMemory];
    //[appDelegate.dataFromSqlite._tag addObject:aTag];
    
    [appDelegate saveContext];
    
    [self refreshTableView];

}

/*
- (IBAction)addTag_Pressed:(id)sender
{
    int whichMp3WillBeTagged = 3;
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mp3 *aMp3 = (mp3 *) [NSEntityDescription insertNewObjectForEntityForName:@"mp3" 
                                                      inManagedObjectContext:appDelegate.managedObjectContext];
    //aMp3.name = [appDelegate.aryAllMP3FilesInSandbox lastObject];
    aMp3.name = [appDelegate.aryAllMP3FilesInSandbox objectAtIndex:whichMp3WillBeTagged];
    
    tag *aTag = (tag *) [NSEntityDescription insertNewObjectForEntityForName:@"tag"
                                                      inManagedObjectContext:appDelegate.managedObjectContext];
    aTag.name = @"myTag3";
    aTag.commet = @"Test 3";
    //aTag.linked_mp3filename = [appDelegate.aryAllMP3FilesInSandbox lastObject];
    aTag.linked_mp3filename = [appDelegate.aryAllMP3FilesInSandbox objectAtIndex:whichMp3WillBeTagged];
    aTag.a_time = [NSString stringWithFormat:@"%f",(double)10.0];
    aTag.b_time = [NSString stringWithFormat:@"%f",(double)30.0];
    aTag.linked_mp3 = aMp3;
    
    //mp3 *aMP3 = [appDelegate.dataFromSqlite._mp3 lastObject];
    
    // 這裏為什麼要判斷aMP3 is Fault呢？
    // 因為進入程式後，如果呼叫saveInitialDataToDB_Test，把資料庫清掉。
    // 接著馬上再AddTag的話，aMP3就會Fault掉，而無法指定給aTag.linked_mp3，就會當機。
    // 不過實際在用的時候，如果sqlite的database檔有跟著散佈的話，就不會有這個問題了。
    //    if (![aMP3 isFault]){
    //        aTag.linked_mp3 = aMP3;
    //    }else{
    //        aTag.linked_mp3 = nil;
    //    }
    //NSLog(@"%@", my1stTag.linked_mp3);
    
    [appDelegate.dataFromSqlite._mp3 addObject:aMp3];
    [appDelegate.dataFromSqlite._tag addObject:aTag];
    
    [appDelegate saveContext];
    
    [self refreshTableView];
    
}
*/

- (void)do_Edit:(id)sender
{
    static UIColor *old_backGroundColor;
    
    [self.tbvTagDispaly setEditing:!self.tbvTagDispaly.editing animated:YES];
    if (self.tbvTagDispaly.editing) {
        [self.navigationItem.leftBarButtonItem setTitle:@"Done"];
        old_backGroundColor = self.navigationItem.leftBarButtonItem.tintColor;
        [self.navigationItem.leftBarButtonItem setTintColor:RGBA(30, 144, 255, 1)];    //DodgerBlue
    }else{
        [self.navigationItem.leftBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setTintColor:old_backGroundColor];
    }
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
	pVC.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:pVC animated:YES];
	
	self.needToPlayNewFile = [NSNumber numberWithInt:NO];   
}

- (void)exe_do_goPlaying:(id)sender
{
    [self do_goPlaying:sender];
}

- (void)do_goPlaying:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *alertTitle, *alertMsg, *alartCancelTitle;
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            alertTitle = @"Tag Error";
            alertMsg = @"Linked MP3 file is not existed.";
            alartCancelTitle = @"OK";
            break;
        case iChinese_lang:
            alertTitle = @"Tag錯誤";
            alertMsg = @"Tag所連結的MP3檔案不存在！";
            alartCancelTitle = @"確認";
            break;
    }
    
    
    if (![sender isKindOfClass:[NSString class]]){
        [appDelegate.utility ErrLog:self.class withFuncName:@"do_goPlaying" withMsg:@"sender is NOT a NSString object!"];
        return;
    }
    
    NSString *stringOfListData = sender;
    NSArray *tagArray_CoreDataType = appDelegate.dataFromSqlite._tag;
    
    NSInteger indexOfTag = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Tag_EntityByString:stringOfListData];
    
    tag *aTag = [tagArray_CoreDataType objectAtIndex:indexOfTag];
    
    // 如果被點選的Tag所連結的mp3指標為nil，就直接return，不做任何事。
    if (aTag.linked_mp3 == nil){
        NSString *aErrMsg = @"Tag.linked_mp3 == nil";
        [appDelegate.utility MsgLog:self.class withFuncName:@"didSelectRowAtIndexPath" withMsg:aErrMsg];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle 
														message:alertMsg 
													   delegate:nil 
											  cancelButtonTitle:alartCancelTitle 
											  otherButtonTitles:nil];
		[alert show];
        return;
    } 
    //
    
    appDelegate.aTimeOfLastOpenedTag = [NSNumber numberWithDouble:[aTag.a_time doubleValue]];
    appDelegate.bTimeOfLastOpenedTag = [NSNumber numberWithDouble:[aTag.b_time doubleValue]];
    appDelegate.commentOfLastOpenedTag = [NSString stringWithString:aTag.commet];
    
    appDelegate.strPlayingTagName = [NSString stringWithString:aTag.name];
    
    //NSString *strPrepareToPlayMP3Filename = aTag.linked_mp3.name;
    NSString *strPrepareToPlayMP3Filename = [NSString stringWithString:aTag.linked_mp3.name];
    
    //NSString *strPlayingMP3Filename = appDelegate.mstrPlayingMP3Filename;
    NSString *strPlayingMP3Filename = [NSString stringWithString:appDelegate.mstrPlayingMP3Filename];
    
    if ([strPrepareToPlayMP3Filename isEqualToString:strPlayingMP3Filename]){
        if (appDelegate.dataFromSqlite._preferences.last_opened_tag == nil){
            self.needToPlayNewFile = [NSNumber numberWithInt:YES];
        }else{
            if ([appDelegate.dataFromSqlite._preferences.last_opened_tag isEqualToString:aTag.name]){
                self.needToPlayNewFile = [NSNumber numberWithInt:NO];
                // 如果同樣的Tag名稱，但是裏面的AB Key或資料已經被改變更新，還是要重撥。
                if (appDelegate.isTheSameNameTag_Update.boolValue == YES){
                    self.needToPlayNewFile = [NSNumber numberWithInt:YES];
                    appDelegate.isTheSameNameTag_Update = [[NSNumber alloc] initWithBool:NO];
                }
            }else{
                self.needToPlayNewFile = [NSNumber numberWithInt:YES];
            }
        }
    }else{
        self.needToPlayNewFile = [NSNumber numberWithInt:YES];
        appDelegate.dataFromSqlite._preferences.last_opened_mp3 = strPrepareToPlayMP3Filename;
        appDelegate.mstrPlayingMP3Filename = [NSMutableString stringWithString:strPrepareToPlayMP3Filename];
    }
    //    appDelegate.isPlay1stTimeFromStartApp = [NSNumber numberWithInt:NO];
    
    // 如果是從sandbox撥放mp3的話，last_opened_tag會被設成nil
    // 否則如果從Tag頁面撥放tag的話，last_opened_tag就會被設成tag.name
    //appDelegate.dataFromSqlite._preferences.last_opened_tag = aTag.name;
    appDelegate.dataFromSqlite._preferences.last_opened_tag = [NSString stringWithString:aTag.name];
    //

}

- (void)echoNotification:(NSNotification *)notification {
    NSLog(@"PLAY-TAG");
    //取得由NSNotificationCenter送來的訊息
    NSString *strPrepareToPlayTagName = [notification object];
    [self do_goPlaying:strPrepareToPlayTagName];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    NSLog(@"Tag_ViewController:ViewDidLoad");
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
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
    
    
	// Navigation Control右邊的Button設定
	UIBarButtonItem *goPlaying = [[UIBarButtonItem alloc] initWithTitle:goPlayingTitle 
                                                                  style:UIBarButtonItemStylePlain 
                                                                 target:self
                                                                 action:@selector(do_goPlaying_byBtn:)];
    goPlaying.tintColor = RGBA(0, 0, 0, 0);
	self.navigationItem.rightBarButtonItem = goPlaying;
	//	
    
	UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:editTitle 
                                                             style:UIBarButtonItemStylePlain 
                                                            target:self 
                                                            action:@selector(do_Edit:)];
	self.navigationItem.leftBarButtonItem = edit;
	//
    
    // 更新TableView資料
    [self refreshTableView];
    
    // 訂閱Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(echoNotification:) name:@"PLAY-TAG" object:nil];
    
    // 在ViewDidLoad後，將tabBarCon切到Favorite_ViewController做初始化。這都是為了做Favorite列表撥放的機能準備。
    [appDelegate.tabBarCon_audioTag setSelectedIndex:2];
       
    [super viewDidLoad];
}

- (void)refreshTableView
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    NSArray *tagArray_CoreDataType = appDelegate.dataFromSqlite._tag;
    tag *aTag; 
    NSMutableArray *tagArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [tagArray_CoreDataType count]; i++) {
        aTag = [tagArray_CoreDataType objectAtIndex:i];
        if (aTag.name != nil) [tagArray addObject:aTag.name];
    }
    
    self.listData = [NSMutableArray arrayWithArray:[appDelegate.utility sortMArrayInStringOrder:tagArray]];
    
    [self.tbvTagDispaly reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];

    NSLog(@"Tag_ViewController---viewWillAppear");
    if (self.tbvTagDispaly) [self.tbvTagDispaly reloadData];
    // 因為在Edit_ViewController有可能儲存Tag，當有儲存Tag時，這裏要更新一下
    if ([appDelegate.isTagSaved isEqualToNumber:[NSNumber numberWithBool:YES]]){
        [self refreshTableView];
        appDelegate.isTagSaved = [NSNumber numberWithBool:NO];
    }

     
	[super viewWillAppear:animated];
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
    self.needToPlayNewFile = nil;
    self.tbvTagDispaly = nil;
    
    // 取消訂閱Notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PLAY-TAG" object:nil];

}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    [super viewDidAppear:animated];
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
    static NSString *SimpleTableIdentifier = @"Tag_TableIdentifier";
    
    //NSArray *tagArray_CoreDataType = appDelegate.dataFromSqlite._tag;
    //NSArray *tagArray_CoreDataType = [NSArray arrayWithArray:appDelegate.dataFromSqlite._tag];
    //tag *aTag = [tagArray_CoreDataType objectAtIndex:[indexPath row]];
    
    Tag_TbvCell *cell = nil;
    cell = (Tag_TbvCell *)[tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    //NSString *TagName = aTag.name;
    NSString *TagName = [self.listData objectAtIndex:indexPath.row];
    //UIImage *starOFF = [UIImage imageNamed:@"star_off.png"];
    UIImage *starOFF = [UIImage imageNamed:@"star2@2x.png"];
    //UIImage *starON = [UIImage imageNamed:@"star_on.png"];
    UIImage *starON = [UIImage imageNamed:@"star2_yellow@2x.png"];
    
    if (!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Tag_TbvCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects){
            if([currentObject isKindOfClass:[Tag_TbvCell class]]){
                cell = (Tag_TbvCell *)currentObject;
                break;
            }
        }
    }

    // 先把每個cell通通設成暗星星。
    [cell.btnStar setImage:starOFF forState:UIControlStateNormal];
    cell.btnStar.selected = NO;
    // 把_tag Entity的index傳進cell裏的button，用以判斷是哪個cell被按到
    cell.btnStar.tag = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Tag_EntityByString:TagName];
    //
    
    // 依照每個Mp3去檢查是否有被Favorite playlist連結到，如果有就顯示亮星星，否則就是暗星星
    NSNumber *isErr = [NSNumber numberWithBool:YES];
    tag *aTag;
    for (aTag in appDelegate.dataFromSqlite._tag){
        if ([aTag.name isEqualToString:TagName]){
            if (aTag.playlist_owner == nil){    // tag沒有被任何playlist連結
                [cell.btnStar setImage:starOFF forState:UIControlStateNormal];
            }else{                              // mp3有被playlist連結
                for (playlist *aPlaylist in aTag.playlist_owner){
                    if ([aPlaylist.name isEqualToString:@"favorite_playlist"]){ // favorite_playlist
                        [cell.btnStar setImage:starON forState:UIControlStateNormal];
                        cell.btnStar.selected = YES;
                        break;
                    }else{                                                      // temp_playlist
                        [cell.btnStar setImage:starOFF forState:UIControlStateNormal];
                        cell.btnStar.selected = NO;
                    }
                }
            }
            isErr = [NSNumber numberWithBool:NO];
            break;
        }
    }
    if (isErr.boolValue == YES){
        NSString *aMsg = @"Can NOT find tag in dataFromSqlite._tag!";
        [appDelegate.utility ErrLog:self.class withFuncName:@"cellForRowAtIndexPath" withMsg:aMsg];
    }
    //

    // 依照每個Tag去檢查是否連結的mp3指標為nil，如果為nil代表該連結的mp3檔案其實不存在AP Document目錄
    isErr = [NSNumber numberWithBool:YES];
    aTag = nil;
    for (aTag in appDelegate.dataFromSqlite._tag){
        if ([aTag.name isEqualToString:TagName]){
            if (aTag.linked_mp3 == nil){
                cell.imgvUnlinkedTag.hidden = NO;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.userInteractionEnabled = NO;
                cell.lblTagName.textColor = [UIColor lightGrayColor];
            }else{
                cell.imgvUnlinkedTag.hidden = YES;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.userInteractionEnabled = YES;
            }
            isErr = [NSNumber numberWithBool:NO];
            break;
        }
    }
    if (isErr.boolValue == YES){
        NSString *aMsg = @"Can NOT find tag in dataFromSqlite._tag!";
        [appDelegate.utility ErrLog:self.class withFuncName:@"cellForRowAtIndexPath" withMsg:aMsg];
    }
    //
    
    double a_time = [aTag.a_time doubleValue];
    double b_time = [aTag.b_time doubleValue];
    NSTimeInterval tagDuration = b_time - a_time;
    
    
    cell.lblTagName.text = TagName;
    cell.lblTotalDuration.text = [NSString stringWithFormat:@"%d:%02d", (int)tagDuration / 60, (int)tagDuration % 60, nil];
    cell.lblSimpleDescription.text = aTag.commet;
    
    return cell;
}

 
// 當TableView的某個RowCell被按下之後，就會呼叫這個函式
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath

- (void)tableView:(UITableView *)sender didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	NSLog([NSString stringWithFormat:@"%d", indexPath.row], nil);
	AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
  
    NSString *stringOfListData = [self.listData objectAtIndex:[indexPath row]];
    
    
    // 切換到正在撥放(Playing)這個頁面
	[self do_goPlaying:stringOfListData];
	// 
    
    
    // 這裏要判斷，如果Tag所連結的mp3不存在，就不要再切換到Playing_ViewController了，直接return掉。
    NSArray *tagArray_CoreDataType = appDelegate.dataFromSqlite._tag;
    NSInteger indexOfTag = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Tag_EntityByString:stringOfListData];
    tag *aTag = [tagArray_CoreDataType objectAtIndex:indexOfTag];
    
    // 如果被點選的Tag所連結的mp3指標為nil，就直接return，不做任何事。
    if (aTag.linked_mp3 == nil){
        return;
    }else{ 
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
        pVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pVC animated:YES];
	
        self.needToPlayNewFile = [NSNumber numberWithInt:NO];   
        
        //
    }
       
}

// 設定UITableView可以被編輯(移位、刪除、新增)
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"[%@]Total Tag Number:%d", self.class, [appDelegate.dataFromSqlite._tag count]);
    // 刪除檔案
    NSString *strPrepareToDeleteTagName = [self.listData objectAtIndex:[indexPath row]];
    //判斷編輯表格的類型為「刪除」
    if (editingStyle == UITableViewCellEditingStyleDelete) {        
        // 刪除對應的陣列元素
        [self.listData removeObjectAtIndex:indexPath.row];
                
        // 刪除對應的表格項目
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        // 刪除CoreData裏面的_Tag
        NSInteger deleteIndex = [appDelegate.dataFromSqlite querryIndexOfObjectOfArray_Tag_EntityByString:strPrepareToDeleteTagName];
        tag *aNeedToDelTag_tag = (tag *)[appDelegate.dataFromSqlite._tag objectAtIndex:deleteIndex];
        [appDelegate.managedObjectContext deleteObject:aNeedToDelTag_tag];
        
        // 再從DB找把資料載到Memory。主要是更新_mp3以及_tag，但_preference...也會一併被更新
        [appDelegate.dataFromSqlite loadDataFromDBToMemory];
        [appDelegate saveContext];               
    }
}
@end
