//
//  GPMusicPlayingController.m
//  LinLinMusic
//
//  Created by mac on 15-1-25.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "GPMusicPlayingController.h"
#import "GPMusicControlView.h"
#import "GPAudioPlayer.h"
#import "UIView+Frame.h"
#import "GPLRCContainerView.h"
#import "GPMusicLRC.h"
#import "GPMusicLRCController.h"

@interface GPMusicPlayingController ()<GPAudioPlayerDelegate,GPMusicControlViewDelegate>

@property (weak, nonatomic) IBOutlet GPMusicControlView *musicControlView;

@property (weak, nonatomic) IBOutlet GPLRCContainerView *lrcShowingView;

@property (nonatomic,strong) GPAudioPlayer *audioPlayer;

@property (nonatomic,strong) NSArray *timeArray;

@property (nonatomic,assign) NSIndexPath *currIndexPath;


@end

@implementation GPMusicPlayingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialMusicControlView];
    [self initialMusicPlayer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initIalLRCShowingView];
}

#pragma mark - 歌词界面初始化
- (void)initIalLRCShowingView{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"GPMusicLRCController" bundle:nil];
    GPMusicLRCController *lrcVC = [storyBoard instantiateInitialViewController];
    [self addChildViewController:lrcVC];
    [self.lrcShowingView addSubview:lrcVC.view];
    lrcVC.view.frame = self.lrcShowingView.bounds;
}

#pragma mark - 初始化音乐播放器
- (void)initialMusicPlayer{
    self.audioPlayer.url = [[NSBundle mainBundle] URLForResource:@"a.mp3" withExtension:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTimeArray:) name:GPTimeArrayFinishLoadingNotification object:nil];
    // 以下代码目的是使用autioPlayer来初始化界面数据
    [self.audioPlayer play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.audioPlayer pause];
    });
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化时间数组 (为音乐播放做准备)
- (void)loadTimeArray:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    self.timeArray = userInfo[GPTimeArrayFinishLoadingKey];
    // 初始化第一个currIndexPath
    self.currIndexPath = [self.timeArray[0] indexPath];
}

#pragma mark - 核心算法,根据时间算出当前要播放哪一行歌词
- (NSIndexPath *)getMusicPlayIndexPathWithProgress:(double)progress{
    if ( self.timeArray == nil ) return nil;
    NSInteger i = self.currIndexPath.row;
    if ( self.currIndexPath == nil ) i = 0;
    // 从给定下标顺序遍历时间,增加效率
    GPMusicLRC *lrc = nil;
    for (; i < self.timeArray.count; i++) {
        lrc = self.timeArray[i];
        if ( progress >= lrc.startTime && progress <= lrc.endTime ) {
            return lrc.indexPath;
        }
    }
    // 找不到就往后遍历
    i = self.currIndexPath.row - 1;
    for (; i >=0; i--) {
        lrc = self.timeArray[i];
        if ( progress >= lrc.startTime && progress <= lrc.endTime ) {
            return lrc.indexPath;
        }
    }
    return [self.timeArray[0] indexPath];
}

#pragma mark - 核心算法,根据进度来算歌词的播放进度
- (CGFloat)currPrecentWithProgress:(double)progress{
    if ( self.timeArray == nil ) return 0;
    // 首先定位要使用那一个时间组
    GPMusicLRC *lrc = self.timeArray[self.currIndexPath.row];
    double wholeTime = lrc.endTime - lrc.startTime;
    double playTime = progress - lrc.startTime;
    return playTime / wholeTime;
}


#pragma mark - 初始化音乐控制面板的一些参数
- (void)initialMusicControlView{
    self.musicControlView.delegate = self;
}

#pragma mark - audioPlayer
- (GPAudioPlayer *)audioPlayer{
    if ( _audioPlayer == nil ) {
        _audioPlayer = [GPAudioPlayer shareAudioPlayer];
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}


#pragma mark - GPAudioPlayerDelegate
-(void) audioPlayer:(GPAudioPlayer*)audioPlayer stateChanged:(GPAudioPlayerState)state previousState:(GPAudioPlayerState)previousState{
    switch (state) {
        case GPAudioPlayerStatePlaying: // 开始播放,初始化音乐播放器的一些参数
        {
            self.musicControlView.sliderMaxVaulue = self.audioPlayer.duration;
            // 设置最后一个歌词的结束时间
            GPMusicLRC *lrc = self.timeArray[self.timeArray.count - 1];
            lrc.endTime = self.audioPlayer.duration;
        }
            break;
        default:
            break;
    }
}

- (void)audioPlayer:(GPAudioPlayer*)audioPlayer didChangeProgress:(double)progress duration:(double)duration{
    self.musicControlView.sliderProgress = progress;
    NSIndexPath *indexPath = [self getMusicPlayIndexPathWithProgress:progress];
    if ( self.currIndexPath == nil || indexPath.row != self.currIndexPath.row ) { // 切换下一行的歌词
        self.currIndexPath = indexPath;
        [[NSNotificationCenter defaultCenter] postNotificationName:GPUpdateLRCIndexPathNotification object:nil userInfo:@{GPUpdateLRCIndexPathKey : indexPath}];
    } else { // 如果不切换歌词就要发送进度
        CGFloat curPrecent = [self currPrecentWithProgress:progress];
        [[NSNotificationCenter defaultCenter] postNotificationName:GPUpdateLRCColorNotification object:nil userInfo:@{GPUpdateLRCColorKey :@(curPrecent)}];
    }
    
}

- (void)audioPlayer:(GPAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(GPAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
   
}

#pragma mark - GPMusicControlViewDelegate
- (void)musicControlView:(GPMusicControlView *)controlView didClickButton:(UIButton *)button type:(GPMusicControlViewButtonType)buttonType{
    switch (buttonType) {
        case GPMusicControlViewPlayButton:
            if ( button.selected == NO ) { // 开始播放
                if ( self.audioPlayer.state == GPAudioPlayerStatePaused ) {
                    [self.audioPlayer resume];
                } else if ( self.audioPlayer.state == GPAudioPlayerStateReady ){
                    [self.audioPlayer play];
                }
            } else { // 暂停播放
                [self.audioPlayer pause];
            }
            button.selected = !button.selected;
            break;
        case GPMusicControlViewPreviousButton:
           
            break;
        case GPMusicControlViewNextButton:
           
            break;
        default:
            break;
    }

}

- (void)musicControlView:(GPMusicControlView *)controlView didDragSlider:(float)sliderValue{
    [self.audioPlayer seekToTime:sliderValue];
}

@end
