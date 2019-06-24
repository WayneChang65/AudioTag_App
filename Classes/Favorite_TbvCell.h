//
//  Favorite_TbvCell.h
//  AudioTag
//
//  Created by Chang Wayne on 12/4/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Favorite_TbvCell : UITableViewCell
{
    
}

@property (nonatomic, strong) IBOutlet UILabel *lblFavoriteItemName;
@property (nonatomic, strong) IBOutlet UILabel *lblTotalDuration;
@property (nonatomic, strong) IBOutlet UIButton *btnStar;
@property (nonatomic, strong) IBOutlet UIImageView *imgvUnlinkedTag;
@property (nonatomic, strong) IBOutlet UILabel *lblMp3OrTag;
@property (nonatomic, strong) IBOutlet UILabel *lblSimpleDescription;

- (IBAction)star_Pressed:(id)sender;
@end
