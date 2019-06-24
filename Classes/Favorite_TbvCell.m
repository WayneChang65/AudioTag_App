//
//  Favorite_TbvCell.m
//  AudioTag
//
//  Created by Chang Wayne on 12/4/10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Favorite_TbvCell.h"
#import "AudioTagAppDelegate.h"

@implementation Favorite_TbvCell
@synthesize lblFavoriteItemName;
@synthesize lblTotalDuration;
@synthesize btnStar;
@synthesize imgvUnlinkedTag;
@synthesize lblMp3OrTag;
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
//    UIImage *star_off = [UIImage imageNamed:@"star_off.png"];
    UIImage *star_off = [UIImage imageNamed:@"star2@2x.png"];
    NSString *strFromObjectClass = [NSString stringWithFormat:@"%@", self.class];
    
    playlist *plistFavorite = appDelegate.dataFromSqlite._favorite_playlist;
    mp3 *aMp3 = nil;
    tag *aTag = nil;
    
    // 在這個畫面isSelected一定是YES，而且是STAR_ON。因為，這裏只顯示已經加入Favorite Playlist的物件(mp3 or tag)
    if (btn.isSelected == YES){     // STAR ON ：已經加入Favorite Playlist
        if ([self.lblMp3OrTag.text isEqualToString:@"MP3"]){    // MP3
            // 將該mp3從Favorite Playlist刪掉
            aMp3 = [appDelegate.dataFromSqlite._mp3 objectAtIndex:btn.tag];
            [plistFavorite removeOwned_mp3sObject:aMp3];
            [btn setImage:star_off forState:UIControlStateNormal];
            btn.selected = NO;
        }else if ([self.lblMp3OrTag.text isEqualToString:@"TAG"]){  // TAG
            // 將該tag從Favorite Playlist刪掉
            aTag = [appDelegate.dataFromSqlite._tag objectAtIndex:btn.tag];
            [plistFavorite removeOwned_tagsObject:aTag];
            [btn setImage:star_off forState:UIControlStateNormal];
            btn.selected = NO;
        }else{
            // 除了MP3或TAG以外的東西，目前不會有這種情況
            [appDelegate.utility ErrLog:self.class withFuncName:@"star_Pressed" withMsg:@"NOT a MP3 or TAG!"];
        }
    }
    
    [appDelegate.dataFromSqlite loadDataFromDBToMemory];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH-TABLEVIEW" object:strFromObjectClass];
    
}
@end
