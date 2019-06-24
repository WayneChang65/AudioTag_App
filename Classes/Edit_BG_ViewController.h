//
//  Edit_BG_ViewController.h
//  AudioTag
//
//  Created by Chang Wayne on 12/9/4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Edit_ViewController.h"

@interface Edit_BG_ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    Edit_ViewController *edit_VC;
    UIPickerView *pkvABTime;
    NSMutableArray *maryABMinute, *maryABSecond;
    NSNumber *isAkeyOrBkeyPressed;   // YES = Akey, NO = Bkey
    NSString *strABTime;
    NSNumber *numMaxMinute;
    UIButton *btnABKeySign;
    NSString *strATime;
    NSString *strBTime;
    
}

@property (nonatomic, strong) Edit_ViewController *edit_VC;
@property (nonatomic, strong) IBOutlet UIPickerView *pkvABTime;
@property (nonatomic, strong) NSMutableArray *maryABMinute;
@property (nonatomic, strong) NSMutableArray *maryABSecond;
@property (nonatomic, strong) NSNumber *isAkeyOrBkeyPressed;
@property (nonatomic, strong) NSString *strABTime;
@property (nonatomic, strong) NSNumber *numMaxMinute;
@property (nonatomic, strong) IBOutlet UIButton *btnABKeySign;

- (IBAction)uncurl_edit_VC_touchDown:(id)sender;

- (IBAction)ok_pressed:(id)sender;

- (void)update_pkvABTimeObjects:(id)sender;

- (void)backToPlaying_ViewController:(id)sender;

@end
