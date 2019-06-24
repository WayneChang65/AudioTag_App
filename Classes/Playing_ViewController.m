//
//  Playing_ViewController.m
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Playing_ViewController.h"
#import "Edit_ViewController.h"
#import "AudioTagAppDelegate.h"
#import "SVStatusHUD.h"

@implementation Playing_ViewController

@synthesize needToPlayNewFile;
@synthesize lblPlayingTitle;
@synthesize sldVolumeChange;
@synthesize lblCurrentTime;
@synthesize sldProgressBar;
@synthesize lblDuration;
@synthesize lblAKeyValue;
@synthesize lblBKeyValue;
@synthesize btnAKey;
@synthesize btnBKey;
@synthesize btnPlayType;
@synthesize btnSingleOrList;
@synthesize btnSingleOrLoop;
@synthesize btnPlayOrPause;
@synthesize btnNextTrack;
@synthesize btnPreviousTrack;
@synthesize txvComment;
//@synthesize lblAKey_Sign;
//@synthesize lblBKey_Sign;
@synthesize imgvAKey_Sign;
@synthesize imgvBKey_Sign;
@synthesize strPlayingMp3Duration;

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


#pragma mark AVAudioPlayer methods
-(void)updateViewForPlayerInfo:(AVAudioPlayer*)p
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];

    double a_time = [appDelegate.aTimeOfLastOpenedTag doubleValue];
    double b_time = [appDelegate.bTimeOfLastOpenedTag doubleValue];
    
    // 判斷目前的撥放型式是什麼？是MP3？TAG？還是PLT(playlist)？
    if (appDelegate.dataFromSqlite._preferences.last_opened_tag == nil){    // MP3
        self.lblDuration.text = [NSString stringWithFormat:@"%d:%02d", (int)p.duration / 60, (int)p.duration % 60, nil];
        self.sldProgressBar.maximumValue = p.duration;
        self.sldProgressBar.minimumValue = 0;
    }else{                                                                  // TAG
        NSTimeInterval tagDuration = b_time - a_time;
        self.lblDuration.text = [NSString stringWithFormat:@"%d:%02d", (int)tagDuration / 60, (int)tagDuration % 60, nil];
        self.sldProgressBar.maximumValue = b_time - a_time;
        self.sldProgressBar.minimumValue = 0;//[aTag.a_time doubleValue];
    }
    //
}

-(void)updateCurrentTimeForPlayer:(AVAudioPlayer *)p
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
   
    double a_time = [appDelegate.aTimeOfLastOpenedTag doubleValue];
    double b_time = [appDelegate.bTimeOfLastOpenedTag doubleValue];
    double N_Pos, A_Pos, B_Pos, N_Time, A_Time_org, B_Time_org;
    // A_Key_Sign或B_Key_Sign的位置計算
    A_Pos = 25;//self.lblAKey_Sign.frame.origin.x;
    B_Pos = 287;//self.lblBKey_Sign.frame.origin.x;
    N_Time = aKeyValue_double;
    //
    
    // 判斷目前的撥放型式是什麼？是MP3？TAG？還是PLT(playlist)？
    if (appDelegate.dataFromSqlite._preferences.last_opened_tag == nil){    // MP3
        self.lblCurrentTime.text = [NSString stringWithFormat:@"%d:%02d", (int)p.currentTime / 60, (int)p.currentTime % 60, nil];
        self.sldProgressBar.value = p.currentTime;
        
        // A_Key_Sign或B_Key_Sign的位置計算 (For MP3型)
        A_Time_org = 0;
        B_Time_org = p.duration;
        //
    }else{                                                                  // TAG
        NSTimeInterval tagCurrentTime = p.currentTime - a_time;
        self.lblCurrentTime.text = [NSString stringWithFormat:@"%d:%02d", (int)tagCurrentTime / 60, (int)tagCurrentTime % 60, nil];
        sldProgressBar.value = tagCurrentTime;
        
        // A_Key_Sign或B_Key_Sign的位置計算 (For TAG型)
        A_Time_org = a_time;
        B_Time_org = b_time;
        //
        
        if (p.currentTime > b_time) {
            [p pause];
            int iSingleOrLoop = [appDelegate.dataFromSqlite._preferences.single_or_loop intValue];
            if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
                // 列表撥放
                [[NSNotificationCenter defaultCenter] postNotificationName:@"FAVORITE-NEXT" object:appDelegate.dataFromSqlite._preferences.last_opened_tag];
                NSArray *nextPlayInfo = [appDelegate.viewCon_Favorite getNextPlayInfo:appDelegate.dataFromSqlite._preferences.last_opened_tag];
                NSNumber *isTag = [nextPlayInfo objectAtIndex:1];
                NSString *strNextPlayName = [nextPlayInfo objectAtIndex:0];
                if (strNextPlayName == nil){    // 列表撥放模式 + 非循環撥放(NOT LOOP) + 已經撥到最後一曲(而這一曲是Tag)
                    p.currentTime = a_time;
                }else{
                    if (isTag.intValue == YES){ // TAG
                        //appDelegate.dataFromSqlite._preferences.last_opened_tag = strNextPlayName;
                        [appDelegate.viewCon_Tag exe_do_goPlaying:strNextPlayName];
                    }else{                      // MP3
                        appDelegate.dataFromSqlite._preferences.last_opened_tag = nil;
                        appDelegate.mstrPlayingMP3Filename = [NSMutableString stringWithString:strNextPlayName];            
                    
                    }
                    self.needToPlayNewFile = [NSNumber numberWithBool:YES];
                    [self viewWillAppear:FALSE];
                }
            }else{
                // 單曲撥放
                switch (iSingleOrLoop) {
                    case 0: // Single(單次撥放)
                        p.currentTime = a_time;
                        break;
                    case 1: // Loop (循環撥放)
                        self.needToPlayNewFile = [NSNumber numberWithBool:YES];
                        [self viewWillAppear:FALSE];
                        break;
                    default:
                        break;
                }
            }
        }
    }
    //
    // A_Key_Sign或B_Key_Sign的位置計算
    if (A_Time_org != B_Time_org){
        N_Pos = A_Pos + (B_Pos - A_Pos) * (N_Time - A_Time_org) / (B_Time_org - A_Time_org);
    }else{
        N_Pos = A_Pos;
    }
