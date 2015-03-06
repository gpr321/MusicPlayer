//
//  GPMusicQueueId.h
//  LinLinMusic
//
//  Created by mac on 15-1-25.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPMusicQueueId : NSObject

@property (readwrite) int count;
@property (readwrite) NSURL* url;

-(id) initWithUrl:(NSURL*)url andCount:(int)count;

@end
