//
//  GPMusicLRC.m
//  LinLinMusic
//
//  Created by mac on 15-1-27.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "GPMusicLRC.h"

@implementation GPMusicLRC

- (instancetype)initWithLrcString:(NSString *)lrcString{
    if ( self = [super init] ) {
        self.time = 0;
        [self analysisString:lrcString];
    }
    return self;
}

#pragma mark - 解析歌词
- (void) analysisString:(NSString *)string{
    NSArray *array = [string componentsSeparatedByString:@"]"];
    if ( array[1] ) {
        self.lrcString = array[1];
    }
    NSString *target = array[0];
    target = [target substringFromIndex:1];
    NSArray *info = [target componentsSeparatedByString:@":"];
    if ( [self checkString:target] ) {
        NSString *minute = info[0];
        NSString *seconds = info[1];
        double time = [minute floatValue]*60 + [seconds floatValue];
        self.time = time;
    } else {
        self.lrcString = info[1];
    }
    
}

- (BOOL)checkString:(NSString *)string{
    __block BOOL flag = NO;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"\\d{2}:\\d{2}.\\d{2}" options:NSRegularExpressionCaseInsensitive error:NULL];
    [expression enumerateMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if ( result ) {
            flag = YES;
        }
    }];
    return flag;
}

+ (instancetype)musicLRCWithString:(NSString *)lrcString{
    return [[self alloc] initWithLrcString:lrcString];
}

- (void)setLrcString:(NSString *)lrcString{
    _lrcString = lrcString;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"start : %.2lf end : %.2f -%@",self.startTime,self.endTime,self.lrcString];
}


+ (NSArray *)musicLRCsFromData:(NSData *)data{
    NSMutableArray *lrcs = [NSMutableArray array];
    NSString *lrcString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *stringArray = [lrcString componentsSeparatedByString:@"\n"];
    GPMusicLRC *lrc = nil;
    double maxTime = 10 * 60;
    double minTime = 0.1;
    NSInteger i = 0;
    // 上一句歌词的结束时间
    GPMusicLRC *preLrc = nil;
    for (NSString *item in stringArray) {
        lrc = [GPMusicLRC musicLRCWithString:item];
        // 时间大于十分钟或者小于0.1秒大于0的自动忽略
        if ( lrc.time > maxTime || lrc.time < minTime ) {
            continue;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        // 计算播放信息
        lrc.startTime = lrc.time;
        preLrc.endTime = lrc.startTime;

        lrc.indexPath = indexPath;
        if ( i == stringArray.count - 1 ) { // 对最后一个歌词的结束事件做特殊处理
            lrc.endTime = lrc.startTime + 50;
        }
        [lrcs addObject:lrc];
        preLrc = lrc;
        i++;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:GPTimeArrayFinishLoadingNotification object:nil userInfo:@{GPTimeArrayFinishLoadingKey:lrcs}];
    return lrcs;
}


@end
