//
//  DataFromSqlite.m
//  AudioTag
//
//  Created by Chang Wayne on 2011/8/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataFromSqlite.h"
#import "preferences.h"
#import "AudioTagAppDelegate.h"

@implementation DataFromSqlite

@synthesize _preferences;
@synthesize _temp_playlist;
@synthesize _favorite_playlist;
@synthesize _mp3;
@synthesize _tag;

// 程式剛被安裝時，Sqlite資料庫是空的，必需做適當的初始化把一些初始資料存入Sqlite裏面
// 呼叫這個函式，必需把原本的AudioTag.sqlite刪掉(因為會呼叫這個程式，通常有可能資料庫架構變了，像是多了一個entity或是多了attribute)，否則函式會當掉。
- (void)saveInitialDataToDB_Test
{
	NSLog(@"DataFromSqlite--saveInitialDataToDB_Test");
	
	AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];

	[self deleteAllObjectsForAllEntitiesFromDB];   // 在存入初始資料到DB裏的時候，先清除DB裏所有資料
    
    // ===============================================================
	NSLog(@"DataFromSqlite--saveInitialDataToDB_Test--system_preference");
	preferences *system_preference = (preferences *) [NSEntityDescription insertNewObjectForEntityForName:@"preferences" 
																				   inManagedObjectContext:appDelegate.managedObjectContext];    
	system_preference.last_opened_mp3 = @"One day.mp3";
	system_preference.last_opened_tag = @"my1stTag.atag";
	system_preference.last_opened_playlist = @"temp_playlist";
	system_preference.volume = @"0.5";
    system_preference.single_or_loop = @"0";
    system_preference.elements_order_of_playlist = @"";
    system_preference.language = strEnglish_lang;
    
    // ===============================================================
	NSLog(@"DataFromSqlite--saveInitialDataToDB_Test--temp_playlist");
    playlist *temp_playlist = (playlist *) [NSEntityDescription insertNewObjectForEntityForName:@"playlist" 
                                                                         inManagedObjectContext:appDelegate.managedObjectContext];
    temp_playlist.name = @"temp_playlist";
    
    playlist *favorite_playlist = (playlist *) [NSEntityDescription insertNewObjectForEntityForName:@"playlist" 
                                                                         inManagedObjectContext:appDelegate.managedObjectContext];
    favorite_playlist.name = @"favorite_playlist";

    // ===============================================================
    /*
    NSLog(@"DataFromSqlite--saveInitialDataToDB_Test--my1stTag");
    tag *my1stTag = (tag *) [NSEntityDescription insertNewObjectForEntityForName:@"tag" 
                                                                         inManagedObjectContext:appDelegate.managedObjectContext];
    my1stTag.name = @"my1stTag";
    my1stTag.commet = @"None";
    my1stTag.a_time = [NSString stringWithFormat:@"%f",(double)109.285601];
    my1stTag.b_time = [NSString stringWithFormat:@"%f",(double)143.687370];
    my1stTag.linked_mp3 = nil;
     */
    
    // MP3的部分不用再這裏處理，因為進入Sandbox_ViewController就會依目錄有的檔案，通通加進DB的MP3 entity裏
    
	[appDelegate saveContext];
    
//    NSSet *ttt = [NSSet setWithObjects:@"t", @"a", @"1", nil];
//    NSLog(@"%@", ttt);
}

