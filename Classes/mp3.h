//
//  mp3.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/8/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface mp3 :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet* linked_tag;
@property (nonatomic, strong) NSSet* playlist_owner;

@end


@interface mp3 (CoreDataGeneratedAccessors)
- (void)addLinked_tagObject:(NSManagedObject *)value;
- (void)removeLinked_tagObject:(NSManagedObject *)value;
- (void)addLinked_tag:(NSSet *)value;
- (void)removeLinked_tag:(NSSet *)value;

- (void)addPlaylist_ownerObject:(NSManagedObject *)value;
- (void)removePlaylist_ownerObject:(NSManagedObject *)value;
- (void)addPlaylist_owner:(NSSet *)value;
- (void)removePlaylist_owner:(NSSet *)value;

@end