//    self.lblAKey_Sign.frame = CGRectMake(N_Pos, self.lblAKey_Sign.frame.origin.y, self.lblAKey_Sign.frame.size.width, self.lblAKey_Sign.frame.size.height);
    self.imgvAKey_Sign.frame = CGRectMake(N_Pos, self.imgvAKey_Sign.frame.origin.y, self.imgvAKey_Sign.frame.size.width, self.imgvAKey_Sign.frame.size.height);
    
    N_Time = bKeyValue_double;
    if (A_Time_org != B_Time_org){
        N_Pos = A_Pos + (B_Pos - A_Pos) * (N_Time - A_Time_org) / (B_Time_org - A_Time_org);
    }else{
        N_Pos = A_Pos;
    }
//    self.lblBKey_Sign.frame = CGRectMake(N_Pos, self.lblBKey_Sign.frame.origin.y, self.lblBKey_Sign.frame.size.width, self.lblBKey_Sign.frame.size.height);
    self.imgvBKey_Sign.frame = CGRectMake(N_Pos, self.imgvBKey_Sign.frame.origin.y, self.imgvBKey_Sign.frame.size.width, self.imgvBKey_Sign.frame.size.height);
    //
}

- (void)updateCurrentTime
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	AVAudioPlayer *avapPlayer = appDelegate.avapPlayer;
    UIImage *play_on = [UIImage imageNamed:@"36-circle-play@2x.png"];
    UIImage *play_off = [UIImage imageNamed:@"37-circle-pause_bluebarry@2x.png"];
    // 依照Playing or Pause將btnPlayOrPause變更圖示

    if (!avapPlayer){ 
		NSLog(@"avapPlayer is NULL");
        [btnPlayOrPause setImage:play_on forState:UIControlStateNormal];
        [self.btnPreviousTrack setEnabled:NO];
        [self.btnNextTrack setEnabled:NO];
        self.btnPreviousTrack.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.btnNextTrack.layer.borderColor = [UIColor lightGrayColor].CGColor;        
	}else{
		if (avapPlayer.playing == YES){
            [btnPlayOrPause setImage:play_off forState:UIControlStateNormal];
            if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
                [self.btnPreviousTrack setEnabled:YES];
                [self.btnNextTrack setEnabled:YES];
                self.btnPreviousTrack.layer.borderColor = [UIColor darkGrayColor].CGColor;
                self.btnNextTrack.layer.borderColor = [UIColor darkGrayColor].CGColor;
            }else{
                [self.btnPreviousTrack setEnabled:NO];
                [self.btnNextTrack setEnabled:NO];
                self.btnPreviousTrack.layer.borderColor = [UIColor lightGrayColor].CGColor;
                self.btnNextTrack.layer.borderColor = [UIColor lightGrayColor].CGColor;        
            }
		}else{
            [btnPlayOrPause setImage:play_on forState:UIControlStateNormal];
            [self.btnPreviousTrack setEnabled:NO];
            [self.btnNextTrack setEnabled:NO];
            self.btnPreviousTrack.layer.borderColor = [UIColor lightGrayColor].CGColor;
            self.btnNextTrack.layer.borderColor = [UIColor lightGrayColor].CGColor;        
		}
	}
    //
    
	[self updateCurrentTimeForPlayer:avapPlayer];
}

- (void)updateViewForPlayerState:(AVAudioPlayer *)p
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
      
	[self updateCurrentTimeForPlayer:p];
    
	if (appDelegate.tmrUpdatePlaying_ViewController) [appDelegate.tmrUpdatePlaying_ViewController invalidate];
    
	//if (p.playing)
    if (p){
//		[playButton setImage:((p.playing == YES) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
//		[lvlMeter_in setPlayer:p];
		appDelegate.tmrUpdatePlaying_ViewController = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(updateCurrentTime) userInfo:p repeats:YES];
	}else{
//		[playButton setImage:((p.playing == YES) ? pauseBtnBG : playBtnBG) forState:UIControlStateNormal];
//		[lvlMeter_in setPlayer:nil];
		appDelegate.tmrUpdatePlaying_ViewController = nil;
	}
	
}

