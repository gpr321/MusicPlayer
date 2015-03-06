//
//  GPMusicItem.h
//  LinLinMusic
//
//  Created by mac on 15-1-25.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPMusicItem : NSObject

/** 音乐的资源路径 */
@property (nonatomic,strong) NSURL *url;

- (instancetype)initWithURL:(NSURL *)url;

+ (instancetype)musicItemWithURL:(NSURL *)url;

@end
