//
//  HomeViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "HomeViewModel.h"

@implementation HomeViewModel

- (instancetype)init {
    if (self = [super init]) {
        _nowList = [NSMutableArray array];
    }
    return self;
}

/**
 请求数据
 
 @param success 成功
 @param failture 失败
 */
- (void)getNowListSuccess:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    @weakSelf(self);
    [[WebManager sharedManager] getNowRadioListWithSuccess:^(NSArray *nowList) {
        if (weakSelf.nowList.count) {
            [weakSelf.nowList removeAllObjects];
        }
        [weakSelf.nowList addObjectsFromArray:nowList];
        success(YES);
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
