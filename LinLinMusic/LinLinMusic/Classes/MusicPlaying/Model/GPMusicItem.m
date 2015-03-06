//
//  GPMusicItem.m
//  LinLinMusic
//
//  Created by mac on 15-1-25.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "GPMusicItem.h"

@implementation GPMusicItem

- (instancetype)initWithURL:(NSURL *)url{
    if ( self = [super init] ) {
        self.url = url;
    }
    return self;
}

+ (instancetype)musicItemWithURL:(NSURL *)url{
    return [[self alloc] initWithURL:url];
}

- (BOOL)isEqual:(id)object{
    if ( ![object isKindOfClass:[self class]] )return NO;
    GPMusicItem *item = (GPMusicItem *)object;
    return [item.url.absoluteString isEqualToString:self.url.absoluteString];
}

@end
