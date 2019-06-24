//
//  Playlist_TbvCell.m
//  AudioTag
//
//  Created by Chang Wayne on 11/12/12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Playlist_TbvCell.h"

@implementation Playlist_TbvCell
@synthesize lblPlaylistName;
@synthesize lblNumberOfTags;
@synthesize imgvPlaylistPicture;

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

@end