- (IBAction)progressBar_SliderMoved:(UISlider *)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	AVAudioPlayer *avapPlayer = appDelegate.avapPlayer;
       
    double a_time = [appDelegate.aTimeOfLastOpenedTag doubleValue];
    
    if (sender.value != 0) sender.value = sender.value - 0.001;
    
    // 不讓使用者一次就把sliderbar拉到最右邊，因為可能會造成audioPlayerDidFinishPlaying不會被呼叫到，而撥放中斷。
    // 所以，當使用者拉sliderbar時，如果拉超過最右邊，就自動減1，會先等1秒再結束，確保正常撥放完畢。
    if (sender.value > avapPlayer.duration - 1){
        sender.value = avapPlayer.duration - 1;
        self.sldProgressBar.value = avapPlayer.duration - 1;
        
    }
    
    // 判斷目前的撥放型式是什麼？是MP3？TAG？還是PLT(playlist)？
    if (appDelegate.dataFromSqlite._preferences.last_opened_tag == nil){    // MP3
        if (avapPlayer.isPlaying == YES){
            [avapPlayer pause];
            avapPlayer.currentTime = sender.value;
            [avapPlayer play];
       //     avapPlayer.currentTime = sender.value;
        }else{
            avapPlayer.currentTime = sender.value;
        }
    }else{                                                                  // TAG
        if (avapPlayer.isPlaying == YES){
            [avapPlayer pause];
            avapPlayer.currentTime = a_time + sender.value;
            [avapPlayer play];
        }else{
            avapPlayer.currentTime = a_time + sender.value;            
        }
    }
    //
    
//  NSLog(@"%f", sender.value);
    
	[self updateCurrentTimeForPlayer:avapPlayer];
}

- (IBAction)aKey_Pressed:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	AVAudioPlayer *avapPlayer = appDelegate.avapPlayer;
    
    aKeyValue_double = avapPlayer.currentTime;
    //NSLog(@"avapPlayer.currentTime = (double)%f", aKeyValue_double);
    self.lblAKeyValue.text = [NSString stringWithFormat:@"%d:%02d", (int)aKeyValue_double / 60, (int)aKeyValue_double % 60, nil];
    
    if (aKeyValue_double > bKeyValue_double) {
        bKeyValue_double = aKeyValue_double;
        self.lblBKeyValue.text = [NSString stringWithFormat:@"%d:%02d", (int)bKeyValue_double / 60, (int)bKeyValue_double % 60, nil];
    }    

}

- (IBAction)bKey_Pressed:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	AVAudioPlayer *avapPlayer = appDelegate.avapPlayer;
    
    bKeyValue_double = avapPlayer.currentTime;
    self.lblBKeyValue.text = [NSString stringWithFormat:@"%d:%02d", (int)bKeyValue_double / 60, (int)bKeyValue_double % 60, nil];

    if (aKeyValue_double > bKeyValue_double) {
        aKeyValue_double = bKeyValue_double;
        self.lblAKeyValue.text = [NSString stringWithFormat:@"%d:%02d", (int)aKeyValue_double / 60, (int)aKeyValue_double % 60, nil];
    }    


}

- (IBAction)singleOrLopp_Pressed:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    int iOld_SingleOrLoop = [appDelegate.dataFromSqlite._preferences.single_or_loop intValue];
    int iNew_SingleOrLoop;
//    UIImage *btnSingleOrLoop_Single = [UIImage imageNamed:@"02-redo@2x.png"];
//    UIImage *btnSingleOrLoop_Loop = [UIImage imageNamed:@"02-redo_deepblue@2x.png"];
    
    switch (iOld_SingleOrLoop) {
        case 0:
            iNew_SingleOrLoop = 1;
            self.btnSingleOrLoop.layer.backgroundColor = RGBA(0, 245, 255, 1.0).CGColor;
//            [self.btnSingleOrLoop setTitle:@"Loop" forState:UIControlStateNormal];
//            [btnSingleOrLoop setImage:btnSingleOrLoop_Loop forState:UIControlStateNormal];
            break;
        case 1:
            iNew_SingleOrLoop = 0;
            self.btnSingleOrLoop.layer.backgroundColor = RGBA(207, 207, 207, 1.0).CGColor;
//            [self.btnSingleOrLoop setTitle:@"Single" forState:UIControlStateNormal];
//            [btnSingleOrLoop setImage:btnSingleOrLoop_Single forState:UIControlStateNormal];
            break;
        default:
            iNew_SingleOrLoop = 0;
            [self.btnSingleOrLoop setTitle:@"Oh！" forState:UIControlStateNormal];
            break;
    }
    appDelegate.dataFromSqlite._preferences.single_or_loop = [NSString stringWithFormat:@"%d",iNew_SingleOrLoop];
}

