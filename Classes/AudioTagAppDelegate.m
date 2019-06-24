//
//  AudioTagAppDelegate.m
//  AudioTag
//
//  Created by Chang Wayne on 2011/8/9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioTagAppDelegate.h"

#import "DataFromSqlite.h"
#import "Sandbox_ViewController.h"
#import "Tag_ViewController.h"
#import "Favorite_ViewController.h"
#import "Playlist_ViewController.h"
#import "Playing_ViewController.h"
#import "Utility.h"

#import "preferences.h"

@implementation AudioTagAppDelegate

@synthesize window;
@synthesize isPlay1stTimeFromStartApp;
@synthesize numLanguage;
@synthesize aTimeOfLastOpenedTag;
@synthesize bTimeOfLastOpenedTag;
@synthesize commentOfLastOpenedTag;
@synthesize isTagSaved;
@synthesize isNeedToResetABKey;
@synthesize isTheSameNameTag_Update;
//@synthesize numPlayType;
@synthesize aryAllMP3FilesInSandbox;
@synthesize mstrPlayingMP3Filename;
@synthesize strPlayingTagName;
@synthesize avapPlayer;
@synthesize tmrUpdatePlaying_ViewController;
@synthesize dataFromSqlite;
@synthesize utility;
@synthesize avPlayerExtension;
//@synthesize pllstTemp;
//@synthesize pllstFavorite;
@synthesize tabBarCon_audioTag;
@synthesize navCon_Sandbox;
@synthesize navCon_Tag;
@synthesize navCon_Favorite;
@synthesize navCon_Playlist;

@synthesize viewCon_Playing;
@synthesize viewCon_Edit;
@synthesize viewCon_Edit_BG;
@synthesize viewCon_Favorite;
@synthesize viewCon_Tag;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    // 印出Unhandled Exception Debug資訊
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.isPlay1stTimeFromStartApp = [NSNumber numberWithInt:YES];
    self.aTimeOfLastOpenedTag = [NSNumber numberWithDouble:0.0];
    self.bTimeOfLastOpenedTag = [NSNumber numberWithDouble:0.0];
    self.commentOfLastOpenedTag = @"";
    self.isTagSaved = [NSNumber numberWithBool:NO];
    self.isNeedToResetABKey = [NSNumber numberWithBool:YES];
    //self.isTheSameNameTag_Update = [NSNumber numberWithBool:NO];
    self.isTheSameNameTag_Update = [[NSNumber alloc] initWithBool:NO];
    
//    self.numPlayType = [NSNumber numberWithBool:PLAYTYPE_SINGLE_SONG];
    
	dataFromSqlite = [[DataFromSqlite alloc] init];
    utility = [[Utility alloc] init];
    avPlayerExtension = [[AVPlayerExtension alloc] init];
    
    [dataFromSqlite loadDataFromDBToMemory];
    self.numLanguage = [NSNumber numberWithInt:self.dataFromSqlite._preferences.language.intValue];
    
    // Test Exception 
    //[self.utility timeIntervalWithFormatString:@""];
    
    // Core Data所產生出來的類別，不能直接拿來alloc init (這點很重要)
//    pllstTemp = [[playlist alloc] init];
//    pllstFavorite = [[playlist alloc] init];
	
	Sandbox_ViewController *sandbox_VC = [[Sandbox_ViewController alloc] init];
	Tag_ViewController *tag_VC = [[Tag_ViewController alloc] init];
	Favorite_ViewController *favorite_VC = [[Favorite_ViewController alloc] init];
	Playlist_ViewController *playlist_VC = [[Playlist_ViewController alloc] init];
    
    mstrPlayingMP3Filename = [[NSMutableString alloc] initWithCapacity:255]; 
    [self.mstrPlayingMP3Filename setString:@"shit"];
	
    strPlayingTagName = nil;  
    
