//
//  Sandbox_TbvCell.h
//  AudioTag
//
//  Created by Chang Wayne on 11/12/15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Sandbox_TbvCell : UITableViewCell
{
    
}

@property (nonatomic, strong) IBOutlet UILabel *lblMp3Name;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalDuration;
@property (nonatomic, strong) IBOutlet UIButton *btnStar;

- (IBAction)star_Pressed:(id)sender;
@end