- (IBAction)singleOrList_Pressed:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
        appDelegate.dataFromSqlite._preferences.last_opened_playlist = @"temp_playlist";
        self.btnSingleOrList.layer.backgroundColor = RGBA(207, 207, 207, 1.0).CGColor;        
    }else{
        appDelegate.dataFromSqlite._preferences.last_opened_playlist = @"favorite_playlist";
        self.btnSingleOrList.layer.backgroundColor = RGBA(0, 245, 255, 1.0).CGColor;
    }

    
    // 判斷目前的撥放型式是什麼？是MP3？TAG？還是PLT(playlist)？
    if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"temp_playlist"]){
        if (appDelegate.dataFromSqlite._preferences.last_opened_tag == nil){
            self.btnPlayType.titleLabel.text = @"MP3";
            self.btnPlayType.backgroundColor = RGBA(135, 206, 250, 0.5);
            self.txvComment.text = @"";
        }else{
            self.btnPlayType.titleLabel.text = @"TAG";
            self.btnPlayType.backgroundColor = RGBA(193, 255, 193, 1.0);
        }
    }else if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
        self.btnPlayType.titleLabel.text = @"LST";
        self.btnPlayType.backgroundColor = RGBA(255, 165, 0, 0.5);   
    }else{
        self.btnPlayType.titleLabel.text = @"Orz";
        self.btnPlayType.backgroundColor = RGBA(255, 0, 255, 1.0);        
    }

}

- (AVAudioPlayer *)playMP3WithFilename:(NSString*)filename_mp3
{
	NSError *error;
	NSString *path_without_filename, *path_with_filename;
	NSArray *paths;
	NSURL *url;
	//__unsafe_unretained AVAudioPlayer *avapPlayer; // [GCD]
	AVAudioPlayer *avapPlayer; // [GCD]
	
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];

  
    double a_time = [appDelegate.aTimeOfLastOpenedTag doubleValue];
    
    // 找出filename_mp3對應的URL
	paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	path_without_filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:@""];
	path_with_filename = [path_without_filename stringByAppendingPathComponent:filename_mp3];
	url = [NSURL URLWithString:[path_with_filename stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];

	// 這裏可以放心的alloc AVAudioPlayer物件，因為在viewWillAppear裏已經先把avapPlayer給release了。所以不會產生memory leak。
	avapPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	avapPlayer.delegate = self;
	
    
    NSString *alertTitle, *alertMsg, *alartCancelTitle;
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            alertTitle = @"MP3 File Error";
            alertMsg = @"MP3 Format Error";
            alartCancelTitle = @"OK";
            break;
        case iChinese_lang:
            alertTitle = @"MP3檔案錯誤";
            alertMsg = @"MP3檔案格式發生錯誤！";
            alartCancelTitle = @"確認";
            break;
    }

    
    // MP3開檔錯誤判斷
	if (error){
		NSLog(@"Error: %@", [error localizedDescription]);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle 
														message:alertMsg 
													   delegate:nil 
											  cancelButtonTitle:alartCancelTitle 
											  otherButtonTitles:nil];
		[alert show];
	}else{
        // 以下volume(音量)的設定，是從資料庫Entity對應的變數資料當參考(值從0到1的float型別)
        avapPlayer.volume = [appDelegate.dataFromSqlite._preferences.volume floatValue];
        
        // 以Tag的方式撥放，就必需從A Time開始撥放
        if (appDelegate.dataFromSqlite._preferences.last_opened_tag != nil){
            avapPlayer.currentTime = a_time;
        }
        
        //avapPlayer.currentTime = 200;

        [self updateViewForPlayerInfo:avapPlayer];
        [self updateViewForPlayerState:avapPlayer];

        // 背景撥放mp3
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive: YES error: nil];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        //
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),   // [GCD]
                       ^{                                                           // [GCD]
                           //[avapPlayer prepareToPlay];
                           if (iIsAvplayerNil == NO){
                               [avapPlayer play];
                           }else{
                               iIsAvplayerNil = NO;
                           }
                       });                                                          // [GCD]
	}

//	[filename_mp3 autorelease];
    self.strPlayingMp3Duration = [NSString stringWithFormat:@"%f", avapPlayer.duration];
	return avapPlayer;
}

- (IBAction)previousTrack_Pressed:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	AVAudioPlayer *avapPlayer = appDelegate.avapPlayer;
    if (!avapPlayer){ 
		NSLog(@"avapPlayer is NULL");
        return;
    }else{
        //[avapPlayer pause];
        //avapPlayer.currentTime = 0;
        if (avapPlayer.playing == NO){
            return;
        }
    }
    
    if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
        // 列表撥放
        // 如果要使用 getPreviousPlayInfo前，一定要先做postNotification，把資料更新 (重要)
        if (appDelegate.dataFromSqlite._preferences.last_opened_tag == nil){    // MP3
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FAVORITE-PREVIOUS" object:appDelegate.mstrPlayingMP3Filename];    
        }else{                                                                  // TAG
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FAVORITE-PREVIOUS" object:appDelegate.dataFromSqlite._preferences.last_opened_tag];
        }
        
        NSString *strLastOpenedMp3 = appDelegate.dataFromSqlite._preferences.last_opened_mp3;
        
        NSArray *previousPlayInfo = [appDelegate.viewCon_Favorite getPreviousPlayInfo:strLastOpenedMp3];

        if (previousPlayInfo == nil){
            return; // 代表List撥放已經退到第一首，而且沒有Loop撥放。==>有按上一首等於沒按。
        }else{

            NSNumber *isTag = [previousPlayInfo objectAtIndex:1];
            NSString *strPreviousPlayName = [previousPlayInfo objectAtIndex:0];
            
            if (isTag.intValue == YES){ // TAG
                [appDelegate.viewCon_Tag exe_do_goPlaying:strPreviousPlayName];
            }else{                      // MP3
                appDelegate.dataFromSqlite._preferences.last_opened_tag = nil;
                appDelegate.mstrPlayingMP3Filename = [NSMutableString stringWithString:strPreviousPlayName];            
            }
            self.needToPlayNewFile = [NSNumber numberWithBool:YES];
            [self viewWillAppear:FALSE];
        }
    }
}

