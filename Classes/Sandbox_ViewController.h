//
//  Sandbox_ViewController.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/7/13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface Sandbox_ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	NSMutableArray *listData;
	NSNumber *needToPlayNewFile;
    UITableView *tvbSandboxDisplay;
}

@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, strong) NSNumber *needToPlayNewFile;
@property (nonatomic, strong) IBOutlet UITableView *tvbSandboxDisplay;
@end