- (void)saveInitialDataToDB
{
	NSLog(@"DataFromSqlite--saveInitialDataToDB");
	
	AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	[self deleteAllObjectsForAllEntitiesFromDB];   // 在存入初始資料到DB裏的時候，先清除DB裏所有資料
    
    // ===============================================================
	NSLog(@"DataFromSqlite--saveInitialDataToDB--system_preference");
	preferences *system_preference = (preferences *) [NSEntityDescription insertNewObjectForEntityForName:@"preferences" 
																				   inManagedObjectContext:appDelegate.managedObjectContext];    
	system_preference.last_opened_mp3 = @"";
	system_preference.last_opened_tag = @"";
	system_preference.last_opened_playlist = @"temp_playlist";
	system_preference.volume = @"0.5";
    system_preference.single_or_loop = @"0";
    system_preference.elements_order_of_playlist = @"";
    system_preference.language = strEnglish_lang;
    
    // ===============================================================
	NSLog(@"DataFromSqlite--saveInitialDataToDB--temp_playlist");
    playlist *temp_playlist = (playlist *) [NSEntityDescription insertNewObjectForEntityForName:@"playlist" 
                                                                         inManagedObjectContext:appDelegate.managedObjectContext];
    temp_playlist.name = @"temp_playlist";
    
    playlist *favorite_playlist = (playlist *) [NSEntityDescription insertNewObjectForEntityForName:@"playlist" 
                                                                             inManagedObjectContext:appDelegate.managedObjectContext];
    favorite_playlist.name = @"favorite_playlist";
        
	[appDelegate saveContext];
    
}


// 在console下顯示Sqlite資料庫裏的情況
- (void)showDataInConsoleFromMemory
{  
    NSLog(@"DataFromSqlite--showDataInConsoleFromMemory");

    NSLog(@"preference.elements_order_of_playlist = %@", self._preferences.elements_order_of_playlist);
    NSLog(@"preference.language = %@", self._preferences.language);
	NSLog(@"preference.last_opened_mp3 = %@", self._preferences.last_opened_mp3);
	NSLog(@"preference.last_opened_tag = %@", self._preferences.last_opened_tag);
	NSLog(@"preference.last_opened_playlist = %@", self._preferences.last_opened_playlist);
	NSLog(@"preference.last_opened_volume = %@", self._preferences.volume);
    NSLog(@"preference.single_or_loop = %@", self._preferences.single_or_loop);
	NSLog(@"--");
    NSLog(@"temp_playlist.name = %@", self._temp_playlist.name);
    //NSLog(@"temp_playlist.owned_mp3s = ");
    //NSLog(@"%@", self._temp_playlist.owned_mp3s);
    NSLog(@"--");

}

- (void)showEntryMp3InConsoleFromMemory
{
    for (int i = 0; i < [self._mp3 count]; i++){
        mp3 *aMp3 = (mp3 *)[self._mp3 objectAtIndex:i];
        NSLog(@"self._mp3[%d]=%@", i, aMp3.name);
    }
}

- (void)showNSStringArrayInConsole:(NSArray *)aArray
{
    if ([aArray isKindOfClass:[NSString class]]){
        for (int i = 0; i < [aArray count]; i++){
            NSString *aString = [aArray objectAtIndex:i];
            NSLog(@"self._mp3[%d]=%@", i, aString);
        }
    }
}

