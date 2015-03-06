//
//  GPMusicTool.h
//  LinLinMusic
//
//  Created by mac on 15-2-8.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPSingleTon.h"

@interface GPMusicTool : NSObject
singtonInterface(MusicTool)
- (void)setUpToken;

@end
