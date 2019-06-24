//
//  Sandbox_TbvCell.m
//  AudioTag
//
//  Created by Chang Wayne on 11/12/15.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Sandbox_TbvCell.h"
#import "AudioTagAppDelegate.h"

@implementation Sandbox_TbvCell
@synthesize lblMp3Name;
@synthesize lblTotalDuration;
@synthesize btnStar;

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
    mp3 *aMp3 = [appDelegate.dataFromSqlite._mp3 objectAtIndex:btn.tag];
    if (btn.isSelected == YES){     // STAR ON ：已經加入Favorite Playlist
        // 將該mp3從Favorite Playlist刪掉
        [plistFavorite removeOwned_mp3sObject:aMp3];
        [btn setImage:star_off forState:UIControlStateNormal];
        [btn setImage:star_off forState:UIControlStateSelected];
        btn.selected = NO;
    }else{                          // STAR OFF：還沒加入Favorite Playlist
        // 將該mp3加入Favorite Playlist
        [plistFavorite addOwned_mp3sObject:aMp3];
        [btn setImage:star_on forState:UIControlStateNormal];
        [btn setImage:star_on forState:UIControlStateSelected];
        btn.selected = YES;
    }
    
    [appDelegate.dataFromSqlite loadDataFromDBToMemory];
        
}

@end
