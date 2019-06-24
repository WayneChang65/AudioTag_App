//
//  tag.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/8/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class mp3;

@interface tag :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * b_time;
@property (nonatomic, strong) NSString * a_time;
@property (nonatomic, strong) NSString * commet;
@property (nonatomic, strong) NSString * linked_mp3filename;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet* playlist_owner;
@property (nonatomic, strong) mp3 * linked_mp3;

@end


@interface tag (CoreDataGeneratedAccessors)
- (void)addPlaylist_ownerObject:(NSManagedObject *)value;
- (void)removePlaylist_ownerObject:(NSManagedObject *)value;
- (void)addPlaylist_owner:(NSSet *)value;
- (void)removePlaylist_owner:(NSSet *)value;

@end

