//
//  KIAVPlayer.m
//  Kitalker
//
//  Created by Kitalker on 14/11/21.
//  Copyright (c) 2014年 杨烽. All rights reserved.
//

#import "KIAVPlayer.h"
#import "KIAVPlayerView.h"

NSString * const KIPlayerDidStartPlayNotification       = @"KIPlayerDidStartPlayNotification";
NSString * const KIPlayerDidPlayToEndTimeNotification   = @"KIPlayerDidPlayToEndTimeNotification";
NSString * const KIPlayerDidPauseItemNotification       = @"KIPlayerDidPauseItemNotification";
NSString * const KIPlayerDidStopPlayNotification        = @"KIPlayerDidStopPlayNotification";
NSString * const KIPlayerItemFailedToPlayToEndTimeNotification  = @"KIPlayerItemFailedToPlayToEndTimeNotification";
NSString * const KIPlayerItemPlaybackBufferEmptyNofification    = @"KIPlayerItemPlaybackBufferEmptyNofification";

@interface KIAVPlayer ()
@property (nonatomic, strong) AVPlayer       *player;
@property (nonatomic, strong) KIAVPlayerView *playerView;
@property (nonatomic, assign) BOOL           pauseWithUser;
@property (nonatomic, assign) BOOL           playImmediately;

@property (nonatomic, copy) KIPlayerDidUpdateStatusBlock        playerDidUpdateStatus;
@property (nonatomic, copy) KIPlayerReadyToPlayBlock            playerReadyToPlay;
@property (nonatomic, copy) KIPlayerDidStartPlayItemBlcok       playerDidStartPlayItem;
@property (nonatomic, copy) KIPlayerDidPauseItemBlcok           playerDidPauseItem;
@property (nonatomic, copy) KIPlayerDidStopPlayItemBlcok        playerDidStopPlayItem;
@property (nonatomic, copy) KIPlayerItemFailedToPlayToEndTimeBlock  playerItemFailedToPlayToEndTime;
@property (nonatomic, copy) KIPlayerItemPlaybackBufferEmptyBlock    playerItemPlaybackBufferEmpty;

@property (nonatomic, copy) KIPlayerItemDidPlayToEndTimeBlock   playerItemDidPlayToEndTime;
@property (nonatomic, copy) KIPlayerDidUpdatePlayProgressBlcok  playerDidUpdatePlayProgress;
@property (nonatomic, copy) KIPlayerLoadDataProgressBlock       playerLoadDataProgress;
@end

static KIAVPlayer *KI_AV_PLAYER;

@implementation KIAVPlayer

+ (KIAVPlayer *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        KI_AV_PLAYER = [[KIAVPlayer alloc] init];
    });
    return KI_AV_PLAYER;
}

- (void)dealloc {
    [self clean];
}

- (id)init {
    if (KI_AV_PLAYER == nil) {
        if (self = [super init]) {
            KI_AV_PLAYER = self;
        }
    }
    return KI_AV_PLAYER;
}

#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if (self.playerDidUpdateStatus != nil) {
            self.playerDidUpdateStatus(playerItem, playerItem.status);
        }
        
        if (playerItem.status == AVPlayerStatusReadyToPlay) {
            if (self.playerReadyToPlay != nil) {
                self.playerReadyToPlay(playerItem, playerItem.totalSeconds);
            }
            
            if (self.playImmediately) {
                [self play];
            }
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        if (self.pauseWithUser == NO && self.isPlaying == NO) {
            [self play];
        }
        
        NSTimeInterval availableSeconds = [playerItem availableSeconds];// 计算缓冲进度
        if (self.playerLoadDataProgress != nil) {
            self.playerLoadDataProgress(playerItem, playerItem.totalSeconds, availableSeconds);
        }
    } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
#ifdef DEBUG
        NSLog(@"playbackBufferEmpty");
#endif
        [[NSNotificationCenter defaultCenter] postNotificationName:KIPlayerItemPlaybackBufferEmptyNofification
                                                            object:self.player.currentItem];
        if (self.playerItemPlaybackBufferEmpty != nil) {
            self.playerItemPlaybackBufferEmpty(self.player.currentItem);
        }
    } else if ([keyPath isEqualToString:@"playbackBufferFull"]) {
#ifdef DEBUG
        NSLog(@"playbackBufferFull");
#endif
    }
}

#pragma mark - Methods
- (void)loadWithAsset:(AVURLAsset *)asset {
    [self clean];
    
    if (asset == nil) {
        return ;
    }
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:nil];
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    __weak KIAVPlayer *weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1)
                                              queue:NULL
                                         usingBlock:^(CMTime time) {
                                             CGFloat currentTime = weakSelf.currentTime;
                                             if (weakSelf.playerDidUpdatePlayProgress) {
                                                 weakSelf.playerDidUpdatePlayProgress(weakSelf.player.currentItem, weakSelf.player.currentItem.totalSeconds, currentTime);
                                             }
                                         }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidPlayToEndTime:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemFailedToPlayToEndTime:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:self.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemPlaybackStalledNotification:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:self.player.currentItem];
    
    if (self.player != nil) {
        [self.playerView setPlayer:self.player];
    }
}

