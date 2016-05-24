//
//  AVPlayerItem+KIAdditions.m
//  Kitalker
//
//  Created by Kitalker on 14/11/25.
//  Copyright (c) 2014年 杨烽. All rights reserved.
//

#import "AVPlayerItem+KIAdditions.h"

@implementation AVPlayerItem (KIAdditions)

- (NSURL *)url {
    AVURLAsset *urlAsset = (AVURLAsset *)self.asset;
    return urlAsset.URL;
}

- (NSTimeInterval)totalSeconds {
    CGFloat duration = CMTimeGetSeconds(self.duration);
    return duration;
}

- (NSTimeInterval)availableSeconds {
    NSArray *loadedTimeRanges = [self loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue]; //获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds; //计算缓冲总进度
    return result;
}

- (NSString *)artist {
    return [self.asset artist];
}

- (NSString *)albumName {
    return [self.asset albumName];
}

- (NSString *)title {
    return [self.asset title];
}

@end