//	[self.dataFromSqlite loadDataFromDBToMemory];
	int iLanguage = self.numLanguage.intValue;
    switch (iLanguage) {
        case iEnglish_lang:
            [sandbox_VC setTitle:@"MP3"];
            [tag_VC setTitle:@"Tag"];
            [favorite_VC setTitle:@"Favorite"];
            [playlist_VC setTitle:@"About"];
            break;
        case iChinese_lang:
            [sandbox_VC setTitle:@"MP3"];
            [tag_VC setTitle:@"標籤"];
            [favorite_VC setTitle:@"我的最愛"];
            [playlist_VC setTitle:@"關於"];
            break;
        default:
            break;
    }
    

	
	tabBarCon_audioTag = [[UITabBarController alloc] init];
	
	navCon_Sandbox = [[UINavigationController alloc] init];
	navCon_Tag = [[UINavigationController alloc] init];
	navCon_Favorite = [[UINavigationController alloc] init];
	navCon_Playlist = [[UINavigationController alloc] init];
	
    viewCon_Playing = [[Playing_ViewController alloc] init];
    //viewCon_Edit = [[Edit_ViewController alloc] init];
    //viewCon_Edit = [[Edit_ViewController alloc] initWithNibName:@"Edit_ViewController" bundle:[NSBundle mainBundle]];
    viewCon_Edit_BG = [[Edit_BG_ViewController alloc] init];
    viewCon_Favorite = favorite_VC;
    viewCon_Tag = tag_VC;
    
	[self.navCon_Sandbox pushViewController:sandbox_VC animated:NO];
	[self.navCon_Tag pushViewController:tag_VC animated:NO];
	[self.navCon_Favorite pushViewController:favorite_VC animated:NO];
	[self.navCon_Playlist pushViewController:playlist_VC animated:NO];
	
	self.tabBarCon_audioTag.viewControllers = 
		[NSArray arrayWithObjects:navCon_Sandbox, navCon_Tag, navCon_Favorite, navCon_Playlist, nil];
    
    UIImage *imgSandbox = [UIImage imageNamed:@"194-note-2.png"];
    UIImage *imgTag = [UIImage imageNamed:@"15-tags.png"];
    UIImage *imgFavorite = [UIImage imageNamed:@"29-heart.png"];	
    UIImage *imgAbout = [UIImage imageNamed:@"59-info.png"];
    
    UITabBarItem *item_sandbox = (UITabBarItem *)[tabBarCon_audioTag.tabBar.items objectAtIndex:0];
    UITabBarItem *item_tag = (UITabBarItem *)[tabBarCon_audioTag.tabBar.items objectAtIndex:1];
    UITabBarItem *item_favorite = (UITabBarItem *)[tabBarCon_audioTag.tabBar.items objectAtIndex:2];
    UITabBarItem *item_about = (UITabBarItem *)[tabBarCon_audioTag.tabBar.items objectAtIndex:3];
    
    [item_sandbox setImage:imgSandbox];
    [item_tag setImage:imgTag];
    [item_favorite setImage:imgFavorite];
    [item_about setImage:imgAbout];
    
    
    // 這裏要新增Check AudioTag.sqlit資料庫是否存在？如果不存在，就產生一個新的。
    // 有兩種情況會不存在。
    // 1. 新安裝AudioTag App
    // 2. 不小心從iTunes誤刪
    [self createNewSqliteDB:nil];
    //
    
    
    
    // Add the tab bar controller's view to the window and display.
    [window addSubview:tabBarCon_audioTag.view];
    [window makeKeyAndVisible];
	
    return YES;
}

- (void)createNewSqliteDB:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *existedDBFile = [documentsPath stringByAppendingPathComponent:@"AudioTag.sqlite"];
    BOOL isDBFileExist = [[NSFileManager defaultManager] fileExistsAtPath:existedDBFile];
    
    NSString *aMsg = [NSString stringWithFormat:@"%d", isDBFileExist];
    [appDelegate.utility MsgLog:self.class withFuncName:@"createNewSqliteDB" withMsg:aMsg];
    
    
    if (isDBFileExist == NO){   // 表示AudtioTag.sqlite資料庫檔不存在，所以需要重新產生一個新的
        [appDelegate.dataFromSqlite saveInitialDataToDB];
    }
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


// 印出Unhandled Exception Debug資訊
void uncaughtExceptionHandler(NSException *exception) {
    // Internal error reporting    
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}
//

- (void)saveContext {
    NSLog(@"saveContext");
	
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    


#pragma mark -
#pragma mark Core Data stack


/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AudioTag" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AudioTag.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}




@end

