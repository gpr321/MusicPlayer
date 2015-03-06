//
//  GPMusicCell.m
//  LinLinMusic
//
//  Created by mac on 15-1-27.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

// 歌词的view 距离左右两边的间距
#define kSideMargin 25
// 歌词的view 距离上下两边的间距
#define kTopBottomMargin 8

#import "GPMusicCell.h"
#import "GPLRCView.h"
#import "GPLRCViewItem.h"
#import "GPMusicLRC.h"

@interface GPMusicCell ()

@property (weak, nonatomic) GPLRCView *lrcView;

@end

@implementation GPMusicCell

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ( self = [super initWithCoder:aDecoder] ) {
        GPLRCView *lrcView = [[GPLRCView alloc] init];
        [self addSubview:lrcView];
        _lrcView = lrcView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat sideMargin = 25;
    CGFloat topBottomMargin = 8;
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat lx = sideMargin;
    CGFloat ly = topBottomMargin;
    CGFloat lwidth = w - 2 * sideMargin;
    CGFloat lheight = h - 2 * topBottomMargin;
    _lrcView.frame = CGRectMake(lx, ly, lwidth, lheight);
    _lrcView.lrcItem = self.lrcItem;
}

- (void)setCurrItemPrecent:(CGFloat)currItemPrecent{
    _currItemPrecent = currItemPrecent;
    self.lrcView.currPrecent = currItemPrecent;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

+ (NSString *)cellID{
    return @"GPMusicCell";
}

+ (CGFloat)defaultRowHeight{
    return 40;
}

@end
