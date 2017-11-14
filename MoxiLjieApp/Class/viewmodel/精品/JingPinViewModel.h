//
//  JingPinViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface JingPinViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray *jingpinArr;

/**
 请求数据
 
 @param success 成功
 @param failture 失败
 */
- (void)getJingPinListWithSuccess:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
