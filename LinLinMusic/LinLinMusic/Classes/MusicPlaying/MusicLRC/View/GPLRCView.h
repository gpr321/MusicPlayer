//
//  GPLRCView.h
//  LinLinMusic
//
//  Created by mac on 15-1-26.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPLRCViewItem;

@interface GPLRCView : UIView

@property (nonatomic,strong) GPLRCViewItem *lrcItem;

/** 当前高亮的百分比,用于重绘当前歌词的着色进度 */
@property (nonatomic,assign) CGFloat currPrecent;

@end
