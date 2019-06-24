//
//  playlist.h
//  AudioTag
//
//  Created by Chang Wayne on 2011/8/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class mp3;
@class tag;

@interface playlist :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet* owned_mp3s;
@property (nonatomic, strong) NSSet* owned_tags;

@end


@interface playlist (CoreDataGeneratedAccessors)
- (void)addOwned_mp3sObject:(mp3 *)value;
- (void)removeOwned_mp3sObject:(mp3 *)value;
- (void)addOwned_mp3s:(NSSet *)value;
- (void)removeOwned_mp3s:(NSSet *)value;

- (void)addOwned_tagsObject:(tag *)value;
- (void)removeOwned_tagsObject:(tag *)value;
- (void)addOwned_tags:(NSSet *)value;
- (void)removeOwned_tags:(NSSet *)value;

@end

