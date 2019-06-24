//
//  Playlist_ViewController.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBCurlView.h"

@interface Playlist_ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *listData;
    UIButton *btnLanguage;
}

@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) NSArray *listData_Image;
@property (nonatomic, strong) IBOutlet UITableView *tbvPlaylistDispaly;
@property (nonatomic, strong) IBOutlet UIButton *btnLanguage;

- (IBAction)changeLanguage_Pressed:(id)sender;



@end
