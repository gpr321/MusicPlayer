//
//  GPLRCViewItem.m
//  LinLinMusic
//
//  Created by mac on 15-1-26.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

/** 默认歌词的字体 */
#define defaultFont [UIFont systemFontOfSize:15]

#import "GPLRCViewItem.h"
#import "GPMusicLRC.h"

@implementation GPLRCViewItem

- (instancetype)initWithLrcModel:(GPMusicLRC *)lrcModel attributes:(NSDictionary *)attributes{
    if ( self = [super init] ) {
        self.lrcModel = lrcModel;
        self.attributes = attributes;
        [self initialFontStyle];
    }
    return self;
}

+ (instancetype)lrfViewItemWithLrcModel:(GPMusicLRC *)lrcModel attributes:(NSDictionary *)attributes{
    return [[self alloc] initWithLrcModel:lrcModel attributes:attributes];
}


- (NSDictionary *)attributes{
    if ( _attributes == nil ) {
        _attributes = @{NSFontAttributeName : defaultFont};
    }
    return _attributes;
}

- (void)setAttributes:(NSDictionary *)attributes{
    _attributes = attributes;
    [self initialFontStyle];
}

- (void)initialFontStyle{
    NSString *word = @"国";
    _wordSize = [word sizeWithAttributes:self.attributes];
}

+ (NSArray *)lrcViewItemsWithData:(NSData *)data{
    NSArray *lrcModels = [GPMusicLRC musicLRCsFromData:data];
    NSMutableArray *lrcs = [NSMutableArray arrayWithCapacity:lrcModels.count];
    GPLRCViewItem *temp = nil;
    for (GPMusicLRC *item in lrcModels) {
        temp = [GPLRCViewItem lrfViewItemWithLrcModel:item attributes:nil];
        [lrcs addObject:temp];
    }
    return lrcs;
}

- (NSString *)description{
    return self.lrcModel.lrcString;
}

@end
