//
//  UserAlbumViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface UserAlbumViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray *albummList;

/**
 请求数据
 
 @param uId 用户id
 @param success 成功
 @param failture 失败
 */
- (void)getUserAlbumListWithUID:(NSString *)uId success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
