//
//  Utility.h
//  AudioTag
//
//  Created by Chang Wayne on 12/3/7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject {
    
}
/**
 * @brief 在XCode Console畫面顯示所給的NSString Array內容
 * @details None
 * @date 2012-03-07
 * @version v1.0
 * @author Wayne Chang
 * @param 欲顯示的NSString Array
 * @return None
 */
- (void)showNSStringArrayInConsole:(NSArray *)aArray;

/**
 * @brief 比較目前Sandbox Documents目錄下的mp3檔案列表Array與傳入Array
 * @details 以傳入的aArray進行與Document目錄下的檔案列表listData Array進行比較。如果aArray某個檔名物件存在而listData不存在，那就在回傳的aryDifference Array掛上Index + 1的負值。(代表Document目錄檔案有刪除)(Index + 1是為了判斷0，因為0乘-1或+1還是0) 反過來，如果listData某個檔名物件存在而aArray不存在，那就在回傳的aryDifference Array掛上Index + 1的正值。(代表Document目錄檔案有新增)
 * @date 2012-03-07
 * @version V1.0
 * @author Wayne Chang
 * @param 欲比較的NSString Array
 * @return 比較結果。如果Documents目錄下的mp3檔案列表有某個a.mp3，而傳入Array沒有。就會回傳正號的數值，數值代表傳入Array的物件index + 1。相反的如果Documents目錄下的mp3檔案列表裏沒有某個b.mp3檔，而傳入的Array有，那就會回傳負值，數值代表傳入Array的物件index + 1。
 */
- (NSMutableArray *)checkDifferenceBetweenDocDirToArray:(NSArray *)aArray;


/**
 * @brief 將傳入的字串MutableArray進行排序後傳回(排序方式以字串Ascii code由小到大排列)
 * @details 將傳入的字串MutableArray進行排序後傳回(排序方式以字串Ascii code由小到大排列)
 * @date 2012-03-16
 * @version v1.0
 * @author Wayne Chang
 * @return 排序後的字串Array
 */
- (NSArray *)sortMArrayInStringOrder:(NSArray *)aryBeforeSorted;

/**
 * @brief 將傳入的時間格式(xx:xx)字串轉成NSTimeInterval
 * @details 將傳入的時間格式(xx:xx)字串轉成NSTimeInterval
 * @date 2013-06-12
 * @version v1.0
 * @author Wayne Chang
 * @return 轉換後的NSTimeInterval
 */
- (NSTimeInterval)timeIntervalWithFormatString:(NSString *)aFormatString;


/**
 * @brief 將傳入的時間格式(xx:xx)字串中Minute的部分轉成NSInteger
 * @details 將傳入的時間格式(xx:xx)字串中Minute的部分轉成NSInteger
 * @date 2013-06-12
 * @version v1.0
 * @author Wayne Chang
 * @return Minute部分的NSInteger
 */
- (NSInteger)MinuteTimePartWithFormatString:(NSString *)aFormatString;

/**
 * @brief 將傳入的時間格式(xx:xx)字串中Second的部分轉成NSInteger
 * @details 將傳入的時間格式(xx:xx)字串中Second的部分轉成NSInteger
 * @date 2013-06-12
 * @version v1.0
 * @author Wayne Chang
 * @return Second部分的NSInteger
 */

- (NSInteger)SecondTimePartWithFormatString:(NSString *)aFormatString;

/**
 * @brief 將傳入的字串Array以及某字串，回傳該字串在Array裏的Index
 * @details 將傳入的字串Array以及某字串，回傳該字串在Array裏的Index
 * @date 2012-07-25
 * @version v1.0
 * @author Wayne Chang
 * @return 字串於Array中的Index
 */
- (NSInteger)querryIndexOfArrayByString:(NSArray *)aArray givingString:(NSString *)aString;

- (void)ErrLog:(Class)aClass withFuncName:(NSString *)aFuncName withMsg:(NSString *)aMsg; 
- (void)MsgLog:(Class)aClass withFuncName:(NSString *)aFuncName withMsg:(NSString *)aMsg; 

@end
