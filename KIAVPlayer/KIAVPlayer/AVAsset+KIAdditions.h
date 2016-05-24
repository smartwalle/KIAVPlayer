//
//  AVAsset+KIAdditions.h
//  Test
//
//  Created by 杨 烽 on 14/11/25.
//  Copyright (c) 2014年 杨 烽. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (KIAdditions)

- (AVMetadataItem *)metadataItemWithKey:(NSString *)key;

- (NSString *)artist;

- (NSString *)albumName;

- (NSString *)title;

- (NSTimeInterval)totalSeconds;

//- (BOOL)cacheToFile:(NSString *)filePath;

@end
