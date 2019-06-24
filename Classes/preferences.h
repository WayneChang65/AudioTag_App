//
//  preferences.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/8/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface preferences :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * elements_order_of_playlist;
@property (nonatomic, strong) NSString * language;
@property (nonatomic, strong) NSString * last_opened_mp3;
@property (nonatomic, strong) NSString * volume;
@property (nonatomic, strong) NSString * last_opened_playlist;
@property (nonatomic, strong) NSString * last_opened_tag;
@property (nonatomic, strong) NSString * single_or_loop;


@end



