//
//  SongViewModel.m
//  MoxiLjieApp
//
//  Created by ljie on 2017/11/10.
//  Copyright © 2017年 AppleFish. All rights reserved.
//

#import "SongViewModel.h"

@implementation SongViewModel

- (instancetype)init {
    if (self = [super init]) {
        _songList = [NSMutableArray array];
        _program = [[Program alloc] init];
    }
    return self;
}

/**
 请求数据
 
 @param success 成功
 @param failture 失败
 */
- (void)getSongListWithProgramID:(NSString *)programId success:(void(^)(BOOL result))success failture:(void(^)(NSString *error))failture {
    @weakSelf(self);
    [[WebManager sharedManager] getPlayProgramWithProgramId:programId success:^(Program *program, NSArray *songs) {
        if (weakSelf.songList.count) {
            [weakSelf.songList removeAllObjects];
        }
        [weakSelf.songList addObjectsFromArray:songs];
        weakSelf.program = program;
        success(YES);
        
    } failure:^(NSString *errorStr) {
        failture(errorStr);
    }];
}

@end