// 初始化時，將Sqlite的資料載入DataFromSqlite的成員中
- (void)loadDataFromDBToMemory
{
	NSLog(@"DataFromSqlite---loadDataFromDBToMemory");
	
	AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
	
    // For preferences
    NSEntityDescription *entityDes_preference = [NSEntityDescription entityForName:@"preferences" 
														 inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchReq setEntity:entityDes_preference];
	NSArray *preference_data = [appDelegate.managedObjectContext executeFetchRequest:fetchReq error:nil];
	self._preferences = (preferences *)[preference_data lastObject];
    
	
    // For playlist
    NSEntityDescription *entityDes_playlist = [NSEntityDescription entityForName:@"playlist" 
                                                            inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchReq setEntity:entityDes_playlist];
    NSArray *playlist_data = [appDelegate.managedObjectContext executeFetchRequest:fetchReq error:nil];
    
    for (playlist *aPlaylist in playlist_data){
        if ([aPlaylist.name isEqualToString:@"favorite_playlist"]){
            self._favorite_playlist = aPlaylist;
        }else if([aPlaylist.name isEqualToString:@"temp_playlist"]){
            self._temp_playlist = aPlaylist;
        }else{
            // ... 其他的playlist
            NSLog(@"Unknow playlist!");
        }
    }
    //self._temp_playlist = (playlist *)[temp_playlist_data lastObject];
    /*
    if ([playlist_data count] == 2) {
        self._favorite_playlist = (playlist *)[playlist_data objectAtIndex:([playlist_data count] - 1)];
        self._temp_playlist = (playlist *)[playlist_data objectAtIndex:([playlist_data count] - 2)];
    }
     */
    
    // For mp3
    NSEntityDescription *entityDes_mp3 = [NSEntityDescription entityForName:@"mp3" 
                                                               inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchReq setEntity:entityDes_mp3];
    NSArray *mp3_data = [appDelegate.managedObjectContext executeFetchRequest:fetchReq error:nil];
    self._mp3 = mp3_data;
    //self._mp3 = [NSArray arrayWithArray:mp3_data];
    
    // For tag
    NSEntityDescription *entityDes_tag = [NSEntityDescription entityForName:@"tag" 
                                                     inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchReq setEntity:entityDes_tag];
    NSArray *tag_data = [appDelegate.managedObjectContext executeFetchRequest:fetchReq error:nil];
    self._tag = tag_data;
    //self._tag = [NSArray arrayWithArray:tag_data];
    
    
    //NSLog(@"self._temp_playlist.name = %@, self._favorite_playlist.name = %@", self._temp_playlist.name, self._favorite_playlist.name);
    
    // ============
    // 印出資料庫裏的一些東西
    /*
    playlist *tttPlaylist;
    for (int i = 0; i < [tag_data count]; i++) {
        tttPlaylist = [tag_data objectAtIndex:i];
        NSLog(@"%@", tttPlaylist.name);
    }
//    tttPlaylist = [mp3_data lastObject];
//    NSLog(@"lastObject = %@", tttPlaylist.name);
    */
    // ============
    
}

- (void)saveSandboxMp3sToDB:(NSMutableArray *)sandboxMp3s
{
	NSLog(@"DataFromSqlite--saveSandboxMp3sToDB");
//	[self deleteAllObjects:@"mp3"]; // 刪除所有目前存在DB裏mp3 entity的資料
	AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];

    //====================================================================
    // 實體儲存的mp3檔案(disk-mp3)與sqlite裏的mp3 Entity(sqlite-mp3)同步機制
    //====================================================================
    BOOL isNeedToAddMp3ItemToEntity = YES;
    BOOL isNeedToDelMp3ItemToEntity = NO;
    BOOL isNeedToSaveContext = NO;
    
//  [self showNSStringArrayInConsole:sandboxMp3s];
//  [self showEntryMp3InConsoleFromMemory]; // show Entry Mp3的所有東西
    // sortMArrayInStringOrder函式有用，但是再指定回給self_mp3，針對整個context是沒用的。所以，看來Mp3 Entity只能是亂的了。
