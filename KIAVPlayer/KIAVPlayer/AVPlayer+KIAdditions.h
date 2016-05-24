//
//  AVPlayer+KIAdditions.h
//  Test
//
//  Created by 杨 烽 on 14/11/25.
//  Copyright (c) 2014年 杨 烽. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVPlayer (KIAdditions)

@property (nonatomic) NSTimeInterval currentTime;

@property (nonatomic, readonly) BOOL isPlaying;

@end
