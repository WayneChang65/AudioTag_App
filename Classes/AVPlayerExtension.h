//
//  AVPlayerExtension.h
//  AudioTag
//
//  Created by Chang Wayne on 11/12/19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerExtension : NSObject{
    
}

- (NSTimeInterval)getDurationFromMp3Filename:(NSString *)filename_mp3;
@end
