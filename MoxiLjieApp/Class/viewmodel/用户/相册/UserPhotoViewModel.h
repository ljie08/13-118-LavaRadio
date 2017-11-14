//
//  UserPhotoViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface UserPhotoViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray *picList;

/**
 请求数据
 
 @param albumId 相册id
 @param success 成功
 @param failture 失败
 */
- (void)getAlbumPicListWithAlbumID:(NSString *)albumId success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