- (void)playWithAsset:(AVURLAsset *)asset {
    [self setPlayImmediately:YES];
    [self loadWithAsset:asset];
}

- (void)load:(NSURL *)url {
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    [self loadWithAsset:asset];
}

- (void)loadWithURL:(NSURL *)url {
    [self setPlayImmediately:NO];
    [self load:url];
}

- (void)playWithURL:(NSURL *)url {
    [self setPlayImmediately:YES];
    [self load:url];
}

- (void)play {
    [self setPauseWithUser:NO];
    if (self.player && !self.player.isPlaying) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KIPlayerDidStartPlayNotification
                                                            object:self.player.currentItem];
        [self.player play];
        if (self.playerDidStartPlayItem != nil) {
            self.playerDidStartPlayItem(self.player.currentItem);
        }
    }
}

- (void)pause {
    [self setPauseWithUser:YES];
    if (self.player) {
        [self.player pause];
        if (self.playerDidPauseItem) {
            self.playerDidPauseItem(self.player.currentItem);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:KIPlayerDidPauseItemNotification
                                                            object:self.player.currentItem];
    }
}

- (void)stop {
    [self setPauseWithUser:YES];
    if (self.player) {
        [self.player pause];
        if (self.playerDidStopPlayItem) {
            self.playerDidStopPlayItem(self.player.currentItem);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:KIPlayerDidStopPlayNotification
                                                            object:self.player.currentItem];
    }
    [self clean];
}

- (BOOL)isPlaying {
    return self.player.isPlaying;
}

- (void)clean {
    [self setPauseWithUser:NO];
    [_player pause];
    
    if (_player.currentItem != nil) {
        [_player.currentItem removeObserver:self forKeyPath:@"status"];
        [_player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_player.currentItem removeObserver:self forKeyPath:@"playbackBufferFull"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _player = nil;
}

#pragma mark - NSNotification Handler
- (void)playerItemDidPlayToEndTime:(NSNotification *)noti {
    if (self.player) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KIPlayerDidPlayToEndTimeNotification
                                                            object:self.player.currentItem];
    }
    if (self.playerItemDidPlayToEndTime != nil) {
        self.playerItemDidPlayToEndTime(noti.object, self.player.currentTime==self.player.currentItem.totalSeconds);
    }
    [self clean];
}

- (void)playerItemFailedToPlayToEndTime:(NSNotification *)noti {
    if (self.player) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KIPlayerItemFailedToPlayToEndTimeNotification
                                                            object:self.player.currentItem];
    }
    if (self.playerItemFailedToPlayToEndTime != nil) {
        self.playerItemFailedToPlayToEndTime(noti.object);
    }
    [self clean];
}

- (void)playerItemPlaybackStalledNotification:(NSNotification *)noti {
}

#pragma mark - Getters & Setters
- (AVPlayerItem *)currentPlayerItem {
    return self.player.currentItem;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    if (self.player != nil) {
        [self.player setCurrentTime:currentTime];
    }
}

- (NSTimeInterval)currentTime {
    if (self.player == nil) {
        return 0;
    }
    return self.player.currentTime;
}

- (KIAVPlayerView *)playerView {
    if (_playerView == nil) {
        _playerView = [[KIAVPlayerView alloc] init];
    }
    return _playerView;
}

- (UIView *)view {
    return self.playerView;
}

- (void)setPlayerDidUpdateStatusBlock:(KIPlayerDidUpdateStatusBlock)block {
    [self setPlayerDidUpdateStatus:block];
}

- (void)setPlayerReadyToPlayBLock:(KIPlayerReadyToPlayBlock)block {
    [self setPlayerReadyToPlay:block];
}

- (void)setPlayerDidStartPlayItemBlock:(KIPlayerDidStartPlayItemBlcok)block {
    [self setPlayerDidStartPlayItem:block];
}

- (void)setPlayerDidPauseItemBlock:(KIPlayerDidPauseItemBlcok)block {
    [self setPlayerDidPauseItem:block];
}

- (void)setPlayerDidStopPlayItemBlcok:(KIPlayerDidStopPlayItemBlcok)block {
    [self setPlayerDidStopPlayItem:block];
}

- (void)setPlayerItemDidPlayToEndTimeBlock:(KIPlayerItemDidPlayToEndTimeBlock)block {
    [self setPlayerItemDidPlayToEndTime:block];
}

- (void)setPlayerItemFailedToPlayToEndTimeBlock:(KIPlayerItemFailedToPlayToEndTimeBlock)block {
    [self setPlayerItemFailedToPlayToEndTime:block];
}

- (void)setPlayerItemPlaybackBufferEmptyBlock:(KIPlayerItemPlaybackBufferEmptyBlock)blcok {
    [self setPlayerItemPlaybackBufferEmpty:blcok];
}

- (void)setPlayerDidUpdatePlayProgressBlock:(KIPlayerDidUpdatePlayProgressBlcok)block {
    [self setPlayerDidUpdatePlayProgress:block];
}

- (void)setPlayerLoadDataProgressBlock:(KIPlayerLoadDataProgressBlock)block {
    [self setPlayerLoadDataProgress:block];
}

@end
