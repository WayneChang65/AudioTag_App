//
//  Tag_ViewController.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Tag_ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *listData;
    NSNumber *needToPlayNewFile;
    UITableView *tbvTagDispaly;
}

@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSNumber *needToPlayNewFile;
@property (nonatomic, strong) IBOutlet UITableView *tbvTagDispaly;


- (IBAction)addTag_Pressed:(id)sender;
- (void)refreshTableView;
- (void)exe_do_goPlaying:(id)sender;
@end
