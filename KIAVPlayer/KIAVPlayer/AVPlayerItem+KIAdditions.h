//
//  AVPlayerItem+KIAdditions.h
//  Kitalker
//
//  Created by Kitalker on 14/11/25.
//  Copyright (c) 2014年 杨烽. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AVAsset+KIAdditions.h"

@interface AVPlayerItem (KIAdditions)

- (NSURL *)url;

- (NSTimeInterval)totalSeconds;

- (NSTimeInterval)availableSeconds;

- (NSString *)artist;

- (NSString *)albumName;

- (NSString *)title;

@end
