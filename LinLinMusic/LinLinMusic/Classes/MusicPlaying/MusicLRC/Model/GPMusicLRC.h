//
//  GPMusicLRC.h
//  LinLinMusic
//
//  Created by mac on 15-1-27.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPMusicLRC : NSObject

@property (nonatomic,copy) NSString *lrcString;

@property (nonatomic,assign) double time;
/** 歌词播放的开始时间 */
@property (nonatomic,assign) double startTime;
/** 歌词播放的结束时间 */
@property (nonatomic,assign) double endTime;
/** 歌词在歌词列表中所处的位置 */
@property (nonatomic,strong) NSIndexPath *indexPath;

- (instancetype)initWithLrcString:(NSString *)string;

+ (instancetype)musicLRCWithString:(NSString *)string;

+ (NSArray *)musicLRCsFromData:(NSData *)data;


@end
