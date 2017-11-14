//
//  ProgramsViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/8.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface ProgramsViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray *channelsArr;

/**
 请求数据
 
 @param channelid 频道id
 @param success 成功
 @param failture 失败
 */
- (void)getProgramsWithChannelID:(NSString *)channelid success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
