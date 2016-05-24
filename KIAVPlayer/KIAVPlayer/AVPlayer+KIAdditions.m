//
//  AVPlayer+KIAdditions.m
//  Test
//
//  Created by 杨 烽 on 14/11/25.
//  Copyright (c) 2014年 杨 烽. All rights reserved.
//

#import "AVPlayer+KIAdditions.h"

@implementation AVPlayer (KIAdditions)

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    if (self.currentItem == nil) {
        return;
    }
    
    CMTime newTime = self.currentItem.currentTime;
    
    newTime.value = newTime.timescale * currentTime;
    [self seekToTime:newTime];
}

- (NSTimeInterval)currentTime {
    if (self.currentItem == nil) {
        return 0;
    }
    
    CGFloat currentTime = CMTimeGetSeconds(self.currentItem.currentTime);
    return currentTime;
}

- (BOOL)isPlaying {
    return self.rate != 0.0f;
}

@end
