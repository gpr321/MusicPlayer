//
//  GPLRCViewItem.h
//  LinLinMusic
//
//  Created by mac on 15-1-26.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPMusicLRC;

@interface GPLRCViewItem : NSObject
{
    NSDictionary *_attributes;
}

@property (nonatomic,strong) GPMusicLRC *lrcModel;

@property (nonatomic,strong) NSDictionary *attributes;

@property (nonatomic,assign,readonly) CGSize wordSize;

/** 歌词要分多少行来显示,这个属性要设置给 LRCView 之后才有值 */
@property (nonatomic,strong) NSArray *lrcStringItems;
/** 每一行歌词显示的尺寸,这个属性要设置给 LRCView 之后才有值 */
@property (nonatomic,strong) NSArray *lrcStringFrames;
/** 每一行歌词显示的高度,这个属性要设置给 LRCView 之后才有值 */
@property (nonatomic,assign) CGFloat lrcShowHeith;

- (instancetype)initWithLrcModel:(GPMusicLRC *)lrcModel attributes:(NSDictionary *)attributes;

+ (instancetype)lrfViewItemWithLrcModel:(GPMusicLRC *)lrcModel attributes:(NSDictionary *)attributes;

+ (NSArray *)lrcViewItemsWithData:(NSData *)data;


@end
