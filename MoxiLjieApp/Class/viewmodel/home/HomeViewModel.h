//
//  HomeViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/10/24.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface HomeViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray *nowList;

/**
 请求数据
 
 @param success 成功
 @param failture 失败
 */
- (void)getNowListSuccess:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
