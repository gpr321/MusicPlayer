//
//  GPNetWorkingManager.h
//  LinLinMusic
//
//  Created by mac on 15-2-8.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPSingleTon.h"

typedef void (^GPNetWorkingManagerCompletionHandler)(NSURLResponse *response, id responseObject, NSError *error);

@interface GPNetWorkingManager : NSObject<NSCopying>
singtonInterface(NetWorkingManager)

- (void)getWithURLString:(NSString *)urlString completionHandler:(GPNetWorkingManagerCompletionHandler)completionHandler;

@end
