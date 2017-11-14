//
//  ProgramsViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "ProgramsViewModel.h"

@implementation ProgramsViewModel

- (instancetype)init {
    if (self = [super init]) {
        _channelsArr = [NSMutableArray array];
    }
    return self;
}

/**
 请求数据
 
 @param channelid 频道id
 @param success 成功
 @param failture 失败
 */
- (void)getProgramsWithChannelID:(NSString *)channelid success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    @weakSelf(self);
    [[WebManager sharedManager] getChannerlProgramListWithChannelId:channelid success:^(NSArray *channelList) {
        if (weakSelf.channelsArr.count) {
            [weakSelf.channelsArr removeAllObjects];
        }
        [weakSelf.channelsArr addObjectsFromArray:channelList];
        
        success(YES);
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
