//
//  UserAlbumViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "UserAlbumViewModel.h"

@implementation UserAlbumViewModel

- (instancetype)init {
    if (self = [super init]) {
        _albummList = [NSMutableArray array];
    }
    return self;
}


/**
 请求数据
 
 @param uId 用户id
 @param success 成功
 @param failture 失败
 */
- (void)getUserAlbumListWithUID:(NSString *)uId success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    @weakSelf(self);
    [[WebManager sharedManager] getUserAlbumsListWithUserId:uId success:^(NSArray *abumsList) {
        if (weakSelf.albummList.count) {
            [weakSelf.albummList removeAllObjects];
        }
        [weakSelf.albummList addObjectsFromArray:abumsList];
        success(YES);
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
