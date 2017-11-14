//
//  UserListViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "UserListViewModel.h"

@implementation UserListViewModel

- (instancetype)init {
    if (self = [super init]) {
        _programList = [NSMutableArray array];
    }
    return self;
}

/**
 请求节目数据
 
 @param uId 用户id
 @param type //1 收藏 。2 节目
 @param success 成功
 @param failture 失败
 */
- (void)getUserProgramListWithUID:(NSString *)uId type:(NSInteger)type success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    @weakSelf(self);
    if (type == 1) {
        [[WebManager sharedManager] getCollectProgramsListWithUserId:uId success:^(NSArray *programsList) {
            if (weakSelf.programList.count) {
                [weakSelf.programList removeAllObjects];
            }
            [weakSelf.programList addObjectsFromArray:programsList];
            success(YES);
        } failure:^(NSString *errorStr) {
            failture(errorStr);
        }];
    } else {
        [[WebManager sharedManager] getUserProgramListWithUserId:uId success:^(NSArray *programsList) {
            if (weakSelf.programList.count) {
                [weakSelf.programList removeAllObjects];
            }
            [weakSelf.programList addObjectsFromArray:programsList];
            success(YES);
        } failure:^(NSString *errorStr) {
            failture(errorStr);
        }];
    }
}

@end