//  self._mp3 = [[self sortMArrayInStringOrder:self._mp3] mutableCopy]; 
//  isNeedToSaveContext = YES; // 一定會存Context，因為經過排序就有變動。不管後面是否有針對Mp3 Entity有增減，還是都得存。  
//  [self showEntryMp3InConsoleFromMemory]; // show Entry Mp3的所有東西
    
    for (int i = 0; i < [sandboxMp3s count]; i++) {
        // 將sandboxMp3s的每個物件，跟self._mp3比較。如果sandboxMp3s裏有某物件，而self._mp3沒有的話，就把該物件加入self._mp3裏。
        NSString *aSandboxMp3 = [sandboxMp3s objectAtIndex:i];
        for (int j = 0; j < [self._mp3 count]; j++){
            mp3 *aOldSandboxMp3_mp3 = (mp3 *)[self._mp3 objectAtIndex:j];
            if ([aSandboxMp3 isEqualToString:aOldSandboxMp3_mp3.name]){
                // 只要找到self._mp3有任何一個name跟aSandboxMp3_mp3一樣就break，不需要再往下check了。
                isNeedToAddMp3ItemToEntity = NO;
                break;
            }else{
                 isNeedToAddMp3ItemToEntity = YES;
            }
        }
        if (isNeedToAddMp3ItemToEntity){
            isNeedToSaveContext = YES;
            mp3 *aSandboxMp3_mp3 = (mp3 *) [NSEntityDescription insertNewObjectForEntityForName:@"mp3" 
																				   inManagedObjectContext:appDelegate.managedObjectContext];
            aSandboxMp3_mp3.name = aSandboxMp3;
            NSLog(@"InsertObject-%d--%@", i, aSandboxMp3_mp3.name);
        }
    }
 
    if ([sandboxMp3s count] == [self._mp3 count]){
        NSLog(@"[sandboxMp3s count] == [self._mp3 count]");
    }else{
        // 代表實體磁碟裏面的檔案有被刪掉
        NSLog(@"[sandboxMp3s count] != [self._mp3 count]");
        // 將self._mp3的每個物件，跟sandboxMp3s比較。如果self._mp3裏有某物件，而sandboxMp3s沒有的話，就把該物件從self._mp3裏刪除。
        for (int ii = 0; ii < [self._mp3 count]; ii++){
            mp3 *aOldSandboxMp3_mp3 = (mp3 *)[self._mp3 objectAtIndex:ii];
            for (int jj = 0; jj < [sandboxMp3s count]; jj++){
                NSString *aSandboxMp3 = [sandboxMp3s objectAtIndex:jj];
                if ([aOldSandboxMp3_mp3.name isEqualToString:aSandboxMp3]){
                    isNeedToDelMp3ItemToEntity = NO;
                    break;
                }else{
                    isNeedToDelMp3ItemToEntity = YES;
                }
            }
            if (isNeedToDelMp3ItemToEntity){
                // 刪除DB裏這個Mp3 Item
                // 沒想到刪除Item這麼簡單，只要一行程式。
                NSLog(@"deleteObject-%d--%@", ii, aOldSandboxMp3_mp3.name);
                [appDelegate.managedObjectContext deleteObject:aOldSandboxMp3_mp3];
                isNeedToSaveContext = YES;
            }
        }
    }
    
    
    // 不需要那麼麻煩用下面的方式更新self._mp3。只要用self.loadDataFromDBToMemory一次全更就行了。
    // 效率差不到哪裏，但很方便。
    // 有新增Item再來存就可以了，沒新增不用存
    // if (isNeedToSaveContext){
        // 更新self._mp3。(因為managedObjectContext改變，有新增物件。所以必需重新更新self._mp3)
    [self loadDataFromDBToMemory];
    // }
    //
    
    /*    
     // 有新增Item再來存就可以了，沒新增不用存
     if (isNeedToSaveContext){
     // 更新self._mp3。(因為managedObjectContext改變，有新增物件。所以必需重新更新self._mp3)
     NSFetchRequest *fetchReq = [[NSFetchRequest alloc] init];
     NSEntityDescription *entityDes_mp3 = [NSEntityDescription entityForName:@"mp3" 
     inManagedObjectContext:appDelegate.managedObjectContext];
     [fetchReq setEntity:entityDes_mp3];
     NSArray *mp3_data = [appDelegate.managedObjectContext executeFetchRequest:fetchReq error:nil];
     self._mp3 = [NSMutableArray arrayWithArray:mp3_data];
     }
     //
     */      
    
    // 有刪除Item或Tags被重建過再來存就可以了，沒變化就不用存。這樣才有效率
    //if (isNeedToSaveContext){ 
    //    [appDelegate saveContext];
    //    isNeedToSaveContext = NO;
    //}
    //
    
    //====================================================================
    // sqlite-tags連結重建機制 (進行sqlite-tags裏所有tag的mp3連結檢查，並重建)
    //====================================================================
    // 若Tags有被重建連結過，就必需儲存Context
    if ([self rebulidMp3LinkForTags]) isNeedToSaveContext = YES;
    //
    
    // 有刪除Item或Tags被重建過再來存就可以了，沒變化就不用存。這樣才有效率
    if (isNeedToSaveContext){
        [self loadDataFromDBToMemory];
        [appDelegate saveContext];
    }
    //
}

