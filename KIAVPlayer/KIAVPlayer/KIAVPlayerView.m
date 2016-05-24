//
//  KIAVPlayerView.m
//  KIAVPlayer
//
//  Created by SmartWalle on 16/5/24.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "KIAVPlayerView.h"

@interface KIAVPlayerView ()
@end

@implementation KIAVPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)setPlayer:(AVPlayer *)player {
    [[self playerLayer] setPlayer:player];
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

@end
