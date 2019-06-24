//
//  Tag_TvbCell.h
//  AudioTag
//
//  Created by Chang Wayne on 12/3/3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Tag_TbvCell : UITableViewCell
{
    
}

@property (nonatomic, strong) IBOutlet UILabel *lblTagName;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalDuration;
@property (nonatomic, strong) IBOutlet UIButton *btnStar;
@property (nonatomic, strong) IBOutlet UIImageView *imgvUnlinkedTag;
@property (nonatomic, strong) IBOutlet UILabel *lblSimpleDescription;

- (IBAction)star_Pressed:(id)sender;

@end
