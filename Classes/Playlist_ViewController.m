//
//  Playlist_ViewController.m
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Playlist_ViewController.h"
#import "Playing_ViewController.h"
#import "AudioTagAppDelegate.h"
#import "Playlist_TbvCell.h"
#import "SVStatusHUD.h"


@implementation Playlist_ViewController

@synthesize listData;
@synthesize listData_Image;
@synthesize tbvPlaylistDispaly;
@synthesize btnLanguage;

//@synthesize mstrPlayingMP3Filename;

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

- (void)do_goPlaying:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    Playing_ViewController *pVC = appDelegate.viewCon_Playing;
    [pVC setTitle:@"Playing"];
    
	pVC.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:pVC animated:YES];
}

- (void)do_goRight:(id)sender
{
    [SVStatusHUD showWithImage:[UIImage imageNamed:@"6"] status:@"俺は医者だ!"];
    //[self do_iniSqliteDB:sender];
}

- (void)do_goLeft:(id)sender
{
    [SVStatusHUD showWithImage:[UIImage imageNamed:@"1"] status:@"海賊王に俺はなる"];
}

- (void)do_iniSqliteDB:(id)sender
{
	AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	
    [appDelegate.dataFromSqlite saveInitialDataToDB_Test];
}

- (IBAction)changeLanguage_Pressed:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    int iLanguage = appDelegate.dataFromSqlite._preferences.language.intValue;
    
    switch (iLanguage) {
        case iEnglish_lang:
            appDelegate.dataFromSqlite._preferences.language = strChinese_lang;
            [self.btnLanguage setTitle:strChinese_lang forState:UIControlStateNormal];
            break;
        case iChinese_lang:
            appDelegate.dataFromSqlite._preferences.language = strEnglish_lang;
            [self.btnLanguage setTitle:strEnglish_lang forState:UIControlStateNormal];            
            break;
        default:
            appDelegate.dataFromSqlite._preferences.language = strEnglish_lang;
            [self.btnLanguage setTitle:strEnglish_lang forState:UIControlStateNormal];            
            break;
    }
    
    
    NSString *msg = appDelegate.dataFromSqlite._preferences.language;
    NSLog(@"%@", msg);
    // 再從DB找把資料載到Memory。主要是更新_mp3以及_tag，但基本上_preference...都會被更新
    //[appDelegate.dataFromSqlite loadDataFromDBToMemory];
    [appDelegate saveContext];

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    NSLog(@"Playlist_ViewController:ViewDidLoad");
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	// Navigation Control右邊的Button設定
	UIBarButtonItem *goRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
																			   target:self 
																			   action:@selector(do_goRight:)];
	self.navigationItem.rightBarButtonItem = goRight;
	self.navigationItem.rightBarButtonItem.enabled = YES;    // 目前沒用到，先設Disable
    //	
	
    // Navigation Control左邊的Button設定
	UIBarButtonItem *goLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
																			   target:self 
																			   action:@selector(do_goLeft:)];
	self.navigationItem.leftBarButtonItem = goLeft;
	self.navigationItem.leftBarButtonItem.enabled = YES;    // 目前沒用到，先設Disable
    //	

    
    self.listData = nil;
    self.listData_Image = nil;
    
    /*
    NSMutableArray *nameArray = [NSMutableArray arrayWithObjects:@"Luffy", @"Zoro", @"Sanji",
                                @"Usoppu", @"Nami", @"Chopper", @"Robin", @"StarOn", @"StarOff", nil];
    NSMutableArray *pictureArray = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"1.png"],
                                    [UIImage imageNamed:@"2.png"], [UIImage imageNamed:@"3.png"],
                                    [UIImage imageNamed:@"4.png"], [UIImage imageNamed:@"5.png"],
                                    [UIImage imageNamed:@"6.png"], [UIImage imageNamed:@"7.png"],
                                    [UIImage imageNamed:@"star_on.png"], [UIImage imageNamed:@"star_off.png"], nil];
    
    
    self.listData = nameArray;
    self.listData_Image = pictureArray;
    */
    
    int iLanguage = appDelegate.dataFromSqlite._preferences.language.intValue;
    
    switch (iLanguage) {
        case iEnglish_lang:
            [self.btnLanguage setTitle:strEnglish_lang forState:UIControlStateNormal];
            break;
        case iChinese_lang:
            [self.btnLanguage setTitle:strChinese_lang forState:UIControlStateNormal];
            break;
        default:
            [self.btnLanguage setTitle:strEnglish_lang forState:UIControlStateNormal];
            break;
    }

    
    [super viewDidLoad];
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
    self.listData_Image = nil;
    self.tbvPlaylistDispaly = nil;
    self.btnLanguage = nil;
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
    //return 1;
}

// 描述TablewView的每個cell要長成什麼樣子
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SimpleTableIdentifier = @"Playlist_TableIdentifier";
    
    Playlist_TbvCell *cell = nil;
    cell = (Playlist_TbvCell *)[self.tbvPlaylistDispaly dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    /*
    NSString *onePieceMember = [self.listData objectAtIndex:indexPath.row];
    UIImage *onePieceMemberPic = [self.listData_Image objectAtIndex:indexPath.row];
    */
    if (!cell)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"Playlist_TbvCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects){
            if([currentObject isKindOfClass:[Playlist_TbvCell class]]){
                cell = (Playlist_TbvCell *)currentObject;
                break;
            }
        }
    }
    
//    [cell.imgvPlaylistPicture setImage:onePieceMemberPic];
//    cell.lblPlaylistName.text = onePieceMember;
//    cell.lblNumberOfTags.text = @""/*@"???"*/;
    
//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	
//	if (cell == nil){
//		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
//	}
	
//	NSUInteger row = [indexPath row];
//	cell.textLabel.text = [self.listData objectAtIndex:row];
//	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}



@end
