//
//  ViewController.m
//  KIAVPlayer
//
//  Created by SmartWalle on 16/5/24.
//  Copyright © 2016年 SmartWalle. All rights reserved.
//

#import "ViewController.h"
#import "KIAVPlayer.h"

@interface ViewController ()
@property (nonatomic, strong) KIAVPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *v = [self.player view];
    [v setBackgroundColor:[UIColor greenColor]];
    [v setFrame:CGRectMake(0, 20, 320, 246)];
    [self.view addSubview:v];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.player playWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"mp4"]]];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *v = [self.player view];
        [UIView animateWithDuration:0.2
                         animations:^{
                             [v setTransform:CGAffineTransformMakeRotation(M_PI_2)];
                             [v setFrame:CGRectMake(10, 10, 320-20, 568-20)];
                         }];
        
    });
}

- (KIAVPlayer *)player {
    if (_player == nil) {
        _player = [[KIAVPlayer alloc] init];
    }
    return _player;
}

@end
