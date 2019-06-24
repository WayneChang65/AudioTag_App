//
//  AudioTagAppDelegate.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/8/9.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataFromSqlite.h"
#import "AVPlayerExtension.h"
#import <AVFoundation/AVFoundation.h>
#import "Playing_ViewController.h"
#import "Edit_ViewController.h"
#import "Edit_BG_ViewController.h"
#import "Favorite_ViewController.h"
#import "Tag_ViewController.h"
#import "Utility.h"

#import "AppDefineWords.h"
 
@interface AudioTagAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    UIWindow *window;
	
    NSNumber *isPlay1stTimeFromStartApp;
    NSNumber *numLanguage;
    
    NSNumber *aTimeOfLastOpenedTag;
    NSNumber *bTimeOfLastOpenedTag;
    NSString *commentOfLastOpenedTag;
    NSNumber *isTagSaved;
    NSNumber *isNeedToResetABKey;
    NSNumber *isTheSameNameTag_Update;
    
//    NSNumber *numPlayType;
    
    NSNumber *isNeedToUpdateViewWillAppear;
    
    NSArray *aryAllMP3FilesInSandbox;
    
    NSMutableString *mstrPlayingMP3Filename;
    NSString *strPlayingTagName;
    
	AVAudioPlayer *avapPlayer;
    NSTimer *tmrUpdatePlaying_ViewController;
    
	DataFromSqlite *dataFromSqlite;
    Utility *utility;
//	playlist *pllstTemp;
//  playlist *pllstFavorite;
    
	UITabBarController *tabBarCon_audioTag;
	UINavigationController *navCon_Sandbox;
	UINavigationController *navCon_Tag;
	UINavigationController *navCon_Favorite;
	UINavigationController *navCon_Playlist;
    
    Playing_ViewController *viewCon_Playing;
    Edit_ViewController *viewCon_Edit;
    Edit_BG_ViewController *viewCon_Edit_BG;
    
    Favorite_ViewController *viewCon_Favorite;
    Tag_ViewController *viewCon_Tag;
   
@private
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) NSNumber *isPlay1stTimeFromStartApp;
@property (nonatomic, strong) NSNumber *numLanguage;
@property (nonatomic, strong) NSNumber *aTimeOfLastOpenedTag;
@property (nonatomic, strong) NSNumber *bTimeOfLastOpenedTag;
@property (nonatomic, strong) NSString *commentOfLastOpenedTag;
@property (nonatomic, strong) NSNumber *isTagSaved;
@property (nonatomic, strong) NSNumber *isNeedToResetABKey;
@property (nonatomic, strong) NSNumber *isTheSameNameTag_Update;
//@property (nonatomic, strong) NSNumber *numPlayType;
@property (nonatomic, strong) NSArray *aryAllMP3FilesInSandbox;
@property (nonatomic, strong) NSMutableString *mstrPlayingMP3Filename;
@property (nonatomic, strong) NSString *strPlayingTagName;
@property (nonatomic, strong) AVAudioPlayer *avapPlayer;
@property (nonatomic, strong) NSTimer *tmrUpdatePlaying_ViewController;
@property (nonatomic, strong) DataFromSqlite *dataFromSqlite;
@property (nonatomic, strong) Utility *utility;
@property (nonatomic, strong) AVPlayerExtension *avPlayerExtension;
//@property (nonatomic, retain) playlist *pllstTemp;
//@property (nonatomic, retain) playlist *pllstFavorite;
@property (nonatomic, strong) UITabBarController *tabBarCon_audioTag;
@property (nonatomic, strong) UINavigationController *navCon_Sandbox;
@property (nonatomic, strong) UINavigationController *navCon_Tag;
@property (nonatomic, strong) UINavigationController *navCon_Favorite;
@property (nonatomic, strong) UINavigationController *navCon_Playlist;

@property (nonatomic, strong) Playing_ViewController *viewCon_Playing;
@property (nonatomic, strong) Edit_ViewController *viewCon_Edit;
@property (nonatomic, strong) Edit_BG_ViewController *viewCon_Edit_BG;
@property (nonatomic, strong) Favorite_ViewController *viewCon_Favorite;
@property (nonatomic, strong) Tag_ViewController *viewCon_Tag;

@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end

