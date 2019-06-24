//
//  Favorite_ViewController.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Favorite_ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *listData;
    UITableView *tbvFavoriteDisplay;
    NSMutableArray *listData_MP3OrTAG_Status;
    NSMutableArray *maryOOFPA;  // OOFPA : Order Of Favorite Playlist Array
    NSNumber *numIndexOfPlayFavoriteList;
    
    NSString *strTheNextPlayName;
    NSNumber *numIsTagTheNextPlay;
    
    NSString *strThePreviousPlayName;
    NSNumber *numIsTagThePreviousPlay;
    
    NSTimer *tmrRefreshPlayTypeBtn;
}

@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) IBOutlet UITableView *tbvFavoriteDisplay;
@property (nonatomic, strong) NSMutableArray *listData_MP3OrTAG_Status;
@property (nonatomic, strong) NSMutableArray *maryOOFPA;
@property (nonatomic, strong) NSNumber *numIndexOfPlayFavoriteList;

@property (nonatomic, strong) NSString *strTheNextPlayName;
@property (nonatomic, strong) NSNumber *numIsTagTheNextPlay;

@property (nonatomic, strong) NSString *strThePreviousPlayName;
@property (nonatomic, strong) NSNumber *numIsTagThePreviousPlay;


@property (nonatomic, strong) NSTimer *tmrRefreshPlayTypeBtn;

- (NSArray *)getPreviousPlayInfo:(NSString *)currentPlayName;
- (NSArray *)getNextPlayInfo:(NSString *)currentPlayName;

@end
