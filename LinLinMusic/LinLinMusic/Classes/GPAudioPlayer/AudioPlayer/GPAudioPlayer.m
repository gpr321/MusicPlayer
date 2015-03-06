//
//  AudioPlayer.m
//  02-在线音乐播放器
//
//  Created by mac on 15-1-24.
//  Copyright (c) 2015年 gpr. All rights reserved.
//


// GPMusicQueueId
#import "GPAudioPlayer.h"
#import "STKAudioPlayer.h"
#import "STKDataSource.h"
#import "GPMusicQueueId.h"

@interface GPAudioPlayer ()<STKAudioPlayerDelegate>

@property (nonatomic,strong) STKAudioPlayer *mPlayer;

/** 用来跟新进度的Timer */
@property (nonatomic,strong) NSTimer *updateTimer;

@property (nonatomic,strong) STKDataSource* dataSource;

/** 如果播放器没播放而用户 */
@property (nonatomic,assign) CGFloat currSeekTime;

@end

@implementation GPAudioPlayer

+ (instancetype)shareAudioPlayer{
    static GPAudioPlayer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (GPAudioPlayerState)state{
    return (GPAudioPlayerState)self.mPlayer.state;
}

- (STKAudioPlayer *)mPlayer{
    if ( _mPlayer == nil ) {
        _mPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES,
            // 如果要设置音量 VolumeMixer 要设置为YES
            .enableVolumeMixer = YES, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
        // 声道测量
        _mPlayer.meteringEnabled = YES;
        _mPlayer.volume = kAudioPlayerDefaultVolume;
        _mPlayer.delegate = self;
        self.updateRate = kUpdateRate;
    }
    return _mPlayer;
}

#pragma mark - updateTimer
- (NSTimer *)updateTimer{
    if ( _updateTimer == nil ) {
        _updateTimer = [NSTimer timerWithTimeInterval:self.updateRate target:self selector:@selector(updateState) userInfo:nil repeats:YES];
    }
    return _updateTimer;
}

- (void)startTimer{
    if ( ![self.delegate respondsToSelector:@selector(audioPlayer:didChangeProgress:duration:)] ) return;
    [[NSRunLoop currentRunLoop] addTimer:self.updateTimer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer{
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

- (void)updateState{
    if ( self.delegate && [self.delegate respondsToSelector:@selector(audioPlayer:didChangeProgress:duration:)]) {
        double progress = self.mPlayer.progress;
        double duration = self.mPlayer.duration;
        [self.delegate audioPlayer:self didChangeProgress:progress duration:duration];
    }
}

- (Float32)volume{
    return self.mPlayer.volume;
}

- (void)setVolume:(Float32)volume{
    self.mPlayer.volume = volume;
}

- (void)playWithURL:(NSURL *)url{
    self.url = url;
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    
    [self.mPlayer setDataSource:dataSource withQueueItemId:[[GPMusicQueueId alloc] initWithUrl:url andCount:0]];
    if ( self.currSeekTime ) {
        [self.mPlayer seekToTime:self.currSeekTime];
        self.currSeekTime = 0;
    }
    [self startTimer];
}

- (void)play{
    if ( !self.url ) return;
    [self playWithURL:self.url];
}

- (void)pause{
    [self.mPlayer pause];
    [self stopTimer];
}

- (void)resume{
    if ( self.currSeekTime ) {
        [self.mPlayer seekToTime:self.currSeekTime];
        self.currSeekTime = 0;
    }
    [self.mPlayer resume];
    [self startTimer];
}

- (void)stop{
    [self.mPlayer stop];
    [self stopTimer];
}

- (void)seekToTime:(double)time{
    if ( !self.mPlayer ) return;
    if ( self.mPlayer.state != STKAudioPlayerStatePlaying ) {
        self.currSeekTime = time;
        return;
    }
    [self pause];
    [self.mPlayer seekToTime:time];
    [self resume];
}


#pragma mark - STKAudioPlayerDelegate
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId{
    [self startTimer];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId{
}


-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState{
    if ( ![self.delegate respondsToSelector:@selector(audioPlayer:stateChanged:previousState:)] ) return;
    switch (state) {
        case STKAudioPlayerStatePlaying:
            self.duration = audioPlayer.duration;
            break;
        default:
            break;
    }
    GPAudioPlayerState mState = (GPAudioPlayerState)state;
    GPAudioPlayerState mPreState = (GPAudioPlayerState)previousState;
    
    [self.delegate audioPlayer:self stateChanged:mState previousState:mPreState];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration{
    [self stopTimer];
    if (![self.delegate respondsToSelector:@selector(audioPlayer:didFinishPlayingQueueItemId:withReason:andProgress:andDuration:)]) return;
    GPAudioPlayerStopReason reason = (GPAudioPlayerStopReason)stopReason;
    [self.delegate audioPlayer:self didFinishPlayingQueueItemId:queueItemId withReason:reason andProgress:progress andDuration:duration];
    
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode{
    [self stopTimer];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didCancelQueuedItems:(NSArray*)queuedItems{
    NSLog(@"--cancel");
    [self stopTimer];
}


@end
