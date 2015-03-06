//
//  GPMusicQueueId.m
//  LinLinMusic
//
//  Created by mac on 15-1-25.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "GPMusicQueueId.h"

@implementation GPMusicQueueId

-(id) initWithUrl:(NSURL*)url andCount:(int)count
{
    if (self = [super init])
    {
        self.url = url;
        self.count = count;
    }
    
    return self;
}

-(BOOL) isEqual:(id)object
{
    if (object == nil)
    {
        return NO;
    }
    
    if ([object class] != [GPMusicQueueId class])
    {
        return NO;
    }
    
    return [((GPMusicQueueId*)object).url isEqual: self.url] && ((GPMusicQueueId*)object).count == self.count;
}

-(NSString*) description
{
    return [self.url description];
}

@end
