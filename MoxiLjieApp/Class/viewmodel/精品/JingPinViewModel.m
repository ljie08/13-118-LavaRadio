//
//  JingPinViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "JingPinViewModel.h"

@implementation JingPinViewModel

- (instancetype)init {
    if (self = [super init]) {
        _jingpinArr = [NSMutableArray array];
    }
    return self;
}

/**
 请求数据
 
 @param success 成功
 @param failture 失败
 */
- (void)getJingPinListWithSuccess:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    @weakSelf(self);
    [[WebManager sharedManager] getWonderfulRadioWithSuccess:^(NSArray *wonderfulList) {
        if (weakSelf.jingpinArr.count) {
            [weakSelf.jingpinArr removeAllObjects];
        }
        [weakSelf.jingpinArr addObjectsFromArray:wonderfulList];
        success(YES);
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