- (IBAction)nextTrack_Pressed:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	AVAudioPlayer *avapPlayer = appDelegate.avapPlayer;
    if (!avapPlayer){ 
		NSLog(@"avapPlayer is NULL");
    }else{
        if (avapPlayer.playing == YES){
            //avapPlayer.currentTime = avapPlayer.duration - 0;
            [self audioPlayerDidFinishPlaying:avapPlayer successfully:YES];
        }else{}
    }
}

- (IBAction)playOrPause_Pressed:(id)sender
{
	AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	AVAudioPlayer *avapPlayer = appDelegate.avapPlayer;
//    UIImage *play_on = [UIImage imageNamed:@"36-circle-play@2x.png"];
//    UIImage *play_off = [UIImage imageNamed:@"37-circle-pause_bluebarry@2x.png"];
    
	// 程式一開始時，並沒有點選Sandbox的TableView，直接點右上角的進入Playing頁面，avapPlayer就會是NULL
	// 所以要做以下處理。
	if (!avapPlayer){ 
		NSLog(@"avapPlayer is NULL");
//        [btnPlayOrPause setImage:play_on forState:UIControlStateNormal];
		avapPlayer = [self playMP3WithFilename:appDelegate.mstrPlayingMP3Filename];
        appDelegate.avapPlayer = avapPlayer;
	}else{
		if (avapPlayer.playing == YES){
//            [btnPlayOrPause setImage:play_on forState:UIControlStateNormal];
			[avapPlayer pause];
		}else{
//            [btnPlayOrPause setImage:play_off forState:UIControlStateNormal];
			[avapPlayer play];
		}
	}
}

- (IBAction)volumeChange_SliderMoved:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	AVAudioPlayer *avapPlayer = appDelegate.avapPlayer;
    UISlider *valumeChange = (UISlider *)sender;
    static int fVolume;
    
    NSString *hudStatus;
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            hudStatus = @"Volume: %d %%"; break;
        case iChinese_lang:
            hudStatus = @"音量: %d %%"; break;
    }
    
    if (avapPlayer) {
        NSLog(@"avapPlayer.volume=%f", avapPlayer.volume);
        avapPlayer.volume = valumeChange.value;
        appDelegate.dataFromSqlite._preferences.volume = [NSString stringWithFormat:@"%f",valumeChange.value];
        // Show HUD
        if (fVolume < (int)(avapPlayer.volume * 100)){          // Volume UP
            fVolume = avapPlayer.volume * 100.;
            NSString *strHUD_status = [NSString stringWithFormat:hudStatus, fVolume];
            [SVStatusHUD showWithImage:[UIImage imageNamed:@"volume_up"] status:strHUD_status];
        }else if (fVolume > (int)(avapPlayer.volume * 100)){    // Volume DOWN
            fVolume = avapPlayer.volume * 100.;
            NSString *strHUD_status = [NSString stringWithFormat:hudStatus, fVolume];
            [SVStatusHUD showWithImage:[UIImage imageNamed:@"volume_down"] status:strHUD_status];            
        }else{}                                                 // Volume NO Change
        //
        
        // [avapPlayer play];   // 只調整音量不一定要撥放
    }
}

- (void)do_goEdit_BG:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    Edit_BG_ViewController *edit_BG_VC = appDelegate.viewCon_Edit_BG;

    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            [edit_BG_VC setTitle:@"Tag Edit"]; break;
        case iChinese_lang:
            [edit_BG_VC setTitle:@"標籤編輯"]; break;
    }
    
    
	[self.navigationController pushViewController:edit_BG_VC animated:YES];
    
	
    //	[edit_VC release];
}


- (void)do_goEdit:(id)sender
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    Edit_ViewController *edit_VC = appDelegate.viewCon_Edit;
//    Edit_ViewController *edit_VC = [[Edit_ViewController alloc] init];
    [edit_VC setTitle:@"Edit"];
	[self.navigationController pushViewController:edit_VC animated:YES];
    
	
