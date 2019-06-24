//
//  Edit_ViewController.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBCurlView.h"

@interface Edit_ViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate>
{
    UIImageView *imgvStar;
    UITextView *txvComment;
    UITextField *txfTagName;
//    UITextField *txfAkeyValue;
//    UITextField *txfBkeyValue;
    UITextField *txfLinkedMp3;
    UIButton *btnAkeyValue;
    UIButton *btnBkeyValue;
    NSString *strAkeyValue;
    NSString *strBkeyValue;
    UILabel *lblTagName;
    UILabel *lblLinkedMp3;
    UILabel *lblAkeyValue;
    UILabel *lblBKeyValue;
    UILabel *lblComment;
    NSNumber *numNeedToUpdate_EditVC;
    XBCurlView *curlView;
}

@property (nonatomic, strong) IBOutlet UIImageView *imgvStar;
@property (nonatomic, strong) IBOutlet UITextView *txvComment;
@property (nonatomic, strong) IBOutlet UITextField *txfTagName;
//@property (nonatomic, strong) IBOutlet UITextField *txfAkeyValue;
//@property (nonatomic, strong) IBOutlet UITextField *txfBkeyValue;
@property (nonatomic, strong) IBOutlet UITextField *txfLinkedMp3;
@property (nonatomic, strong) IBOutlet UIButton *btnAkeyValue;
@property (nonatomic, strong) IBOutlet UIButton *btnBkeyValue;
@property (nonatomic, strong)          NSString *strAkeyValue;
@property (nonatomic, strong)          NSString *strBkeyValue;
@property (nonatomic, strong) IBOutlet UILabel *lblTagName;
@property (nonatomic, strong) IBOutlet UILabel *lblLinkedMp3;
@property (nonatomic, strong) IBOutlet UILabel *lblAkeyValue;
@property (nonatomic, strong) IBOutlet UILabel *lblBKeyValue;
@property (nonatomic, strong) IBOutlet UILabel *lblComment;
@property (nonatomic, strong)          NSNumber *numNeedToUpdate_EditVC;

@property (nonatomic, strong) XBCurlView *curlView;

- (IBAction)hideSoftKeyboard_touchDown:(id)sender;
- (IBAction)curl_edit_VC_touchDown:(id)sender;

- (IBAction)akey_Pressed:(id)sender;
- (IBAction)bkey_Pressed:(id)sender;

- (void)do_SaveTag:(id)sender;

@end
