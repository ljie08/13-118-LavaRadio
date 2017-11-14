//
//  UserListViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/9.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface UserListViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray *programList;//节目
//@property (nonatomic, strong) NSMutableArray *collectList;//收藏

/**
 请求节目数据
 
 @param uId 用户id
 @param type //1 收藏 。2 节目
 @param success 成功
 @param failture 失败
 */
- (void)getUserProgramListWithUID:(NSString *)uId type:(NSInteger)type success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

/**
 请求收藏数据
 
 @param uId 用户id
 @param success 成功
 @param failture 失败
 */
//- (void)getUserCollectListWithUID:(NSString *)uId success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
