//
//  CodingStyle.h
//  AudioTag
//
//  Created by Chang Wayne on 11/10/5.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef AudioTag_CodingStyle_h
#define AudioTag_CodingStyle_h

/// Detail Function Header (Doxygen格式)
/**
 * @brief <#brief description#>
 * @details <#detail description#>
 * @date <#date#>
 * @version <#version#>
 * @author <#author#>
 * @param <#parameter a#>
 * @param <#parameter b#>
 * @return <#return value#>
 */

/// Brief Function Header (Doxygen格式)
/**
 * @brief <#brief description#>
 * @param <#parameter a#>
 * @param <#parameter b#>
 * @return <#return value#>
 */


/**
 1. 成員變數命名
    依iOS內定的類別宣告，加上相關的prefix如下：
 
    NSString        ：strXXXX
    NSMutableString ：mstrXXXX
    NSSet           ：nsetXXXX
    NSArray         ：aryXXXX
    NSMutableArray  ：maryXXXX
    NSNumber        ：numXXXX
 
    TextField       ：txfXXXX
    TextView        ：txvXXXX
    UIButton        ：btnXXXX
    UILabel         ：lblXXXX
    UISlider        ：sldXXXX
    AVAudioPlayer   ：avapXXXX
    NSTimer         ：tmrXXXX
    UITableView     ：tbvXXXX
    UIImageView     ：imgvXXXX
    UIView          ：viewXXXX
    UIPickerView    ：pkvXXXX
 
    UITabBarController：tabBarCon_XXXX
    UINavigationController：navCon_XXXX
    AAA_ViewController：viewCon_XXXX
 
 2. IBAction函式命名
    依照操作相依之成員主要名稱加上底線及動作描述，如下：
    UIButton類別的成員，主要是做Play及Pause切換，所以用playOrPause當成操作相依之成員主要名稱。
    接下來加上底線，然後是動作描述Pressed。完整的IBAction函式名命為playOrPause_Pressed。
    其他範例：
    - (IBAction)playOrPause_Pressed:(id)sender;
    - (IBAction)volumeChange_SliderMoved:(id)sender;
    - (IBAction)progressBar_SliderMoved:(UISlider *)sender;
    - (IBAction)aKey_Pressed:(id)sender;
    - (IBAction)bKey_Pressed:(id)sender; 
 
 */

#endif
