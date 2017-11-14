//
//  SongViewModel.h
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/10.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "BaseViewModel.h"

@interface SongViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray *songList;
@property (nonatomic, strong) Program *program;

/**
 请求数据
 
 @param programId 节目id
 @param success 成功
 @param failture 失败
 */
- (void)getSongListWithProgramID:(NSString *)programId success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture;

@end
