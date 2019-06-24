//
//  Tag_TvbCell.m
//  AudioTag
//
//  Created by Chang Wayne on 12/3/3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Tag_TbvCell.h"
#import "AudioTagAppDelegate.h"

@implementation Tag_TbvCell
@synthesize lblTagName;
@synthesize lblTotalDuration;
@synthesize btnStar;
@synthesize imgvUnlinkedTag;
@synthesize lblSimpleDescription;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)star_Pressed:(id)sender
{      
    AudioTagAppDelegate *appDelegate = (AudioTagAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIButton *btn = (UIButton *)sender;
    NSString *aMsg1 = [NSString stringWithFormat:@"No.%d--STAR %d", btn.tag, btn.selected];
    [appDelegate.utility MsgLog:self.class withFuncName:@"star_Pressed" withMsg:aMsg1];
    //UIImage *star_on = [UIImage imageNamed:@"star_on.png"];
    //UIImage *star_off = [UIImage imageNamed:@"star_off.png"];
    UIImage *star_on = [UIImage imageNamed:@"star2_yellow@2x.png"];
    UIImage *star_off = [UIImage imageNamed:@"star2@2x.png"];
    
    playlist *plistFavorite = appDelegate.dataFromSqlite._favorite_playlist;
    tag *aTag = [appDelegate.dataFromSqlite._tag objectAtIndex:btn.tag];
    if (btn.isSelected == YES){     // STAR ON ：已經加入Favorite Playlist
        // 將該tag從Favorite Playlist刪掉
        [plistFavorite removeOwned_tagsObject:aTag];
        [btn setImage:star_off forState:UIControlStateNormal];
        btn.selected = NO;
    }else{                          // STAR OFF：還沒加入Favorite Playlist
        // 將該tag加入Favorite Playlist
        [plistFavorite addOwned_tagsObject:aTag];
        [btn setImage:star_on forState:UIControlStateNormal];
        btn.selected = YES;
    }
    
    [appDelegate.dataFromSqlite loadDataFromDBToMemory]; 
}
@end
