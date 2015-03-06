//
//  GPNetWorkingManager.m
//  LinLinMusic
//
//  Created by mac on 15-2-8.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "GPNetWorkingManager.h"
#import <AFNetworking.h>

@interface GPNetWorkingManager ()
@property (nonatomic,strong) AFURLSessionManager *manager;
@end

@implementation GPNetWorkingManager
singtonImplement(NetWorkingManager)

- (instancetype)init{
    if ( self = [super init] ) {
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] init];
        self.manager = manager;
    }
    return self;
}

- (void)getWithURLString:(NSString *)urlString completionHandler:(GPNetWorkingManagerCompletionHandler)completionHandler{
    [self.manager dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        completionHandler(response,responseObject,error);
    }];
}

@end