- (void) deleteAllObjects: (NSString *)entityDescription  
{
    NSLog(@"deleteAllObjects--%@", entityDescription);
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [appDelegate.managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![appDelegate.managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

- (void)deleteAllObjectsForAllEntitiesFromDB
{
    [self deleteAllObjects:@"mp3"];
    [self deleteAllObjects:@"playlist"];
    [self deleteAllObjects:@"tag"];
    [self deleteAllObjects:@"preferences"];
}

- (BOOL)rebulidMp3LinkForTags
{
    NSLog(@"[%@]Total Tag Number:%d", self.class, [self._tag count]);
    BOOL isAbleToRebuildMp3LinkForATag = NO;
    BOOL isNeedToSaveContext = NO;
    tag *aTag = nil;
    if (self._tag == nil || [self._tag count] == 0){
        NSLog(@"[%@]self._tag == nil || [self._tag count] == 0", self.class);
        return isNeedToSaveContext;
    }
    for (int i = 0; i < [self._tag count]; i++){
        aTag = [self._tag objectAtIndex:i];
        if (aTag.linked_mp3 == nil){
            NSLog(@"Tag-(%@).linked_mp3 = nil", aTag.name);
            //
            for (int j = 0; j < [self._mp3 count]; j++){
                mp3 *aMp3 = [self._mp3 objectAtIndex:j];
                NSString *aMp3OnDisk = aMp3.name;
                if ([aTag.linked_mp3filename isEqualToString:aMp3OnDisk]){
                    // 在實際磁碟中，找到遺失linked_mp3這個tag的同檔名mp3檔案(就可以進行連結重建了)
                    //NSLog(@"Tag-(%@).linked_mp3filename(%@) is EXIST on Disk!!!", aTag.name, aTag.linked_mp3filename);
                    NSLog(@"Rebuild Tag(%@) -- Mp3(%@).", aTag.name, aTag.linked_mp3filename);
                    isAbleToRebuildMp3LinkForATag = YES;
                    aTag.linked_mp3 = aMp3;
                    isNeedToSaveContext = YES;
                    break; // 找到後，就不用再找了
                }else{
                    isAbleToRebuildMp3LinkForATag = NO;
                }
            }
            //
            if (isAbleToRebuildMp3LinkForATag == NO){
                // 在實際磁碟中，找不到遺失linked_mp3這個tag的同檔名mp3檔案(就沒辨法，重建連結了)
                NSLog(@"Tag-(%@).linked_mp3filename(%@) is NOT EXIST on Disk!!!", aTag.name, aTag.linked_mp3filename);
            }
        }
    }
    return isNeedToSaveContext;
}

- (NSInteger)querryIndexOfObjectOfArray_Mp3_EntityByString:(NSString *)aString
{
    for (int i = 0; i < [self._mp3 count]; i++){
        mp3 *aMp3 = [self._mp3 objectAtIndex:i]; 
        if ([aString isEqualToString:aMp3.name]) return i;
    }
    return -1;
}

- (NSInteger)querryIndexOfObjectOfArray_Tag_EntityByString:(NSString *)aString
{
    for (int i = 0; i < [self._tag count]; i++){
        tag *aTag = [self._tag objectAtIndex:i]; 
        if ([aString isEqualToString:aTag.name]) return i;
    }
    return -1;
}

- (void)dealloc {
	NSLog(@"DataFromSqlite---dealloc");

	
}
@end
