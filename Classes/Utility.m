//
//  Utility.m
//  AudioTag
//
//  Created by Chang Wayne on 12/3/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"

@implementation Utility

- (void)showNSStringArrayInConsole:(NSArray *)aArray
{
    for (int i = 0; i < [aArray count]; i++){
        NSString *aString = [aArray objectAtIndex:i];
        NSLog(@"%p[%d]=%@",aArray, i, aString);
    }
}

- (NSMutableArray *)checkDifferenceBetweenDocDirToArray:(NSArray *)aArray
{
    NSMutableArray *aryDifference = [[NSMutableArray alloc] init];
    
    // 取得應用程式沙箱目錄裏的檔案列表
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@""];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];	
    //NSArray *filterTypes = [NSArray arrayWithObject:@"mp3"];
    NSArray *filterTypes = [NSArray arrayWithObjects:@"mp3", @"MP3", @"Mp3", @"mP3", nil];
	NSArray *filteredFiles = [directoryContent pathsMatchingExtensions:filterTypes];
    NSArray *listData = filteredFiles;
    //
    NSString *strDocDirFilename;
    NSString *strArray;
    
    //
    //NSLog(@"===listData===");
    //[self showNSStringArrayInConsole:listData];
    //NSLog(@"===aArray===");
    //[self showNSStringArrayInConsole:aArray];
    //
    
    // 以aArray為主的比較，找出aArray有的，而listData沒有。(代表Document目錄檔案有被刪除)
    BOOL isTheSame = NO;
    for (int i = 0; i < [aArray count]; i++){
        strArray = [aArray objectAtIndex:i];       
        for (int j = 0; j < [listData count]; j++){
            strDocDirFilename = [listData objectAtIndex:j];
            if ([strArray isEqualToString:strDocDirFilename]){
                // 在i位置字串是一樣的
                isTheSame = YES;
                break;
            }else{
                isTheSame = NO;
            }
        }
        if (isTheSame == NO){
            [aryDifference addObject:[NSNumber numberWithInteger:(-1 * (i + 1))]];
        }
    }
    
    // 以listData為主的比較，找出listData有的，而aArray沒有。(代表Document目錄檔案有被新增)
    isTheSame = NO;
    for (int i = 0; i < [listData count]; i++){
        strDocDirFilename = [listData objectAtIndex:i];       
        for (int j = 0; j < [aArray count]; j++){
            strArray = [aArray objectAtIndex:j];
            if ([strDocDirFilename isEqualToString:strArray]){
                // 在i位置字串是一樣的
                isTheSame = YES;
                break;
            }else{
                isTheSame = NO;
            }
        }
        if (isTheSame == NO){
            [aryDifference addObject:[NSNumber numberWithInteger:(1 * (i + 1))]];
        }
    }

    return aryDifference;
}

- (NSArray *)sortMArrayInStringOrder:(NSArray *)aryBeforeSorted
{
    NSArray *sortedArray;
    sortedArray = [aryBeforeSorted sortedArrayUsingComparator:^(id a, id b) {
        if ([a isKindOfClass:[NSString class]] && [b isKindOfClass:[NSString class]]){
            NSString *first = a;
            NSString *second = b;
            return ([first compare:second] == NSOrderedDescending);
        }else{
            //return NO;
            return 0;
        }
    }];
    return sortedArray;
}

- (NSTimeInterval)timeIntervalWithFormatString:(NSString *)aFormatString
{
    //aFormatString = [NSString stringWithString:@"11:23"];
    NSString *semicolum = @":";
    NSRange rangeOfSemicolum = [aFormatString rangeOfString:semicolum];
    //NSString *msg_rangeLocation = [NSString stringWithFormat:@"%d", rangeOfSemicolum.location];
    NSString *msg_min = [aFormatString substringToIndex:rangeOfSemicolum.location];
    NSString *msg_sec = [aFormatString substringFromIndex:(rangeOfSemicolum.location + 1)];
    
    //[self MsgLog:self.class withFuncName:@"timeIntervalWithFormatString" withMsg:aFormatString];
    //[self MsgLog:self.class withFuncName:@"timeIntervalWithFormatString" withMsg:msg_rangeLocation];
    //[self MsgLog:self.class withFuncName:@"timeIntervalWithFormatString" withMsg:msg_min];
    //[self MsgLog:self.class withFuncName:@"timeIntervalWithFormatString" withMsg:msg_sec];
    NSTimeInterval retVal = msg_min.doubleValue * 60 + msg_sec.doubleValue;
    return retVal;
}

- (NSInteger)MinuteTimePartWithFormatString:(NSString *)aFormatString
{
    NSString *semicolum = @":";
    NSRange rangeOfSemicolum = [aFormatString rangeOfString:semicolum];

    NSString *msg_min = [aFormatString substringToIndex:rangeOfSemicolum.location];
    
    NSInteger retVal = msg_min.intValue;
    
    return retVal;
}

- (NSInteger)SecondTimePartWithFormatString:(NSString *)aFormatString
{
    NSString *semicolum = @":";
    NSRange rangeOfSemicolum = [aFormatString rangeOfString:semicolum];
    
    NSString *msg_sec = [aFormatString substringFromIndex:(rangeOfSemicolum.location + 1)];
    
    NSInteger retVal = msg_sec.intValue;
    
    return retVal;
}


- (NSInteger)querryIndexOfArrayByString:(NSArray *)aArray givingString:(NSString *)aString
{
    for (int i = 0; i < [aArray count]; i++){
        NSString *aStringObj = [aArray objectAtIndex:i]; 
        if ([aString isEqualToString:aStringObj]) return i;
    }
    return 0;
}


- (void)ErrLog:(Class)aClass withFuncName:(NSString *)aFuncName withMsg:(NSString *)aMsg
{
    NSLog(@"[ERROR][%@:%@]---%@", aClass, (NSString*)aFuncName, (NSString*)aMsg);
}

- (void)MsgLog:(Class)aClass withFuncName:(NSString *)aFuncName withMsg:(NSString *)aMsg
{
    NSLog(@"[ MSG ][%@:%@]---%@", aClass, (NSString*)aFuncName, (NSString*)aMsg);
}
@end
