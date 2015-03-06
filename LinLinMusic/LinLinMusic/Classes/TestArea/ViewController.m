//
//  ViewController.m
//  LinLinMusic
//
//  Created by mac on 15-1-25.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "ViewController.h"
#import "GPNetWorkingManager.h"
#import <AFNetworking.h>
#import "NSString+Regex.h"
#import "GPMusicTool.h"

@interface ViewController ()<UIWebViewDelegate,NSURLConnectionDataDelegate>
@property (nonatomic,strong) AFURLSessionManager *manager;

@property (weak, nonatomic) IBOutlet UIView *myView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[GPMusicTool shareMusicTool] setUpToken];
}


@end
