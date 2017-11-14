//
//  UserPhotoViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "UserPhotoViewModel.h"

@implementation UserPhotoViewModel

- (instancetype)init {
    if (self = [super init]) {
        _picList = [NSMutableArray array];
    }
    return self;
}


/**
 请求数据
 
 @param albumId 相册id
 @param success 成功
 @param failture 失败
 */
- (void)getAlbumPicListWithAlbumID:(NSString *)albumId success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    @weakSelf(self);
    [[WebManager sharedManager] getUserPhotosListWithAlbumId:albumId success:^(NSArray *photosList) {
        if (weakSelf.picList.count) {
            [weakSelf.picList removeAllObjects];
        }
        [weakSelf.picList addObjectsFromArray:photosList];
        success(YES);
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
