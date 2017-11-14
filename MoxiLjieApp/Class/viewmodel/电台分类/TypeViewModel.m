//
//  TypeViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "TypeViewModel.h"

@implementation TypeViewModel

- (instancetype)init {
    if (self = [super init]) {
        _nameArr = [NSMutableArray array];
//        _nameArr = @[@"1111", @"2221", @"33214"];
        _channelsArr = [NSMutableArray array];
    }
    return self;
}

/**
 请求数据
 
 @param isRefresh 是否刷新
 @param success 成功
 @param failture 失败
 */
- (void)getTypeDataWithSuccess:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    @weakSelf(self);
    [[WebManager sharedManager] getAllRadioSuccess:^(NSArray *typeDataArr) {
        if (weakSelf.nameArr.count) {
            [weakSelf.nameArr removeAllObjects];
        }
        if (weakSelf.channelsArr.count) {
            [weakSelf.channelsArr removeAllObjects];
        }
        
        for (TypeData *type in typeDataArr) {
            [weakSelf.nameArr addObject:type.radio_name];
            type.channels = [Channels mj_objectArrayWithKeyValuesArray:type.channels];
        }
        [weakSelf.channelsArr addObjectsFromArray:typeDataArr];
        
        success(YES);
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
