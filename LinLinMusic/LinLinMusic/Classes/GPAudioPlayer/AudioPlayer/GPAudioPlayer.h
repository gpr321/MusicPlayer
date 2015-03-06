//
//  AudioPlayer.h
//  02-在线音乐播放器
//
//  Created by mac on 15-1-24.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

// 播放器默认的音量
#define kAudioPlayerDefaultVolume 1
// 默认的更新频率为0.01秒
#define kUpdateRate 0.01

#import <Foundation/Foundation.h>
@class GPAudioPlayer;

typedef NS_ENUM(NSInteger, GPAudioPlayerState){
    GPAudioPlayerStateReady = 0,
    GPAudioPlayerStateRunning = 1,
    GPAudioPlayerStatePlaying = 3,
    GPAudioPlayerStateBuffering = 5,
    GPAudioPlayerStatePaused = 9,
    GPAudioPlayerStateStopped = 16,
    GPAudioPlayerStateError = 32,
    GPAudioPlayerStateDisposed = 64
};

typedef NS_ENUM(NSInteger, GPAudioPlayerStopReason){
    GPAudioPlayerStopReasonNone = 0,
    GPAudioPlayerStopReasonEof,
    GPAudioPlayerStopReasonUserAction,
    GPAudioPlayerStopReasonPendingNext,
    GPAudioPlayerStopReasonDisposed,
    GPAudioPlayerStopReasonError = 0xffff
};

@protocol GPAudioPlayerDelegate <NSObject>

@optional
-(void) audioPlayer:(GPAudioPlayer*)audioPlayer stateChanged:(GPAudioPlayerState)state previousState:(GPAudioPlayerState)previousState;

- (void)audioPlayer:(GPAudioPlayer*)audioPlayer didChangeProgress:(double)progress duration:(double)duration;

- (void)audioPlayer:(GPAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(GPAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration;

@end

@interface GPAudioPlayer : NSObject

+ (instancetype)shareAudioPlayer;

/** 音频资源路径 */
@property (nonatomic,strong) NSURL *url;

@property (nonatomic,assign,readonly) GPAudioPlayerState state;

/** 监听状态改变 */
@property (nonatomic,weak) id<GPAudioPlayerDelegate> delegate;

#pragma mark - 监听进度
/** 多长时间监听一次进度,默认的更新频率为0.01秒 */
@property (nonatomic,assign) NSTimeInterval updateRate;

/** 总进度 */
@property (nonatomic,assign) double duration;

#pragma mark - 音乐控制
/** 设置音量,音量范围为 0 - 1.0 ,初始值为1.0,如果超过1.0,默认为1.0*/
@property (nonatomic,assign) Float32 volume;

/** 根据资源路径 URL 播放对应的音乐 */
- (void)playWithURL:(NSURL *)url;

/** 开始播放 */
- (void)play;

/** 暂停 */
- (void)pause;

/** 恢复播放 */
- (void)resume;

/** 结束播放 */
- (void)stop;

- (void)seekToTime:(double)time;

@end
