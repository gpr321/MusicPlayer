//
//  GPStartPlayButton.m
//  LinLinMusic
//
//  Created by mac on 15-1-25.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#define kButtonImg_n @"playing_btn_play_n"
#define kButtonImg_h @"playing_btn_play_h"

#define kButtonSelectImg_n @"playing_btn_pause_n"
#define kButtonSelectImg_h @"playing_btn_pause_h"

#import "GPStartPlayButton.h"

@implementation GPStartPlayButton

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if ( !selected ) {
        [self setImage:[UIImage imageNamed:kButtonImg_n] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:kButtonImg_h] forState:UIControlStateHighlighted];
    } else {
        [self setImage:[UIImage imageNamed:kButtonSelectImg_n] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:kButtonSelectImg_h] forState:UIControlStateHighlighted];
    }
}

@end
