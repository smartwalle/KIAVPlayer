//
//  KIAVPlayer.h
//  Kitalker
//
//  Created by Kitalker on 14/11/21.
//  Copyright (c) 2014年 杨烽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "AVPlayer+KIAdditions.h"
#import "AVPlayerItem+KIAdditions.h"

extern NSString * const KIPlayerDidStartPlayNotification;
extern NSString * const KIPlayerDidPlayToEndTimeNotification;
extern NSString * const KIPlayerDidPauseItemNotification;
extern NSString * const KIPlayerDidStopPlayNotification;
extern NSString * const KIPlayerItemFailedToPlayToEndTimeNotification;
extern NSString * const KIPlayerItemPlaybackBufferEmptyNofification;

typedef void(^KIPlayerDidUpdateStatusBlock) (AVPlayerItem *playerItem, AVPlayerItemStatus status);
typedef void(^KIPlayerReadyToPlayBlock)     (AVPlayerItem *playerItem, NSTimeInterval duration);
typedef void(^KIPlayerDidStartPlayItemBlcok)        (AVPlayerItem *playerItem);
typedef void(^KIPlayerDidPauseItemBlcok)            (AVPlayerItem *playerItem);
typedef void(^KIPlayerDidStopPlayItemBlcok)         (AVPlayerItem *playerItem);
typedef void(^KIPlayerItemDidPlayToEndTimeBlock)    (AVPlayerItem *playerItem, BOOL endTime);
typedef void(^KIPlayerItemFailedToPlayToEndTimeBlock) (AVPlayerItem *playerItem);
typedef void(^KIPlayerItemPlaybackBufferEmptyBlock) (AVPlayerItem *playerItem);

typedef void(^KIPlayerDidUpdatePlayProgressBlcok)   (AVPlayerItem *playerItem, NSTimeInterval totalSeconds, NSTimeInterval currentTime);
typedef void(^KIPlayerLoadDataProgressBlock)        (AVPlayerItem *playerItem, NSTimeInterval totalSeconds, NSTimeInterval availableSeconds);


@interface KIAVPlayer : NSObject

@property (nonatomic, readonly) AVPlayerItem *currentPlayerItem;

@property (nonatomic, assign) NSTimeInterval currentTime;

- (AVPlayer *)player;

- (UIView *)view;

- (void)setPlayerDidUpdateStatusBlock:(KIPlayerDidUpdateStatusBlock)block;

- (void)setPlayerReadyToPlayBLock:(KIPlayerReadyToPlayBlock)block;

- (void)setPlayerDidStartPlayItemBlock:(KIPlayerDidStartPlayItemBlcok)block;

- (void)setPlayerDidPauseItemBlock:(KIPlayerDidPauseItemBlcok)block;

- (void)setPlayerDidStopPlayItemBlcok:(KIPlayerDidStopPlayItemBlcok)block;

- (void)setPlayerItemDidPlayToEndTimeBlock:(KIPlayerItemDidPlayToEndTimeBlock)block;

- (void)setPlayerItemFailedToPlayToEndTimeBlock:(KIPlayerItemFailedToPlayToEndTimeBlock)block;

- (void)setPlayerItemPlaybackBufferEmptyBlock:(KIPlayerItemPlaybackBufferEmptyBlock)blcok;


- (void)setPlayerDidUpdatePlayProgressBlock:(KIPlayerDidUpdatePlayProgressBlcok)block;

- (void)setPlayerLoadDataProgressBlock:(KIPlayerLoadDataProgressBlock)block;


- (void)playWithAsset:(AVURLAsset *)asset;

- (void)playWithURL:(NSURL *)audioURL;

- (void)play;

- (void)pause;

- (void)stop;

- (BOOL)isPlaying;

- (void)clean;

@end
