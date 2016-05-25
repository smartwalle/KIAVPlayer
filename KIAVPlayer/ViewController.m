//
//  ViewController.m
//  KIAVPlayer
//
//  Created by SmartWalle on 16/5/24.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "ViewController.h"
#import "KIAVPlayer.h"
#import "KIAVPlayerView.h"

@interface ViewController ()
@property (nonatomic, strong) KIAVPlayer *player;
@property (nonatomic, strong) KIAVPlayerView *playerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *v = [self playerView];
    [v setBackgroundColor:[UIColor blackColor]];
    [v setFrame:CGRectMake(0, 20, 320, 246)];
    [self.view addSubview:v];
    [self.player setPlayerViewDelegate:self.playerView];
    
    [self.player setPlayerItemPlaybackBufferEmptyBlock:^(AVPlayerItem *playerItem) {
        NSLog(@"aaa");
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self.player playWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"mp4"]]];
    [self.player playWithURL:[NSURL URLWithString:@"http://192.168.192.151/b.mp4"]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *v = [self playerView];
        [UIView animateWithDuration:0.2
                         animations:^{
                             [v setTransform:CGAffineTransformMakeRotation(M_PI_2)];
                             [v setFrame:CGRectMake(0, 0, 320, 568)];
                             
                             [self.player setCurrentTime:60*10];
                         }];
        
    });
}

- (KIAVPlayer *)player {
    if (_player == nil) {
        _player = [[KIAVPlayer alloc] init];
    }
    return _player;
}

- (KIAVPlayerView *)playerView {
    if (_playerView == nil) {
        _playerView = [[KIAVPlayerView alloc] init];
    }
    return _playerView;
}

@end
