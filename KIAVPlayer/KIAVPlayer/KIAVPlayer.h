//
//  KIAVPlayer.h
//  Kitalker
//
//  Created by Kitalker on 14/11/21.
//  Copyright (c) 2014年 杨烽. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
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
typedef void(^KIPlayerDidStartPlayItemBlcok)          (AVPlayerItem *playerItem);
typedef void(^KIPlayerDidPauseItemBlcok)              (AVPlayerItem *playerItem);
typedef void(^KIPlayerDidStopPlayItemBlcok)           (AVPlayerItem *playerItem);

typedef void(^KIPlayerItemDidPlayToEndTimeBlock)      (AVPlayerItem *playerItem, BOOL endTime);
typedef void(^KIPlayerItemFailedToPlayToEndTimeBlock) (AVPlayerItem *playerItem);
typedef void(^KIPlayerItemPlaybackBufferEmptyBlock)   (AVPlayerItem *playerItem);

typedef void(^KIPlayerDidUpdatePlayProgressBlcok)   (AVPlayerItem *playerItem, NSTimeInterval totalSeconds, NSTimeInterval currentTime);
typedef void(^KIPlayerLoadDataProgressBlock)        (AVPlayerItem *playerItem, NSTimeInterval totalSeconds, NSTimeInterval availableSeconds);


@class KIAVPlayer;
@protocol KIAVPlayerViewDelegate <NSObject>
- (void)player:(KIAVPlayer *)player readyToPlayItem:(AVPlayerItem *)playerItem;

- (void)playerDidStartPlay:(KIAVPlayer *)player;
- (void)playerDidPause:(KIAVPlayer *)player;
- (void)playerDidStopPlay:(KIAVPlayer *)player;

- (void)playerDidPlaybackBufferEmpty:(KIAVPlayer *)player;

- (void)player:(KIAVPlayer *)player didPlayToEndTime:(BOOL)endTime;
- (void)player:(KIAVPlayer *)player didLoadSeconds:(NSTimeInterval)availableSeconds totalSeconds:(NSTimeInterval)totalSeconds;
- (void)player:(KIAVPlayer *)player didUpdatePlayProgress:(NSTimeInterval)currentTime totalSeconds:(NSTimeInterval)totalSeconds;
@end

@interface KIAVPlayer : NSObject
@property (nonatomic, readonly) AVPlayerItem               *currentItem;
@property (nonatomic, assign)   NSTimeInterval             currentTime;
@property (nonatomic, weak)     id<KIAVPlayerViewDelegate> playerViewDelegate;

+ (KIAVPlayer *)sharedInstance;

- (AVPlayer *)player;

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
