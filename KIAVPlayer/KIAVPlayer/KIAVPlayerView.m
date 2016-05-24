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

- (void)player:(KIAVPlayer *)player readyToPlayItem:(AVPlayerItem *)playerItem {
    [self setPlayer:player.player];
}

- (void)playerDidStartPlay:(KIAVPlayer *)player {
    
}

- (void)playerDidPause:(KIAVPlayer *)player {
    
}

- (void)playerDidStopPlay:(KIAVPlayer *)player {
    [self setPlayer:nil];
}

- (void)player:(KIAVPlayer *)player didPlayToEndTime:(BOOL)endTime {
    [self setPlayer:nil];
}

- (void)player:(KIAVPlayer *)player didLoadSeconds:(NSTimeInterval)availableSeconds totalSeconds:(NSTimeInterval)totalSeconds {
    
}

- (void)player:(KIAVPlayer *)player didUpdatePlayProgress:(NSTimeInterval)currentTime totalSeconds:(NSTimeInterval)totalSeconds {
    NSLog(@"%f", currentTime/totalSeconds);
}

@end
