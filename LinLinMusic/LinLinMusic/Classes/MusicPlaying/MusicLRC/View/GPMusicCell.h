//
//  GPMusicCell.h
//  LinLinMusic
//
//  Created by mac on 15-1-27.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPLRCViewItem;

@interface GPMusicCell : UITableViewCell

@property (nonatomic,strong) GPLRCViewItem *lrcItem;

/** 用来控制当前行歌词播放的进度 */
@property (nonatomic,assign) CGFloat currItemPrecent;

+ (NSString *)cellID;

+ (CGFloat)defaultRowHeight;
@end
