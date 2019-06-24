//
//  Playing_ViewController.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Playing_ViewController : UIViewController <AVAudioPlayerDelegate> 
{
    NSNumber *needToPlayNewFile;
	UILabel *lblPlayingTitle;
    UISlider *sldVolumeChange;
    UILabel *lblCurrentTime;
    UISlider *sldProgressBar;
    UILabel *lblDuration;
    NSTimeInterval aKeyValue_double;
    NSTimeInterval bKeyValue_double;
    UIButton *btnAKey;
    UIButton *btnBKey;
    UIButton *btnPlayType;
    UIButton *btnSingleOrList;
    UIButton *btnSingleOrLoop;
    UIButton *btnPlayOrPause;
    UIButton *btnNextTrack;
    UIButton *btnPreviousTrack;
    UILabel *lblAKeyValue;
    UILabel *lblBKeyValue;
    UITextView *txvComment;
//    UILabel *lblAKey_Sign;
//    UILabel *lblBKey_Sign;
    UIImageView *imgvAKey_Sign;
    UIImageView *imgvBKey_Sign;
    NSString *strPlayingMp3Duration;

    int iIsAvplayerNil;
}


@property (nonatomic, strong) NSNumber *needToPlayNewFile;
@property (nonatomic, strong) IBOutlet UILabel *lblPlayingTitle;
@property (nonatomic, strong) IBOutlet UISlider *sldVolumeChange;
@property (nonatomic, strong) IBOutlet UILabel *lblCurrentTime;
@property (nonatomic, strong) IBOutlet UISlider *sldProgressBar;
@property (nonatomic, strong) IBOutlet UILabel *lblDuration;
@property (nonatomic, strong) IBOutlet UILabel *lblAKeyValue;
@property (nonatomic, strong) IBOutlet UILabel *lblBKeyValue;
@property (nonatomic, strong) IBOutlet UIButton *btnAKey;
@property (nonatomic, strong) IBOutlet UIButton *btnBKey;
@property (nonatomic, strong) IBOutlet UIButton *btnPlayType;
@property (nonatomic, strong) IBOutlet UIButton *btnSingleOrList;
@property (nonatomic, strong) IBOutlet UIButton *btnSingleOrLoop;
@property (nonatomic, strong) IBOutlet UIButton *btnPlayOrPause;
@property (nonatomic, strong) IBOutlet UIButton *btnNextTrack;
@property (nonatomic, strong) IBOutlet UIButton *btnPreviousTrack;
@property (nonatomic, strong) IBOutlet UITextView *txvComment;
//@property (nonatomic, strong) IBOutlet UILabel *lblAKey_Sign;
//@property (nonatomic, strong) IBOutlet UILabel *lblBKey_Sign;
@property (nonatomic, strong) IBOutlet UIImageView *imgvAKey_Sign;
@property (nonatomic, strong) IBOutlet UIImageView *imgvBKey_Sign;
@property (nonatomic, strong) NSString *strPlayingMp3Duration;

- (IBAction)previousTrack_Pressed:(id)sender;
- (IBAction)nextTrack_Pressed:(id)sender;
- (IBAction)playOrPause_Pressed:(id)sender;
- (IBAction)volumeChange_SliderMoved:(id)sender;
- (IBAction)progressBar_SliderMoved:(UISlider *)sender;
- (IBAction)aKey_Pressed:(id)sender;
- (IBAction)bKey_Pressed:(id)sender;
- (IBAction)singleOrLopp_Pressed:(id)sender;
- (IBAction)singleOrList_Pressed:(id)sender;

- (void)remoteControlReceivedWithEvent:(UIEvent *)event;


@end