//	[edit_VC release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    NSLog(@"Playing_ViewController:ViewDidLoad");
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    [self becomeFirstResponder];

   
    //	AVAudioPlayer *avapPlayer = appDelegate.avapPlayer;
    //UIImage *btnSingleOrLoop_Single = [UIImage imageNamed:@"arrow-circle2@2x.png"];
    //UIImage *btnSingleOrLoop_Loop = [UIImage imageNamed:@"02-redo_deepblue@2x.png"];
    
    self.btnNextTrack.layer.cornerRadius = 48.0 / 2;
    self.btnNextTrack.layer.borderWidth = 2.0;
    self.btnNextTrack.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.btnNextTrack setEnabled:NO];
    
    self.btnPreviousTrack.layer.cornerRadius = 48.0 / 2;
    self.btnPreviousTrack.layer.borderWidth = 2.0;
    self.btnPreviousTrack.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.btnPreviousTrack setEnabled:NO];
    
    self.btnPlayOrPause.layer.cornerRadius = 64.0 / 2;
    self.btnPlayOrPause.layer.borderWidth = 2.0;
    self.btnPlayOrPause.layer.borderColor = [UIColor darkGrayColor].CGColor;

    self.btnAKey.layer.cornerRadius = 5.0;
    self.btnAKey.layer.borderWidth = 0.5;
    self.btnAKey.layer.borderColor = [UIColor darkGrayColor].CGColor;

    self.btnBKey.layer.cornerRadius = 5.0;
    self.btnBKey.layer.borderWidth = 0.5;
    self.btnBKey.layer.borderColor = [UIColor darkGrayColor].CGColor;

    self.btnSingleOrLoop.layer.cornerRadius = 5.0;
    self.btnSingleOrLoop.layer.borderWidth = 0.5;
    self.btnSingleOrLoop.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.btnSingleOrList.layer.cornerRadius = 5.0;
    self.btnSingleOrList.layer.borderWidth = 0.5;
    self.btnSingleOrList.layer.borderColor = [UIColor darkGrayColor].CGColor;


    

    /*
    self.btnSingleOrLoop.layer.cornerRadius = 17.0;
    self.btnSingleOrLoop.layer.borderWidth = 1.5;
    self.btnSingleOrLoop.layer.borderColor = [UIColor redColor].CGColor;
    self.btnSingleOrLoop.backgroundColor = [UIColor whiteColor];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects: (id)[UIColor whiteColor].CGColor, (id)[UIColor redColor].CGColor, nil];
    [layer setColors:colors];
    [layer setFrame:self.btnSingleOrLoop.bounds];
    [self.btnSingleOrLoop.layer insertSublayer:layer atIndex:0];
    self.btnSingleOrLoop.clipsToBounds = YES; //重要！ 讓Button的顏色漸層在Bound裏，而不是整個squire
    */
    
    int iSingleOrLoop;
    
    iIsAvplayerNil = YES;
    
    NSString *bbtnGoEdit;
    switch (appDelegate.numLanguage.intValue) {
        case iEnglish_lang:
            bbtnGoEdit = @"Tag Edit"; break;
        case iChinese_lang:
            bbtnGoEdit = @"標籤編輯"; break;
    }
    
	// Navigation Control右邊的Button設定
	UIBarButtonItem *goEdit_BG = [[UIBarButtonItem alloc] initWithTitle:bbtnGoEdit 
                                                               style:UIBarButtonItemStyleBordered 
                                                              target:self 
                                                              action:@selector(do_goEdit_BG:)];
	self.navigationItem.rightBarButtonItem = goEdit_BG;
	//

//    [self.btnAKey setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [self.btnBKey setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
//    [self.btnAKey setBackgroundColor:[UIColor grayColor]];
//    [self.btnBKey setBackgroundColor:[UIColor grayColor]];
	
    [self.btnPlayType setBackgroundColor:[UIColor yellowColor]];
    [self.btnPlayType setEnabled:NO];
    
    //double b_time = [appDelegate.bTimeOfLastOpenedTag doubleValue];
    //self.lblCurrentTime.text = [NSString stringWithFormat:@"%d:%02d", (int)b_time / 60, (int)b_time % 60, nil];
    self.lblCurrentTime.text = @"00:00";
    
//    if (avapPlayer){ 
//        self.sldVolumeChange.value = avapPlayer.volume;
//        [self updateViewForPlayerInfo:avapPlayer];
//        [self updateViewForPlayerState:avapPlayer];
//    }else{
//        NSLog(@"avapPlayer == NULL");
    self.sldVolumeChange.value = [appDelegate.dataFromSqlite._preferences.volume floatValue];
//    }
    
    iSingleOrLoop = [appDelegate.dataFromSqlite._preferences.single_or_loop intValue];
    switch (iSingleOrLoop) {
        case 0:
            self.btnSingleOrLoop.layer.backgroundColor = RGBA(207, 207, 207, 1.0).CGColor;
            break;
        case 1:
            self.btnSingleOrLoop.layer.backgroundColor = RGBA(0, 245, 255, 1.0).CGColor;
            break;
        default:
            [self.btnSingleOrLoop setTitle:@"Oh！" forState:UIControlStateNormal];
            break;
    }
    
   if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
        self.btnSingleOrList.layer.backgroundColor = RGBA(0, 245, 255, 1.0).CGColor;
    }else{
        self.btnSingleOrList.layer.backgroundColor = RGBA(207, 207, 207, 1.0).CGColor;
    }
    
    self.txvComment.text = @"";
    
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
	AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	NSLog([NSString stringWithFormat:@"PlayingVC--viewWillAppear--%@", appDelegate.mstrPlayingMP3Filename], nil);
	
//	AVAudioPlayer *avapPlayer = appDelegate.avapPlayer;
    AVAudioPlayer *avapPlayer;
    NSTimer *tTimer = appDelegate.tmrUpdatePlaying_ViewController;
    
