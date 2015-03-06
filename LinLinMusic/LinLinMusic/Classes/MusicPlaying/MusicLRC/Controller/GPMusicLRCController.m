//
//  GPMusicLRCController.m
//  LinLinMusic
//
//  Created by mac on 15-1-27.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "GPMusicLRCController.h"
#import "GPLRCViewItem.h"
#import "GPMusicCell.h"

@interface GPMusicLRCController ()

@property (nonatomic,strong) NSArray *lrcViewItems;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,strong) NSIndexPath *currPlayIndexPath;

@end

@implementation GPMusicLRCController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialTableView];
}

- (void)initialTableView{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = [GPMusicCell defaultRowHeight];
    // 初始化第一行
    self.currPlayIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    // 添加监听歌词变化(主要用于换行)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRow:) name:GPUpdateLRCIndexPathNotification object:nil];
    
    // 监听每行歌词的变化(颜色变化)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMusicLRCColor:) name:GPUpdateLRCColorNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSIndexPath *)indexPath{
    if ( _indexPath == nil ) {
        _indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return _indexPath;
}

#pragma mark - 监听每一行歌词的颜色变化
- (void)updateMusicLRCColor:(NSNotification *)notification{
    GPMusicCell *cell = (GPMusicCell *)[self.tableView cellForRowAtIndexPath:self.currPlayIndexPath];
    CGFloat progreePrecent = [notification.userInfo[GPUpdateLRCColorKey] floatValue];
    cell.currItemPrecent  = progreePrecent;
    
}

#pragma mark - 监听换行的方法
- (void)updateRow:(NSNotification *)notification{
    NSIndexPath *indexPath = notification.userInfo[GPUpdateLRCIndexPathKey];
    // 先取消之前那一行的歌词播放
    GPMusicCell *cell = (GPMusicCell *)[self.tableView cellForRowAtIndexPath:self.currPlayIndexPath];
    cell.currItemPrecent = 0;
    
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    self.currPlayIndexPath = indexPath;
}


- (NSArray *)lrcViewItems{
    if ( _lrcViewItems == nil ) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"a.lrc" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        _lrcViewItems = [GPLRCViewItem lrcViewItemsWithData:data];
    }
    return _lrcViewItems;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lrcViewItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPLRCViewItem *item = self.lrcViewItems[indexPath.row];
    GPMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:[GPMusicCell cellID]];
    cell.lrcItem = item;
    cell.currItemPrecent = 0;
    return cell;
}



@end
