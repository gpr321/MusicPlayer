//
//  GPLRCView.m
//  LinLinMusic
//
//  Created by mac on 15-1-26.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "GPLRCView.h"
#import "GPLRCViewItem.h"
#import "GPMusicLRC.h"

@interface GPLRCView ()
@end

@implementation GPLRCView

- (instancetype)initWithFrame:(CGRect)frame{
    if ( self = [super initWithFrame:frame] ) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setLrcItem:(GPLRCViewItem *)lrcItem{
    _lrcItem = lrcItem;
    if ( _lrcItem.lrcShowHeith != 0) {
        [self setNeedsDisplay];
        return;
    }
    CGSize wordSize = lrcItem.wordSize;
    CGFloat wordW = wordSize.width;
    CGFloat wordH = wordSize.height;
    // 计算行数
     NSInteger lines = 0;
    NSInteger wordCountInLine = self.bounds.size.width / wordW;
    if ( wordCountInLine > lrcItem.lrcModel.lrcString.length ) {
        lines = 1;
    } else {
        NSInteger more = lrcItem.lrcModel.lrcString.length % wordCountInLine ? 1 : 0;
        lines = more + lrcItem.lrcModel.lrcString.length / wordCountInLine;
    }
    // 设置尺寸
    NSMutableArray *lrcStringItems = [NSMutableArray arrayWithCapacity:lines];
    NSMutableArray *lrcStringFrames = [NSMutableArray arrayWithCapacity:lines];

    CGRect lFrame = CGRectZero;
    if ( lines == 1 ) {
        [lrcStringItems addObject:lrcItem.lrcModel.lrcString];
        lFrame = [self lrcFrameWithString:lrcItem.lrcModel.lrcString wordSize:wordSize atLine:0];
        [lrcStringFrames addObject:[NSValue valueWithCGRect:lFrame]];
    } else {
        NSInteger loc = 0;
        NSInteger len = 0;
        NSString *itemString = nil;
        for (NSInteger i = 0; i < lines; i++) {
            loc = i * wordCountInLine;
            if ( i == lines - 1 ) {
                len = lrcItem.lrcModel.lrcString.length - loc;
            } else {
                len = wordCountInLine;
            }
            itemString = [lrcItem.lrcModel.lrcString substringWithRange:NSMakeRange(loc, len)];
            
            [lrcStringItems addObject:itemString];
            lFrame = [self lrcFrameWithString:itemString wordSize:wordSize atLine:i];
            [lrcStringFrames addObject:[NSValue valueWithCGRect:lFrame]];
        }
    }
    _lrcItem.lrcStringItems = lrcStringItems;
    _lrcItem.lrcStringFrames = lrcStringFrames;
    _lrcItem.lrcShowHeith = lFrame.origin.y + wordH;
    [self setNeedsDisplay];
}

- (CGRect)lrcFrameWithString:(NSString *)lrcString wordSize:(CGSize)wordSize atLine:(NSInteger)line{
    CGFloat wordW = wordSize.width;
    CGFloat wordH = wordSize.height;
    CGFloat lH = 0;
    CGFloat lW = 0;
    CGFloat lX = 0;
    CGFloat lY = 0;
    CGFloat w = self.frame.size.width;
    
    lH = wordH;
    lW = lrcString.length * wordW;
    lX = (w - lW) * 0.5;

    lY = line * wordH;
    return  CGRectMake(lX, lY, lW, lH);
}

- (void)setCurrPrecent:(CGFloat)currPrecent{
    _currPrecent = currPrecent;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    if ( self.lrcItem == nil ) return;
    // 画歌词
    NSString *itemStr = nil;
    CGRect itemFrame = CGRectZero;
    CGFloat wholeLength = 0;
    NSDictionary *attributes = self.lrcItem.attributes;
    for (NSInteger i = 0; i < self.lrcItem.lrcStringItems.count ; i++) {
        itemStr = self.lrcItem.lrcStringItems[i];
        itemFrame = [self.lrcItem.lrcStringFrames[i] CGRectValue];
        wholeLength += itemFrame.size.width;
        [itemStr drawInRect:itemFrame withAttributes:attributes];
    }
    // 如果进度为0就不必要画以下的操作了
    if ( self.currPrecent == 0 || wholeLength == 0) return;
    // 长度最长的肯定是第一行了
    itemFrame = [self.lrcItem.lrcStringFrames[0] CGRectValue];
    // 画找色歌词
    CGFloat drawWidth = 0;
    // 每行的高度都一样
    CGFloat itemFrameH = itemFrame.size.height;
    // 各行歌词的最大宽度肯定在第一行
    CGFloat itemFrameW = itemFrame.size.width;
    // 每一行歌词都是从相同的x开始画
    CGFloat itemFrameX = itemFrame.origin.x;
    CGFloat itemFrameY = 0;
    // 字体的颜色
    NSMutableDictionary *dict = [attributes mutableCopy];
    dict[NSForegroundColorAttributeName] = [UIColor redColor];
    attributes = dict;
    // 要画的总宽度
    drawWidth = self.currPrecent * wholeLength;
    // 要画一行
    if ( drawWidth <= itemFrameW ) {
        itemStr = self.lrcItem.lrcStringItems[0];
        // 画蒙版
        itemFrameY = itemFrame.origin.y;
        CGRect drawFrame = CGRectMake(itemFrameX, itemFrameY, drawWidth, itemFrameH);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:drawFrame];
        [path addClip];
        [[UIColor redColor] set];
        [itemStr drawInRect:itemFrame withAttributes:attributes];
    } else { // 画多行
        // 计算要画多少行
        NSInteger row = drawWidth / itemFrameW;
        // 在最后一行之前都是画满的
        for (NSInteger i = 0; i <= row -1; i++) {
            itemStr = self.lrcItem.lrcStringItems[i];
            // 画蒙版
            itemFrameY = itemFrame.origin.y + itemFrameH * i;
            CGRect drawFrame = CGRectMake(itemFrameX, itemFrameY, itemFrameW, itemFrameH);
            [itemStr drawInRect:drawFrame withAttributes:attributes];
            // 没画一行就减少一段宽度,方便画最后一行
            drawWidth -= itemFrameW;
        }
        // 画最后一行
        itemStr = self.lrcItem.lrcStringItems[row];
        itemFrame = [self.lrcItem.lrcStringFrames[row] CGRectValue];
        itemFrameY += itemFrameH;
        CGRect targetFrame = CGRectMake(itemFrameX, itemFrameY, drawWidth, itemFrameH);
        CGRect targetStrFrame = [self.lrcItem.lrcStringFrames[row] CGRectValue];;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:targetFrame];
        [path addClip];
        [itemStr drawInRect:targetStrFrame withAttributes:attributes];
        
    }
}




@end
