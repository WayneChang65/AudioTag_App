//
//  AVPlayerExtension.m
//  AudioTag
//
//  Created by Chang Wayne on 11/12/19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "AVPlayerExtension.h"

@implementation AVPlayerExtension


- (NSTimeInterval)getDurationFromMp3Filename:(NSString *)filename_mp3
{
    NSError *error;
	NSString *path_without_filename, *path_with_filename;
	NSArray *paths;
	NSURL *url;

	AVAudioPlayer *avapPlayer; 
	
    // 找出filename_mp3對應的URL
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path_without_filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@""];
	path_with_filename = [path_without_filename stringByAppendingPathComponent:filename_mp3];
	url = [NSURL URLWithString:[path_with_filename stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
	avapPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	avapPlayer.delegate = nil;
	
    // MP3開檔錯誤判斷
    // 當實體的Documents目錄裏，找不到傳入的filename_mp3檔名對應的檔案，就會出現以下錯誤。
	if (error){
        NSLog(@"Error: %@ is NOT exist in the Documents dircetory.", filename_mp3);
		//NSLog(@"Error: %@", [error localizedDescription]);
        // 當使用者還開著AudioTag程式時，手動透過iTunes把一些mp3檔案刪掉。這時候，如果還沒切換畫面進行ViewWillAppear把listData更新，UITableView就會認為listData裏有東西，就會透過這個函式取得撥放時間，而實際上找不到該檔，就會進到這裏來。
        // 進到這裏其實也沒差，反正檔案刪掉了，就把時間傳0也沒差。把下面的Code Mark掉，就是不希望一直跑Alert視窗出來警告。
        /*
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MP3檔案錯誤" 
														message:@"MP3檔案格式發生錯誤！" 
													   delegate:nil 
											  cancelButtonTitle:@"確認" 
											  otherButtonTitles:nil];
		[alert show];
        */
        return 0;
	}else{
        return avapPlayer.duration;
	}

}
@end
