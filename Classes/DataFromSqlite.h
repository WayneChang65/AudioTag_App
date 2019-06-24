//
//  DataFromSqlite.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/8/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "preferences.h"
#import "mp3.h"
#import "tag.h"
#import "playlist.h"

@interface DataFromSqlite : NSObject {
	
}

- (void)saveInitialDataToDB_Test;
- (void)saveInitialDataToDB;
- (void)showDataInConsoleFromMemory;
- (void)showEntryMp3InConsoleFromMemory;
- (void)showNSStringArrayInConsole:(NSArray *)aArray;
- (void)loadDataFromDBToMemory;
- (void)saveSandboxMp3sToDB:(NSMutableArray *)sandboxMp3s;
- (void)deleteAllObjects:(NSString *)entityDescription;
- (void)deleteAllObjectsForAllEntitiesFromDB;
- (BOOL)rebulidMp3LinkForTags;
- (NSInteger)querryIndexOfObjectOfArray_Mp3_EntityByString:(NSString *)aString;
- (NSInteger)querryIndexOfObjectOfArray_Tag_EntityByString:(NSString *)aString;


@property (nonatomic, strong) preferences *_preferences;
@property (nonatomic, strong) playlist *_temp_playlist;
@property (nonatomic, strong) playlist *_favorite_playlist;
@property (nonatomic, strong) NSArray *_mp3;
@property (nonatomic, strong) NSArray *_tag;
@end

