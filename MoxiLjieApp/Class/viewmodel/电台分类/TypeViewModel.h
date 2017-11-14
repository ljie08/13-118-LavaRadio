//
//  TypeViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface TypeViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSMutableArray *channelsArr;

/**
 请求数据
 
 @param success 成功
 @param failture 失败
 */
- (void)getTypeDataWithSuccess:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