//    UIImage *play_on = [UIImage imageNamed:@"36-circle-play@2x.png"];
//    UIImage *play_off = [UIImage imageNamed:@"37-circle-pause_bluebarry@2x.png"];
    

    double a_time = [appDelegate.aTimeOfLastOpenedTag doubleValue];
    double b_time = [appDelegate.bTimeOfLastOpenedTag doubleValue];
    NSTimeInterval mp3Duration;
    NSTimeInterval tagDuration;
    
	// 撥放mp3音樂檔
	if ([self.needToPlayNewFile intValue] == YES){
        if (tTimer) [tTimer invalidate];    // tTimer先停掉，再設為nil，讓AutoRelease Pool釋放
        tTimer = nil;
		avapPlayer = [self playMP3WithFilename:appDelegate.mstrPlayingMP3Filename];
		appDelegate.avapPlayer = avapPlayer;
		self.needToPlayNewFile = [NSNumber numberWithInt:NO];
        appDelegate.isNeedToResetABKey = [NSNumber numberWithBool:YES];
	 }
	
    // 如果是撥放tag模式，就把該tag儲存的A B Time給show上去
    if (appDelegate.dataFromSqlite._preferences.last_opened_tag != nil){
        tagDuration = b_time - a_time;
        self.lblPlayingTitle.text = [NSString stringWithString:appDelegate.strPlayingTagName];
        self.lblDuration.text = [NSString stringWithFormat:@"%d:%02d", (int)tagDuration / 60, (int)tagDuration % 60, nil];
        if (appDelegate.isNeedToResetABKey.boolValue == YES){
            self.lblAKeyValue.text = [NSString stringWithFormat:@"%d:%02d", (int)a_time / 60, (int)a_time % 60, nil];
            self.lblBKeyValue.text = [NSString stringWithFormat:@"%d:%02d", (int)b_time / 60, (int)b_time % 60, nil];
            aKeyValue_double = a_time;
            bKeyValue_double = b_time;
            appDelegate.isNeedToResetABKey = [NSNumber numberWithBool:NO];
        }
        self.txvComment.text = appDelegate.commentOfLastOpenedTag;
    }else{
        self.lblPlayingTitle.text = appDelegate.mstrPlayingMP3Filename;
        if (appDelegate.isNeedToResetABKey.boolValue == YES){
            mp3Duration = [appDelegate.avPlayerExtension getDurationFromMp3Filename:appDelegate.mstrPlayingMP3Filename];
            self.lblAKeyValue.text = [NSString stringWithFormat:@"0:00"];
            self.lblBKeyValue.text = [NSString stringWithFormat:@"%d:%02d", (int)mp3Duration / 60, (int)mp3Duration % 60, nil];
            aKeyValue_double = 0;
            bKeyValue_double = mp3Duration;
            appDelegate.isNeedToResetABKey = [NSNumber numberWithBool:NO];
        }
        self.txvComment.text = @"";
    }
    
    // 判斷目前的撥放型式是什麼？是MP3？TAG？還是PLT(playlist)？
    if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"temp_playlist"]){
        if (appDelegate.dataFromSqlite._preferences.last_opened_tag == nil){
            self.btnPlayType.titleLabel.text = @"MP3";
            self.btnPlayType.backgroundColor = RGBA(135, 206, 250, 0.5);
            self.txvComment.text = @"";
        }else{
            self.btnPlayType.titleLabel.text = @"TAG";
            self.btnPlayType.backgroundColor = RGBA(193, 255, 193, 1.0);
        }
    }else if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
        self.btnPlayType.titleLabel.text = @"LST";
        self.btnPlayType.backgroundColor = RGBA(255, 165, 0, 0.5);   
    }else{
        self.btnPlayType.titleLabel.text = @"Orz";
        self.btnPlayType.backgroundColor = RGBA(255, 0, 255, 1.0);        
    }
    //
        
    // 依狀態變更btnSingleOrList的顏色
    if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
        self.btnSingleOrList.layer.backgroundColor = RGBA(0, 245, 255, 1.0).CGColor;
    }else{
        self.btnSingleOrList.layer.backgroundColor = RGBA(207, 207, 207, 1.0).CGColor;
    }

    
    // 依照Playing or Pause將btnPlayOrPause變更圖示
