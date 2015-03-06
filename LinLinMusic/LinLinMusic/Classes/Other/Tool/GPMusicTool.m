//
//  GPMusicTool.m
//  LinLinMusic
//
//  Created by mac on 15-2-8.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "GPMusicTool.h"
#import <AFNetworking.h>
#import "NSString+Regex.h"

@interface GPMusicTool ()

@property (nonatomic,copy) NSString *xiamiToken;

@end

@implementation GPMusicTool
singtonImplement(MusicTool)

- (void)setUpToken{
    if ( _xiamiToken == nil ) {
        NSString *regex = @"var _xiamitoken\\s=\\s'.*'";
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:@"http://www.xiami.com/web/spark" parameters:nil success:^(NSURLSessionDataTask *task, NSData *data) {
            NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [html findStringByRegular:regex usingBlock:^(NSString *item, NSRange range, BOOL *stop) {
                NSRange r = [item rangeOfString:@"'.*'" options:NSRegularExpressionSearch];
                _xiamiToken = [item substringWithRange:NSMakeRange(r.location + 1
                                                                   , r.length - 2)];
                NSLog(@"%@",_xiamiToken);
                *stop = YES;
            }];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"fail--%@",error);
        }];
    }
}



@end