//    if (!avapPlayer){ 
//		NSLog(@"avapPlayer is NULL");
//        [btnPlayOrPause setImage:play_on forState:UIControlStateNormal];
//	}else{
//		if (avapPlayer.playing == YES){
//          [btnPlayOrPause setImage:play_on forState:UIControlStateNormal];
//		}else{
//            [btnPlayOrPause setImage:play_off forState:UIControlStateNormal];
//		}
//	}
    //
    
    
	[super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    
    // 為了更新aKeyValue_double及bKeyValue_double
    //[self aKey_Pressed:nil];
    //[self bKey_Pressed:nil];
    //
    
    // 以下是為了解決程式初啟動時，直接點選Playing_ViewController頁面，
    // 所造成的畫面顯示資訊不正確或音量調整功能無效等問題。
    // (原因是，appDelegate.avapPlayer這個變數還沒有值，歌曲還沒被載入所致)
    // 解決方式：檢查appDelegate.avapPlayer如果nil的話，就執行裏面的東西，使之有值。
    // 因為撥放是GCD，所以在裏面處理。
    if (appDelegate.avapPlayer == nil){
        [self playOrPause_Pressed:nil];    
    }
    //
    
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

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload 
{
	NSLog(@"Playing_ViewController--viewDidUnload");
    [super viewDidUnload];
    
    //[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    //[self resignFirstResponder];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	self.needToPlayNewFile = nil;
	self.lblPlayingTitle = nil;
	self.sldVolumeChange = nil;
    self.lblCurrentTime = nil;
    self.sldProgressBar = nil;
    self.lblDuration = nil;
    self.lblAKeyValue = nil;
    self.lblBKeyValue = nil;
    self.btnAKey = nil;
    self.btnBKey = nil;
    self.btnPlayType = nil;
    self.btnSingleOrList = nil;
    self.btnSingleOrLoop = nil;
    self.btnPlayOrPause = nil;
    self.btnNextTrack = nil;
    self.btnPreviousTrack = nil;
    self.txvComment = nil;
//    self.lblAKey_Sign = nil;
//    self.lblBKey_Sign = nil;
    self.imgvAKey_Sign = nil;
    self.imgvBKey_Sign = nil;
    self.strPlayingMp3Duration = nil;
}


- (void)dealloc 
{
	NSLog(@"Playing_ViewController--dealloc");
}

#pragma mark Remote Control Methods
//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event 
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    AVAudioPlayer *avapPlayer = appDelegate.avapPlayer;
    NSString *aMsg = nil;
    
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl){
        if (event.subtype == UIEventSubtypeRemoteControlPlay){
            aMsg = @"UIEventSubtypeRemoteControlPlay";
            
        }else if (event.subtype == UIEventSubtypeRemoteControlPause){
            aMsg = @"UIEventSubtypeRemoteControlPause";
            
        }else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause){
            aMsg = @"UIEventSubtypeRemoteControlTogglePlayPause";
            [self playOrPause_Pressed:nil];
            
        }else if (event.subtype == UIEventSubtypeRemoteControlNextTrack){
            aMsg = @"UIEventSubtypeRemoteControlNextTrack";
            if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"] && (avapPlayer != nil)){
                if (avapPlayer.playing == YES) [self nextTrack_Pressed:nil];
            }
            
        }else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack){
            aMsg = @"UIEventSubtypeRemoteControlPreviousTrack";
            if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"] && (avapPlayer != nil)){
                if (avapPlayer.playing == YES) [self previousTrack_Pressed:nil];
            }
        }
        
        [appDelegate.utility MsgLog:self.class withFuncName:@"remoteControlReceivedWithEvent" withMsg:aMsg];
    }
}

#pragma mark AVAudioPlayer delegate methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)p successfully:(BOOL)flag
{
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    int iSingleOrLoop = [appDelegate.dataFromSqlite._preferences.single_or_loop intValue];
       
	if (flag == NO){
		NSLog(@"Playback finished unsuccessfully");
	}else{
		NSLog(@"Playback finished successfully");
	}
	
//	[p setCurrentTime:0.];
	[self updateViewForPlayerState:p];
    
    if ([appDelegate.dataFromSqlite._preferences.last_opened_playlist isEqualToString:@"favorite_playlist"]){
    // 列表撥放
        // 如果要使用 getNextPlayInfo前，一定要先做postNotification，把資料更新 (重要)
        if (appDelegate.dataFromSqlite._preferences.last_opened_tag == nil){    // MP3
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FAVORITE-NEXT" object:appDelegate.mstrPlayingMP3Filename];    
        }else{                                                                  // TAG
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FAVORITE-NEXT" object:appDelegate.dataFromSqlite._preferences.last_opened_tag];
        }
        NSArray *nextPlayInfo = [appDelegate.viewCon_Favorite getNextPlayInfo:appDelegate.dataFromSqlite._preferences.last_opened_mp3];
        
        if (nextPlayInfo == nil){    // 列表撥放模式 + 非循環撥放(NOT LOOP) + 已經撥到最後一曲(而這一曲是MP3)
            // Do Nothing!!!
            return;
        }else{
            NSNumber *isTag = [nextPlayInfo objectAtIndex:1];
            NSString *strNextPlayName = [nextPlayInfo objectAtIndex:0];

            if (isTag.intValue == YES){ // TAG
                [appDelegate.viewCon_Tag exe_do_goPlaying:strNextPlayName];
            }else{                      // MP3
                appDelegate.dataFromSqlite._preferences.last_opened_tag = nil;
                appDelegate.mstrPlayingMP3Filename = [NSMutableString stringWithString:strNextPlayName];            
            }
            self.needToPlayNewFile = [NSNumber numberWithBool:YES];
            [self viewWillAppear:FALSE];
        }
    }else{
    // 單曲撥放
        switch (iSingleOrLoop) {
            case 0: // Single(單次撥放)
                break;
            case 1: // Loop (循環撥放)
                self.needToPlayNewFile = [NSNumber numberWithBool:YES];
                [self viewWillAppear:FALSE];
                break;
            default:
                break;
        }
    }
    
}

- (void)playerDecodeErrorDidOccur:(AVAudioPlayer *)p error:(NSError *)error
{
	NSLog(@"ERROR IN DECODE: %@\n", error); 
}

// we will only get these notifications if playback was interrupted
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)p
{
	NSLog(@"Interruption begin. Updating UI for new state");
	// the object has already been paused,	we just need to update UI
	//	if (inBackground)
	//	{
	//		[self updateViewForPlayerStateInBackground:p];
	//	}
	//	else
	//	{
	//		[self updateViewForPlayerState:p];
	//	}
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)p
{
	NSLog(@"Interruption ended. Resuming playback");
	[p play];
	//	[self startPlaybackForPlayer:p];
}


@end
